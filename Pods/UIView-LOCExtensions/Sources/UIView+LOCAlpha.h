//
//  UIView+LOCAlpha.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCAlpha)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alpha
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hide;
- (void)show;
- (void)hideAnimated;
- (void)showAnimated;
- (void)hideViews:(UIView *)view, ...;
- (void)showViews:(UIView *)view, ...;

@end
