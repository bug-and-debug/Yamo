//
//  UIImage+LOCColor.h
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LOCColor)

#pragma mark - color
- (UIColor *)colorAtPixel:(CGPoint)point;
- (UIImage *)asGrayscale:(BOOL)forceBlack;
- (UIImage *)tintWithColor:(UIColor *)color andMask:(UIImage *)imageMask;
- (UIImage *)tintWithColor:(UIColor *)tintColor;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
