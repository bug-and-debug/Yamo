//
//  UIImage+Effects.m
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImage+LOCEffects.h"

@implementation UIImage (LOCEffects)

#pragma mark - effects
- (UIImage *)blurImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    CGFloat blurRadius = 8.0f;
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:inputImage forKey: @"inputImage"];
    [blurFilter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
    CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
    
    UIImage *image = [UIImage imageWithCGImage:[context createCGImage:outputImage
                                                             fromRect:CGRectMake(blurRadius, blurRadius, inputImage.extent.size.width-blurRadius*2, inputImage.extent.size.height-blurRadius*2)]];
    return image;
}

@end
