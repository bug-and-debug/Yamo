//
//  LOCCameraViewController.m
//  LOCCameraView
//
//  Created by Peter Su on 26/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCameraViewController.h"
#import "LOCCameraNoPermissionOverlay.h"
#import "LOCCameraPermission.h"
#import "UIImage+LOCCameraView.h"
#import "LOCCameraFocus.h"

static NSInteger LOCCameraDefaultVideoDuration = 10;

@interface LOCCameraViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, retain) AVCaptureMovieFileOutput *videoRecordingOutput;

@property (nonatomic) UIDeviceOrientation currentDeviceOrientation;

@property (nonatomic, strong) NSString *defaultPreset;

@property (nonatomic, readwrite) LOCCameraMode mode;

@property (nonatomic) BOOL isTakingPhoto;

@property (nonatomic, strong) NSTimer *videoTimer;

@property (nonatomic, strong) UIView *focusView;

@property (nonatomic, strong) NSLayoutConstraint *focusViewLeadingConstraint;

@property (nonatomic, strong) NSLayoutConstraint *focusViewTopConstraint;

@end

@implementation LOCCameraViewController

@synthesize delegate, maxVideoDuration;

- (void)dealloc {
    
    if (self.videoTimer && self.videoTimer.valid) {

        [self.videoTimer invalidate];
    }
    
    if (self.focusView) {
        [self.focusView removeFromSuperview];
        
        self.focusView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
    
    for (AVCaptureDeviceInput *input in self.captureSession.inputs) {
        [self.captureSession removeInput:input];
    }
    
    if (self.stillImageOutput) {
        [self.captureSession removeOutput:self.stillImageOutput];
    }
    
    if (self.videoRecordingOutput) {
        [self.captureSession removeOutput:self.videoRecordingOutput];
    }
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.captureSession = nil;
}

- (instancetype)initWithMode:(LOCCameraMode)mode {
    
    if (self = [super init]) {
        
        self.mode = mode;
        [self setViewDefaultProperties];
        [self setup];
    }
    
    return self;
}

- (instancetype)init {
    
    return [self initWithMode:LOCCameraModeTakePhoto];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    return [self initWithMode:LOCCameraModeTakePhoto];
}

- (void)switchMode:(LOCCameraMode)mode {
    
    self.mode = mode;
    [self resetCaptureSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateOrientation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.previewLayer){
        self.previewLayer.frame = self.view.bounds;
    }
}

#pragma mark - Orientation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateOrientation];
}

- (void)updateOrientation {
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    self.currentDeviceOrientation = currentDevice.orientation;
    
    if (self.previewLayer.connection) {
        
        AVCaptureConnection *previewLayerConnection = self.previewLayer.connection;
        
        if ([previewLayerConnection isVideoOrientationSupported]) {
            
            [previewLayerConnection setVideoOrientation:[self videoOrientationForDeviceOrientation:self.currentDeviceOrientation]];
        }
    }
    
    if (self.mode == LOCCameraModeRecordVideo) {
        [self updateVideoRecordingOrientationForDeviceOrientation:currentDevice.orientation];
    }
}

- (void)updateVideoRecordingOrientationForDeviceOrientation:(UIDeviceOrientation)orientation {
    
    if (self.videoRecordingOutput) {
        
        AVCaptureConnection *connection = [self.videoRecordingOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([connection isVideoOrientationSupported]) {
            
            [connection setVideoOrientation:[self videoOrientationForDeviceOrientation:self.currentDeviceOrientation]];
        }
    }
}

- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIDeviceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIDeviceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return AVCaptureVideoOrientationPortrait;
    }
}

#pragma mark - Setup

- (void)setup {
    
    if (self.captureSession) {
        return;
    }
    
    //Capture Session
    self.view.backgroundColor = [UIColor blackColor];
    
    // Check permission
    
#if !TARGET_IPHONE_SIMULATOR
    if ([LOCCameraPermission isCameraAvailable] && [LOCCameraPermission doesCameraSupportTakingPhotos]) {
        
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authorizationStatus) {
            case AVAuthorizationStatusNotDetermined: {
                // Ask for permission
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Set camera
                        if (granted) {
                            
                            [self layoutForAuthorized];
                        } else {
                            
                            [self layoutForDeniedForState:LOCCameraStateDeniedOrRestricted];
                        }
                    });
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self layoutForAuthorized];
                break;
            }
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied: {
                [self layoutForDeniedForState:LOCCameraStateDeniedOrRestricted];
            }
            default:
                break;
        }
    } else {
        
        // Show user facing label with denied/restricted text as device has no camera
        [self layoutForDeniedForState:LOCCameraStateNoCamera];
    }
    
