//
//  UIView+LOCGenericLogin.m
//  LOCGenericLogin
//
//  Created by Peter Su on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCGenericLogin.h"

@implementation UIView (LOCGenericLogin)

+ (UIView *)emptyView {
    UIView *emptyView = [UIView new];
    emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [emptyView addConstraint:[NSLayoutConstraint constraintWithItem:emptyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
    
    return emptyView;
}

@end
