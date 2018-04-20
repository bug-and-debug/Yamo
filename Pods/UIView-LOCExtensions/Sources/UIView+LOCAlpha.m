//
//  UIView+LOCAlpha.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCAlpha.h"

@implementation UIView (LOCAlpha)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alpha
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hide
{
    self.alpha = 0;
}

- (void)show
{
    self.alpha = 1;
}

- (void)hideAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self hide];
                     }];
}

- (void)showAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self show];
                     }];
}

- (void)hideViews:(UIView *)view, ... {
    va_list args;
    va_start(args, view);
    
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        arg.alpha = 0.0;
    }
    va_end(args);
}

- (void)showViews:(UIView *)view, ... {
    va_list args;
    va_start(args, view);
    
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        arg.alpha = 1.0;
    }
    va_end(args);
}

@end