#else
    [self layoutForDeniedForState:LOCCameraStateSimulator];
#endif
    
}

- (void)layoutForAuthorized {
    
    self.captureSession = [[AVCaptureSession alloc]init];
    self.captureSession.sessionPreset = self.defaultPreset;
    
    // Set camera
    [self setupCamera];
}

- (void)layoutForDeniedForState:(LOCCameraState)state {
    
    // Show user facing label with denied/restricted text
    // Attach no permissions overlay
    UIView *noPermissionsOverlay = [self noPermissionOverlayForState:state];
    [self.view addSubview:noPermissionsOverlay];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:noPermissionsOverlay attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:noPermissionsOverlay attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:noPermissionsOverlay attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:noPermissionsOverlay attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}

#pragma mark - Camera

- (void)setupCamera {
    
    //Preview Layer
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.frame = CGRectZero;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapOnPreview:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.focusView = [self viewForFocusOverlay];
    self.focusView.alpha = 0.0f;
    [self.view addSubview:self.focusView];
    self.focusViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.focusView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    self.focusViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.focusView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:self.focusViewLeadingConstraint];
    [self.view addConstraint:self.focusViewTopConstraint];

    [self resetCaptureSession];
}

- (void)resetCaptureSession {
    
    [self.captureSession stopRunning];
    
    // Remove input and outputs
    for (AVCaptureDeviceInput *input in self.captureSession.inputs) {
        [self.captureSession removeInput:input];
    }
    
    for (AVCaptureOutput *output in self.captureSession.outputs) {
        [self.captureSession removeOutput:output];
    }
    
    self.stillImageOutput = nil;
    self.videoRecordingOutput = nil;
    
    [self setCaptureInput];
    [self setCaptureOutput];
    
    [self.captureSession startRunning];
}

- (void)setCaptureInput {
    //Add device - Default is back camera
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    
    if (!device) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if ([device lockForConfiguration:nil]) {
        
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
//        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
//            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
//        }
        
        [device unlockForConfiguration];
    }
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.captureSession addInput:input];
    
    if (self.mode == LOCCameraModeRecordVideo) {
        
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
        [self.captureSession addInput:audioInput];
    }
}

- (void)setCaptureOutput {
    
    switch (self.mode) {
        case LOCCameraModeTakePhoto: {
            [self setSessionWithImageOutput];
            break;
        }
        case LOCCameraModeRecordVideo: {
            [self setSessionWithVideoOutput];
            break;
        }
        default: {
            [self setSessionWithImageOutput];
            break;
        }
    }
}

- (void)setSessionWithImageOutput {
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.captureSession canAddOutput:self.stillImageOutput]) {
        [self.captureSession addOutput:self.stillImageOutput];
    }
}

- (void)setSessionWithVideoOutput {
    
    self.videoRecordingOutput = [[AVCaptureMovieFileOutput alloc] init];
    if (self.maxVideoDuration > 0) {
        self.videoRecordingOutput.maxRecordedDuration = CMTimeMake(self.maxVideoDuration, 1);
    }
    
    if ([self.captureSession canAddOutput:self.videoRecordingOutput]) {
        [self.captureSession addOutput:self.videoRecordingOutput];
    }
}

#pragma mark - Actions

- (void)handleDidTapOnPreview:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    CGPoint location = [tapGestureRecognizer locationInView:self.view];
    [self focusShotAtPoint:location];
}

#pragma mark - LOCCameraInterface

- (void)updatePreset:(NSString *)preset {
    
    if (self.captureSession) {
        self.captureSession.sessionPreset = preset;
    }
}

#pragma mark Flash

