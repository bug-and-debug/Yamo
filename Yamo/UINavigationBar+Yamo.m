//
//  UINavigationBar+Yamo.m
//  Yamo
//
//  Created by Hungju Lu on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UINavigationBar+Yamo.h"
#import "UIFont+Yamo.h"
@import UIImage_LOCExtensions;

@implementation UINavigationBar (Yamo)

- (void)setNavigationBarStyleTranslucent {
    [self setNavigationBarYamoStyle];
    self.translucent = YES;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
               forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarStyleOpaque {
    return [self setNavigationBarYamoStyle];
}

- (void)setNavigationBarShadowWithColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 1);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}

- (void)removeNavigationBarShadow {
    for (UIView *view in self.subviews) {
        if (CGRectGetHeight(view.frame)) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Private methods

- (void)setNavigationBarYamoStyle {
    self.barStyle = UIBarStyleDefault;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
               forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [self shadowImage];
    self.translucent = NO;
    self.tintColor = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                           NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0]}];
}

- (UIImage *)shadowImage {
    UIImage *shadowImage = [UIImage imageNamed:@"whiteshadow button 1 1 1 1 1"];
    CGFloat imageHeight = shadowImage.size.height * [UIScreen mainScreen].scale;
    CGFloat heightToCrop = 64.0 * [UIScreen mainScreen].scale;
    UIImage *croppedShadowImage = [shadowImage croppedImage:CGRectMake(10.0, heightToCrop, 1.0, imageHeight - heightToCrop)];
    croppedShadowImage = [croppedShadowImage resizedImage:CGSizeMake(1.0, croppedShadowImage.size.height / [UIScreen mainScreen].scale)];
    return croppedShadowImage;
}

@end
