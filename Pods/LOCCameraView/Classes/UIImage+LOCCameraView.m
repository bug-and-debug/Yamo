//
//  UIImage+LOCCameraView.m
//  LOCCameraView
//
//  Created by Peter Su on 10/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImage+LOCCameraView.h"

@implementation UIImage (LOCCameraView)

+ (UIImage *)rotateImage:(UIImage *)image forOrientation:(UIDeviceOrientation)orientation {
    
    UIImageOrientation imageOrientation;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationUp ;
            break;
        case UIDeviceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationDown;
            break;
        default:
            imageOrientation = UIImageOrientationRight;
            break;
    }
    
    return [image fastttRotatedImageMatchingOrientation:imageOrientation];
}

- (UIImage *)fastttRotatedImageMatchingOrientation:(UIImageOrientation)orientation
{
    if (self.imageOrientation == orientation) {
        return self;
    }
    
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:orientation];
}

@end