- (BOOL)deviceHasFlash {
    
    AVCaptureDeviceInput *currentCameraInput = [self cameraInput];
    
    if (currentCameraInput) {
        
        AVCaptureDevice *device = currentCameraInput.device;
        return [device hasFlash];
    }
    
    return NO;
}

- (AVCaptureFlashMode)currentFlashMode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasFlash]) {
            
            return device.flashMode;
        }
    }
    
    return AVCaptureFlashModeOff;
}

- (void)updateDeviceFlashMode:(AVCaptureFlashMode)mode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasFlash]) {
            [device lockForConfiguration:nil];
            
            device.flashMode = mode;
        }
    }
}

- (void)toggleFlashMode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasFlash]) {
            switch (device.flashMode) {
                case AVCaptureFlashModeOff:
                    [self updateDeviceFlashMode:AVCaptureFlashModeOn];
                    break;
                case AVCaptureFlashModeOn:
                    [self updateDeviceFlashMode:AVCaptureFlashModeAuto];
                    break;
                case AVCaptureFlashModeAuto:
                    [self updateDeviceFlashMode:AVCaptureFlashModeOff];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark Torch

- (BOOL)deviceHasTorch {
    
    AVCaptureDeviceInput *currentCameraInput = [self cameraInput];
    
    if (currentCameraInput) {
        
        AVCaptureDevice *device = currentCameraInput.device;
        return [device hasTorch];
    }
    
    return NO;
}

- (AVCaptureTorchMode)currentTorchMode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasTorch]) {
            
            return device.torchMode;
        }
    }
    
    return AVCaptureTorchModeOff;
}

- (void)updateDeviceTorchMode:(AVCaptureTorchMode)mode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            
            device.torchMode = mode;
        }
    }
}

- (void)toggleTorchMode {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        AVCaptureDevice *device = cameraInput.device;
        if ([device hasTorch]) {
            switch (device.torchMode) {
                case AVCaptureTorchModeOff: {
                    [self updateDeviceTorchMode:AVCaptureTorchModeOn];
                    break;
                }
                case AVCaptureTorchModeOn: {
                    [self updateDeviceTorchMode:AVCaptureTorchModeAuto];
                    break;
                }
                case AVCaptureTorchModeAuto: {
                    [self updateDeviceTorchMode:AVCaptureTorchModeOff];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

#pragma mark Camera

- (AVCaptureDevicePosition)positionForCamera {
    
    AVCaptureDeviceInput *cameraInput = [self cameraInput];
    
    if (cameraInput) {
        return cameraInput.device.position;
    }
    
    return AVCaptureDevicePositionUnspecified;
}

- (void)toggleCameraPosition {
    
    if (self.captureSession) {
        
        AVCaptureDevicePosition currentDevicePosition = [self positionForCamera];
        AVCaptureDevicePosition newDevicePosition;
        
        switch (currentDevicePosition) {
            case AVCaptureDevicePositionFront:
                newDevicePosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                newDevicePosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionUnspecified:
                newDevicePosition = AVCaptureDevicePositionBack;
                break;
                
            default:
                newDevicePosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDeviceInput *cameraInput = [self cameraInput];
        
        if (cameraInput) {
            
            [self.captureSession removeInput:cameraInput];
            AVCaptureDevice *newCamera = [self cameraWithPosition:newDevicePosition];
            
            if (newCamera) {
                
                NSError *newInputError = nil;
                AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&newInputError];
                if (newInputError) {
                    NSLog(@"Error generating new input for session: %@", newInputError.localizedDescription);
                    return;
                }
                [self.captureSession addInput:newInput];
                [self.captureSession commitConfiguration];
            }
        }
    }
    [self updateOrientation];
}

- (AVCaptureDeviceInput *)cameraInput {
    
    AVCaptureDeviceInput *cameraInput;
    if (self.captureSession) {
        for (AVCaptureDeviceInput *input in self.captureSession.inputs) {
            
            if ([input.device hasMediaType:AVMediaTypeVideo]) {
                cameraInput = input;
            }
        }
    }
    
    return cameraInput;
}

#pragma mark Focus

- (BOOL)deviceSupportsFocus {
        
        AVCaptureDeviceInput *currentCameraInput = [self cameraInput];
        
        if (currentCameraInput) {
            
            AVCaptureDevice *device = currentCameraInput.device;
            
            if (device.focusPointOfInterestSupported) {
                return YES;
            }
            
//            if (device.exposurePointOfInterestSupported) {
//                return YES;
//            }
        }
    return NO;
}

- (void)focusShotAtPoint:(CGPoint)point {
    
    if ([self deviceSupportsFocus]) {
        
        AVCaptureDeviceInput *cameraInput = [self cameraInput];
        
        if (cameraInput) {
            AVCaptureDevice *captureDevice = cameraInput.device;
            
            if (captureDevice) {
                
                if ([captureDevice lockForConfiguration:nil]) {
                    
                    if (captureDevice.focusPointOfInterestSupported) {
                        captureDevice.focusPointOfInterest = point;
                    }
                    
//                    if (captureDevice.exposurePointOfInterestSupported) {
//                        captureDevice.exposurePointOfInterest = point;
//                    }
                    
                    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                        captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                    }
                    
//                    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
//                        captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
//                    }
                    
                    [captureDevice unlockForConfiguration];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(cameraController:didFocusViewAtPoint:)]) {
            [self.delegate cameraController:self didFocusViewAtPoint:point];
        }
    }
}

- (UIView *)viewForFocusOverlay {
    
    LOCCameraFocus *view = [LOCCameraFocus new];
    view.strokeWidth = 10;
    view.guideLength = 20;
    view.strokeColor = [UIColor cyanColor];
    
    view.backgroundColor = [UIColor clearColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat const overlayDimension = 100;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:overlayDimension]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:overlayDimension]];
    
    return view;
}

- (void)showFocusViewAtPoint:(CGPoint)point {
    
    self.focusViewLeadingConstraint.constant = point.x - (CGRectGetWidth(self.focusView.bounds) / 2);
    self.focusViewTopConstraint.constant = point.y - (CGRectGetHeight(self.focusView.bounds) / 2);
    [self.view layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:2.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                      [self.view layoutIfNeeded];
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
                                      self.focusView.alpha = 1.0f;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:1.0 relativeDuration:1.0 animations:^{
                                      self.focusView.alpha = 0.0f;
                                  }];
                              }
                              completion:nil];
}

