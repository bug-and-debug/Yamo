//
//  LOCStateView.m
//  GenericLogin
//
//  Created by Peter Su on 25/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCStateView.h"

@interface LOCStateView ()

@end

@implementation LOCStateView

- (void)setup {
    
    [super setup];
    
    UIView *topView = [self topView];
    UIView *middleView = [self middleView];
    UIView *bottomView = [self bottomView];
    
    [self addSubview:topView];
    [self addSubview:middleView];
    [self addSubview:bottomView];
    
    [self addConstraint:[self constraintForView:topView
                                         toView:self
                                      attribute:NSLayoutAttributeTop]];
    
    [self addConstraint:[self constraintForView:topView
                                         toView:self
                                      attribute:NSLayoutAttributeLeading]];
    
    [self addConstraint:[self constraintForView:topView
                                         toView:self
                                      attribute:NSLayoutAttributeTrailing]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:middleView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[self constraintForView:middleView
                                         toView:self
                                      attribute:NSLayoutAttributeLeading]];
    
    [self addConstraint:[self constraintForView:middleView
                                         toView:self
                                      attribute:NSLayoutAttributeTrailing]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:middleView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:bottomView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[self constraintForView:bottomView
                                         toView:self
                                      attribute:NSLayoutAttributeLeading]];
    
    [self addConstraint:[self constraintForView:bottomView
                                         toView:self
                                      attribute:NSLayoutAttributeTrailing]];
    
    [self addConstraint:[self constraintForView:bottomView
                                         toView:self
                                      attribute:NSLayoutAttributeBottom]];
}

#pragma mark - LOCStateViewDelegate

- (UIView *)topView {
    
    return [UIView emptyView];
}

- (UIView *)middleView {
    
    return [UIView emptyView];
}

- (UIView *)bottomView {
    
    return [UIView emptyView];
}

- (NSArray<UITextField *> *)formTextFields {
    return @[];
}

- (NSArray<UIButton *> *)formValidatedButtons {
    return @[];
}

- (NSDictionary *)formValuesWithKeys {
    return @{};
}

@end
