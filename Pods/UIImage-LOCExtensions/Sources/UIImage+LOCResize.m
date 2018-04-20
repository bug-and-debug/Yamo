//
//  UIImage+LOCResize.m
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImage+LOCResize.h"

@implementation UIImage (LOCResize)

#pragma mark - resize
- (UIImage *)resizeproportionallyToHeight:(CGFloat)height
{
    CGFloat width = (self.size.width*height)/self.size.height;
    return [self resizedImage:CGSizeMake(width, height)];
}

- (UIImage *)resizeproportionallyToWidth:(CGFloat)width
{
    CGFloat height = (self.size.height*width)/self.size.width;
    return [self resizedImage:CGSizeMake(width, height)];
}

- (UIImage *)resizedImage:(CGSize)newSize {
    return [self resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)stretchableHeight {
    return [self stretchableImageWithLeftCapWidth:0.0 topCapHeight:(self.size.height / 2)];
}

- (UIImage *)stretchableWidth {
    return [self stretchableImageWithLeftCapWidth:self.size.width / 2 topCapHeight:0];
}

- (UIImage *)stretchable {
    return [self stretchableImageWithLeftCapWidth:self.size.width / 2 topCapHeight:self.size.height / 2];
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

- (UIImage *)resizedImageWithMaxDimension:(int)maxDimension{
    CGSize newSize;
    
    if(self.size.width > self.size.height) {
        double ratio = self.size.height / self.size.width;
        newSize.width = maxDimension;
        newSize.height = maxDimension * ratio;
    } else {
        double ratio = self.size.width / self.size.height;
        newSize.height = maxDimension;
        newSize.width = maxDimension * ratio;
    }
    
    return [self resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
}

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+ (UIImage *)resizeImage:(UIImage*)sourceImagePar byScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = sourceImagePar;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

#pragma mark - private methods

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    //    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    //    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    //    CGImageRef imageRef = self.CGImage;
    //
    //    CGContextRef bitmap = CGBitmapContextCreate(NULL,
    //                                                newRect.size.width,
    //                                                newRect.size.height,
    //                                                CGImageGetBitsPerComponent(imageRef),
    //                                                0,
    //                                                CGImageGetColorSpace(imageRef),
    //                                                CGImageGetBitmapInfo(imageRef));
    //
    //    CGContextConcatCTM(bitmap, transform);
    //
    //    CGContextSetInterpolationQuality(bitmap, quality);
    //
    //    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    //
    //    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    //    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //
    //    CGContextRelease(bitmap);
    //    CGImageRelease(newImageRef);
    //
    //    return newImage;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newSize.width, newSize.height), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

@end