#pragma mark Capture

- (void)startCapture {
    
    switch (self.mode) {
            
        case LOCCameraModeTakePhoto: {
            
            [self takePhoto];
            break;
        }
        case LOCCameraModeRecordVideo: {
            
            [self recordVideo];
            break;
        }
    }
}

#pragma mark - Photo

- (void)takePhoto {
    
    if (self.isTakingPhoto) {
        return;
    }
    
    self.isTakingPhoto = YES;
    
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:[self videoOrientationForDeviceOrientation:self.currentDeviceOrientation]];
    }
    
    if ([videoConnection isVideoMirroringSupported]) {
        [videoConnection setVideoMirrored:([self positionForCamera] == AVCaptureDevicePositionFront)];
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                           
                                                           if (!imageDataSampleBuffer) {
                                                               return;
                                                           }
                                                           
                                                           if (!self.isTakingPhoto) {
                                                               return;
                                                           }
                                                           
                                                           AVCaptureDevicePosition devicePosition = [self positionForCamera];
                                                           NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                           UIImage *image = [UIImage rotateImage:[UIImage imageWithData:imageData]
                                                                                  forOrientation:[self orientationForDevicePosition:devicePosition]];
                                                           
                                                           if ([self.delegate respondsToSelector:@selector(cameraController:didCaptureImage:)]) {
                                                               [self.delegate cameraController:self didCaptureImage:image];
                                                           }
                                                           
                                                           self.isTakingPhoto = NO;
                                                       }];
}

- (UIDeviceOrientation)orientationForDevicePosition:(AVCaptureDevicePosition)position {
    
    if (position == AVCaptureDevicePositionFront) {
        switch (self.currentDeviceOrientation) {
            case UIDeviceOrientationPortrait:
                return UIDeviceOrientationPortrait;
            case UIDeviceOrientationPortraitUpsideDown:
                return UIDeviceOrientationPortrait;
            case UIDeviceOrientationLandscapeLeft:
                return UIDeviceOrientationLandscapeRight;
            case UIDeviceOrientationLandscapeRight:
                return UIDeviceOrientationLandscapeLeft;
            default:
                return UIDeviceOrientationPortrait;
        }
    } else {
        return self.currentDeviceOrientation;
    }
}

