//
//  UIImage+Draw.m
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIImage+LOCDraw.h"

@implementation UIImage (LOCDraw)

#pragma mark - draw

- (void)drawInRectWithAspectFill:(CGRect)rect {
    CGSize targetSize = CGSizeMake(rect.size.width * [[UIScreen mainScreen] scale], rect.size.height * [[UIScreen mainScreen] scale]);
    UIImage *scaledImage;
    
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
        scaledImage = self;
    } else {
        CGFloat scalingFactor = targetSize.width / self.size.width > targetSize.height / self.size.height ?
        targetSize.width / self.size.width :
        targetSize.height / self.size.height;
        CGSize newSize = CGSizeMake(self.size.width * scalingFactor, self.size.height * scalingFactor);
        
        UIGraphicsBeginImageContext(targetSize);
        CGRect newRect = CGRectMake((targetSize.width - newSize.width) / 2, (targetSize.height - newSize.height) / 2, newSize.width, newSize.height);
        [self drawInRect:newRect];
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [scaledImage drawInRect:rect];
}

@end
