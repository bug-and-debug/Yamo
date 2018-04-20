//
//  UIView+LOCFactory.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCFactory)

#pragma mark - factory
+ (UIView *)viewWithColor:(UIColor *)color frame:(CGRect)frame addToView:(UIView *)parentView;
+ (UIView *)viewWithColor:(UIColor *)color frame:(CGRect)frame edgeRadius:(CGFloat)radius addToView:(UIView *)parentView;
+ (UIView *)blankViewWithFrame:(CGRect)frame addToView:(UIView *)parentView;

@end
