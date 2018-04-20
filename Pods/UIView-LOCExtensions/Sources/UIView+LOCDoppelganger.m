//
//  UIView+LOCDoppelganger.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCDoppelganger.h"
#import "UIView+LOCAlpha.h"

@implementation UIView (LOCDoppelganger)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - doppelganger
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView *) getImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [self getImage]];
    [imageView setFrame:self.frame];
    
    return imageView;
}

- (UIImage *) getImage
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *) getBlurredImageWithRadius:(CGFloat)blurRadius
{
    UIImage *image = [self getImage];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:inputImage
                  forKey:@"inputImage"];
    [blurFilter setValue:@(blurRadius)
                  forKey:@"inputRadius"];
    
    CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimage = [context createCGImage:outputImage
                                       fromRect:outputImage.extent];
    
    image = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    return image;
}

- (NSData *)getPdf
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    
    return pdfData;
}

- (void)getImageAndAddToImageView:(UIImageView *)imageView
{
    UIImage *image = [self getImage];
    [imageView hide];
    imageView.image = image;
    [imageView showAnimated];
}

- (void)getImageAndAddToButton:(UIButton *)button
{
    UIImage *image = [self getImage];
    [button hide];
    [button setImage:image forState:UIControlStateNormal];
    [button showAnimated];
}

- (void)getBlurredImageWithRadius:(CGFloat)blurRadius
                andAddToImageView:(UIImageView *)imageView
{
    __block UIImage *image = [self getImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self getBlurredImageWithRadius:blurRadius];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

- (void)getBlurredImageWithRadius:(CGFloat)blurRadius
                   andAddToButton:(UIButton *)button
{
    __block UIImage *image = [self getImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self getBlurredImageWithRadius:blurRadius];
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setBackgroundImage:image forState:UIControlStateNormal];
        });
    });
}

@end