#pragma mark - Video

- (void)recordVideo {
    
    if (![self.videoRecordingOutput isRecording]) {
        
        NSURL *tempUrl = [self generateTempURL];
        [self.videoRecordingOutput startRecordingToOutputFileURL:tempUrl recordingDelegate:self];
        
        self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reportProgress) userInfo:nil repeats:YES];
        
    } else {
        
        [self.videoRecordingOutput stopRecording];
    }
    
}

- (void)reportProgress {
    
    long long maxDuration = (long long)CMTimeGetSeconds(self.videoRecordingOutput.maxRecordedDuration);
    long long currentRecordedDuration = (long long)CMTimeGetSeconds(self.videoRecordingOutput.recordedDuration);
    long long timeLeft = maxDuration - currentRecordedDuration;
    
    if ([self.delegate respondsToSelector:@selector(cameraController:remainingTimeForRecordVideo:)]) {
        [self.delegate cameraController:self remainingTimeForRecordVideo:timeLeft];
    }
}

- (NSURL *)generateTempURL {
    
    NSString *randomMovString = [NSString stringWithFormat:@"%@.mov", [self randomStringWithLength:10]];
    
    NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:randomMovString];
    
    [LOCCameraViewController excluseFromBackup:temporaryFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:temporaryFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:temporaryFilePath error:nil];
    }
    
    NSURL *tempUrl = [NSURL fileURLWithPath:temporaryFilePath];
    
    return tempUrl;
}

+ (void)excluseFromBackup:(NSString *)path {
    
    NSError *error = nil;
    NSURL *filePath = [NSURL fileURLWithPath:path];
    BOOL success = [filePath setResourceValue:@"YES" forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    if (!success && error) {
        NSLog(@"Error \"%@\" occurring setting resource value for path: %@", error.localizedDescription, path);
    }
}

- (NSString *)randomStringWithLength:(NSInteger)length {
    
    NSString const *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    
    for (NSInteger lengthIndex = 0; lengthIndex < length; lengthIndex++) {
        
        NSUInteger length = letters.length;
        NSUInteger characterIndex = arc4random_uniform((uint32_t)length);
        
        [randomString appendFormat:@"%C", [letters characterAtIndex:characterIndex]];
    }
    
    return randomString;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
    if ([self.delegate respondsToSelector:@selector(cameraController:didStartCaptureVideoAtURL:)]) {
        [self.delegate cameraController:self didStartCaptureVideoAtURL:fileURL];
    }
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    [self.videoTimer invalidate];
    
    if ([self.delegate respondsToSelector:@selector(cameraController:didFinishCaptureVideoAtURL:)]) {
        [self.delegate cameraController:self didFinishCaptureVideoAtURL:outputFileURL];
    }
}

#pragma mark - Helpers

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

#pragma mark - Public

- (void)setViewDefaultProperties {
    
    self.defaultPreset = AVCaptureSessionPresetHigh;
    self.maxVideoDuration = LOCCameraDefaultVideoDuration;
}

- (UIView *)noPermissionOverlayForState:(LOCCameraState)state {
    
    NSString *userFacingString = @"";
    switch (state) {
        case LOCCameraStateReady:
            break;
        case LOCCameraStateDeniedOrRestricted: {
            userFacingString = @"User has or been denied access to camera";
            break;
        }
        case LOCCameraStateNoCamera: {
            userFacingString = @"Device does not have camera";
            break;
        }
        case LOCCameraStateSimulator: {
            userFacingString = @"Using simulator, please use a real device";
            break;
        }
        default:
            break;
    }
    LOCCameraNoPermissionOverlay *noPermissionOverlay = [LOCCameraNoPermissionOverlay new];
    noPermissionOverlay.accessDeniedLabel.text = userFacingString;
    noPermissionOverlay.backgroundColor = [UIColor redColor];
    noPermissionOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    
    return noPermissionOverlay;
}

@end
