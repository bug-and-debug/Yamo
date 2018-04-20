//
//  LOCCameraInterface.h
//  LOCCameraView
//
//  Created by Peter Su on 11/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import AVFoundation;

@protocol LOCCameraDelegate;

@protocol LOCCameraInterface <NSObject>

@property (nonatomic, weak) id <LOCCameraDelegate> delegate;

/*
 *  Maximum duration for recording videos
 *  If set to 0 or less than it indicates there is no limit
 */
@property (nonatomic) NSInteger maxVideoDuration;

- (void)updatePreset:(NSString *)preset;

#pragma mark Flash

- (BOOL)deviceHasFlash;

- (AVCaptureFlashMode)currentFlashMode;

- (void)updateDeviceFlashMode:(AVCaptureFlashMode)mode;

- (void)toggleFlashMode;

#pragma mark Torch

- (BOOL)deviceHasTorch;

- (AVCaptureTorchMode)currentTorchMode;

- (void)updateDeviceTorchMode:(AVCaptureTorchMode)mode;

- (void)toggleTorchMode;

#pragma mark Camera

- (AVCaptureDevicePosition)positionForCamera;

- (void)toggleCameraPosition;

#pragma mark Focus

- (BOOL)deviceSupportsFocus;

- (void)focusShotAtPoint:(CGPoint)point;

- (UIView *)viewForFocusOverlay;

- (void)showFocusViewAtPoint:(CGPoint)point;

#pragma mark Capture

- (void)startCapture;

@end

/*
 *  Might want to refactor this to separator the video and image delegates separately
 */

@protocol LOCCameraDelegate <NSObject>

#pragma mark - Focus

- (void)cameraController:(id <LOCCameraInterface>)cameraController didFocusViewAtPoint:(CGPoint)point;

#pragma mark - Photo

- (void)cameraController:(id <LOCCameraInterface>)cameraController didCaptureImage:(UIImage *)image;

#pragma mark - Video

- (void)cameraController:(id <LOCCameraInterface>)cameraController didStartCaptureVideoAtURL:(NSURL *)fileURL;

- (void)cameraController:(id <LOCCameraInterface>)cameraController didFinishCaptureVideoAtURL:(NSURL *)fileURL;

- (void)cameraController:(id <LOCCameraInterface>)cameraController remainingTimeForRecordVideo:(long long)remaining;

@end

