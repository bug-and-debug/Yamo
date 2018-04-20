//
//  UIImage+LOCResize.h
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LOCResize)

#pragma mark - resize
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizeproportionallyToHeight:(CGFloat)height;
- (UIImage *)resizeproportionallyToWidth:(CGFloat)width;
- (UIImage *)resizedImage:(CGSize)newSize;
- (UIImage *)resizedImageWithMaxDimension:(int)maxDimension;
- (UIImage *)stretchableHeight;
- (UIImage *)stretchableWidth;
- (UIImage *)stretchable;

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;

+ (UIImage *)resizeImage:(UIImage*)sourceImagePar byScalingProportionallyToSize:(CGSize)targetSize;

@end
