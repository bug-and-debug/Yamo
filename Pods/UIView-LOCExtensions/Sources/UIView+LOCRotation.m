//
//  UIView+LOCRotation.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCRotation.h"

#define Math_Radians(degrees) ((degrees / 180.0) * M_PI)
#define View_CurrentRadianRotation(UIView) atan2f(UIView.transform.b, UIView.transform.a)

@implementation UIView (LOCRotation)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - rotation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rotateTo0
{
    [self rotateToAngle:0];
}

- (void)rotateTo45
{
    [self rotateToAngle:45];
}

- (void)rotateTo90
{
    [self rotateToAngle:90];
}

- (void)rotateTo135
{
    [self rotateToAngle:135];
}

- (void)rotateTo180
{
    [self rotateToAngle:180];
}

- (void)rotateTo225
{
    [self rotateToAngle:225];
}

- (void)rotateTo270
{
    [self rotateToAngle:270];
}

- (void)rotateTo315
{
    [self rotateToAngle:315];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotate45
{
    [self rotate:45];
}

- (void)rotate90
{
    [self rotate:90];
}

- (void)rotate135
{
    [self rotate:135];
}

- (void)rotate180
{
    [self rotate:180];
}

- (void)rotate225
{
    [self rotate:225];
}

- (void)rotate270
{
    [self rotate:270];
}

- (void)rotate315
{
    [self rotate:315];
}

- (void)rotate360
{
    [self rotate:360];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotateToAngle:(float)degrees
{
    self.transform = CGAffineTransformMakeRotation(Math_Radians(degrees));
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)rotate:(float)degrees
{
    float currentRotation = View_CurrentRadianRotation(self);
    float rotationRadianValue = Math_Radians(degrees);
    self.transform = CGAffineTransformMakeRotation(currentRotation+rotationRadianValue);
}

/*-----------------------------------------------------------------------------------------------------*/

- (UIImage *)rotateImage:(UIImage *)image
                 degrees:(int)degrees
{
    float scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        scale  = 2.0;
    }
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width*scale, image.size.height*scale)];
    CGAffineTransform t = CGAffineTransformMakeRotation(Math_Radians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, Math_Radians(degrees));
    
    CGContextScaleCTM(bitmap, scale, -scale);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
