//
//  LOCBaseView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCBaseView.h"

@implementation LOCBaseView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup {
    self.clipsToBounds = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Helper

- (NSLayoutConstraint *)pinView:(UIView *)view forWidth:(CGFloat)width {
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:width];
    [view addConstraint:widthConstraint];
    return widthConstraint;
}

- (NSLayoutConstraint *)pinView:(UIView *)view forHeight:(CGFloat)height {
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:height];
    [view addConstraint:heightConstraint];
    
    return heightConstraint;
}

- (NSLayoutConstraint *)constraintForView:(UIView *)view
                                   toView:(UIView *)toView
                                attribute:(NSLayoutAttribute)attribute {
    
    return [self constraintForView:view toView:toView attribute:attribute padding:0];
}

- (NSLayoutConstraint *)constraintForView:(UIView *)view
                                   toView:(UIView *)toView
                                attribute:(NSLayoutAttribute)attribute
                                  padding:(CGFloat)padding {
                                  
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:toView
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:padding];
}

- (void)updateFormForRetainedValues:(NSDictionary<NSString *, NSString *> *)dictionary {
    
}

@end
