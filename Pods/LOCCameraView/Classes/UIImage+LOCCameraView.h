//
//  UIImage+LOCCameraView.h
//  LOCCameraView
//
//  Created by Peter Su on 10/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LOCCameraView)

+ (UIImage *)rotateImage:(UIImage *)image forOrientation:(UIDeviceOrientation)orientation;

@end
