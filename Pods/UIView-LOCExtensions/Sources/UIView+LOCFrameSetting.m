//
//  UIView+FrameSetting.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCFrameSetting.h"
#import "UIView+LOCLayout.h"

@implementation UIView (LOCFrameSetting)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - frame setting
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveXAnimated:(float)xShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveX:xShift];
                     }];
}

- (void)moveYAnimated:(float)yShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveY:yShift];
                     }];
}

- (void)moveX:(float)xShift
 andYAnimated:(float)yShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveX:xShift
                                andY:yShift];
                     }];
}

- (void)setWidthAnimated:(float)width
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setWidth:width];
                     }];
}

- (void)setHeightAnimated:(float)width
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setHeight:width];
                     }];
}

- (void)setWidth:(float)width
andHeightAnimated:(float)height
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setWidth:width
                              andHeight:height];
                     }];
}

@end
