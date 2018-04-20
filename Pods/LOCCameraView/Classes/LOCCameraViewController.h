//
//  LOCCameraViewController.h
//  LOCCameraView
//
//  Created by Peter Su on 26/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"LOCCameraInterface.h"

typedef NS_ENUM(NSInteger, LOCCameraMode) {
    LOCCameraModeTakePhoto,
    LOCCameraModeRecordVideo
};

typedef NS_ENUM(NSInteger, LOCCameraState) {
    LOCCameraStateReady,
    LOCCameraStateDeniedOrRestricted,
    LOCCameraStateNoCamera,
    LOCCameraStateSimulator
};

@interface LOCCameraViewController : UIViewController <LOCCameraInterface>

@property (nonatomic, readonly) LOCCameraMode mode;

- (instancetype)initWithMode:(LOCCameraMode)mode;

/*
 *  Allows you to switch between take photo and record video modes
 */
- (void)switchMode:(LOCCameraMode)mode;

/*
 *  Override this to set to default preset for the camera
 */
- (void)setViewDefaultProperties;

/*
 *  View for when the user has declined permission for camera
 */
- (UIView *)noPermissionOverlayForState:(LOCCameraState)state;

@end
