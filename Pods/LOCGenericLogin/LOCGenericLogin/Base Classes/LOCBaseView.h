//
//  LOCBaseView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LOCGenericLogin.h"

@interface LOCBaseView : UIView

- (void)setup;

#pragma mark - Helpers

- (NSLayoutConstraint *)pinView:(UIView *)view forWidth:(CGFloat)width;

- (NSLayoutConstraint *)pinView:(UIView *)view forHeight:(CGFloat)height;

- (NSLayoutConstraint *)constraintForView:(UIView *)view
                                   toView:(UIView *)toView
                                attribute:(NSLayoutAttribute)attribute;
                                
- (NSLayoutConstraint *)constraintForView:(UIView *)view
                                   toView:(UIView *)toView
                                attribute:(NSLayoutAttribute)attribute
                                  padding:(CGFloat)padding;

- (void)updateFormForRetainedValues:(NSDictionary<NSString *, NSString *> *)dictionary;

@end
