//
//  LOCCameraPermission.h
//  LOCCameraView
//
//  Created by Peter Su on 26/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MobileCoreServices;

@interface LOCCameraPermission : NSObject

+ (BOOL)isCameraAvailable;
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                 sourceType:(UIImagePickerControllerSourceType)paramSourceType;
+ (BOOL)doesCameraSupportShootingVideos;
+ (BOOL)doesCameraSupportTakingPhotos;

//+ (BOOL)allowOverlay;
//+ (void)overlayWasDissmissedByUser;

@end
