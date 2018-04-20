//
//  LOCCameraPermission.m
//  LOCCameraView
//
//  Created by Peter Su on 26/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCameraPermission.h"

@implementation LOCCameraPermission

+ (BOOL) isCameraAvailable {
    
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera];
    
}

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                 sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    
    __block BOOL result = NO;
    
    if ([paramMediaType length] == 0){
        // Media type is empty
        return NO;
    }
    
    NSArray *availableMediaTypes =
    [UIImagePickerController
     availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    
    return result;
    
}

+ (BOOL)doesCameraSupportShootingVideos {
    
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie
                          sourceType:UIImagePickerControllerSourceTypeCamera];
    
}

+ (BOOL)doesCameraSupportTakingPhotos {
    
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];
    
}

//+ (BOOL)allowOverlay {
//    BOOL overlayWasDismissed =
//    [[NSUserDefaults standardUserDefaults] boolForKey:@"kCMCaptureOverlayDismissed"];
//    BOOL allow = NO;
//    
//    if (!overlayWasDismissed) {
//        allow = YES;
//    }
//    
//    return allow;
//}
//
//+ (void)overlayWasDissmissedByUser {
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kCMCaptureOverlayDismissed"];
//}

@end
