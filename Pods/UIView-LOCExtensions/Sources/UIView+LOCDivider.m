//
//  UIView+Divider.m
//  ZiferblatAdmin
//
//  Created by Simon Lee on 10/05/2015.
//  Copyright (c) 2015 Locassa. All rights reserved.
//

#import "UIView+LOCDivider.h"

@implementation UIView (LOCDivider)

+ (id)dividerWithWidth:(CGFloat)aWidth colour:(UIColor *)aColour {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aWidth, 1)];
    [divider setBackgroundColor:aColour];
    return divider;
}

+ (id)dividerWithHeight:(CGFloat)aHeight colour:(UIColor *)aColour {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, aHeight)];
    [divider setBackgroundColor:aColour];
    return divider;
}

@end
