//
//  UIView+LOCFactory.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCFactory.h"
#import "UIView+LOCLayerEditing.h"

@implementation UIView (LOCFactory)

#pragma mark - factory
+ (UIView *)viewWithColor:(UIColor *)color frame:(CGRect)frame addToView:(UIView *)parentView
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    [parentView addSubview:view];
    return view;
}

+ (UIView *)viewWithColor:(UIColor *)color frame:(CGRect)frame edgeRadius:(CGFloat)radius addToView:(UIView *)parentView
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    [view addRoundEdgesWithRadius:radius];
    [parentView addSubview:view];
    return view;
}

+ (UIView *)blankViewWithFrame:(CGRect)frame addToView:(UIView *)parentView
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    [parentView addSubview:view];
    return view;
}

@end
