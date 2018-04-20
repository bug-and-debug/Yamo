//
//  LOCFloatingPasswordTextField.m
//  LOCPasswordTextField
//
//  Created by Peter Su on 16/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFloatingPasswordTextField.h"

@interface LOCFloatingPasswordTextField ()

@property (nonatomic, strong) UIView *hiddenView;

@property (nonatomic, strong) UIView *revealView;

@property (nonatomic, strong) UITapGestureRecognizer *rightViewTapGestureRecognizer;

@property (nonatomic, strong) UITextField *pseudoTextField;

@end

@implementation LOCFloatingPasswordTextField

@synthesize revealState;

#pragma mark - LOCPasswordTextFieldProtocol

- (UIView *)hiddenEyeCon {
    
    return [LOCFloatingPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_hidden"] leftPadding:0 rightPadding:0];
}

- (UIView *)revealEyeCon {
    
    return [LOCFloatingPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_reveal"] leftPadding:0 rightPadding:0];
}

+ (UIView *)viewForImageIcon:(UIImage *)image leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding {
    
    UIImageView *revealIcon = [[UIImageView alloc] initWithImage:image];
    revealIcon.contentMode = UIViewContentModeScaleAspectFit;
    revealIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(revealIcon.bounds) + leftPadding + rightPadding, 44)];
    [rightView addSubview:revealIcon];
    
    [rightView addConstraint:[NSLayoutConstraint constraintWithItem:revealIcon attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:leftPadding]];
    [rightView addConstraint:[NSLayoutConstraint constraintWithItem:revealIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return rightView;
}

#pragma mark -

- (void)initialise {
    
    [super initialise];
    
    self.pseudoTextField = [UITextField new];
    self.pseudoTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.pseudoTextField.secureTextEntry = YES;
    [self addSubview:self.pseudoTextField];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.pseudoTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.pseudoTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
    
    self.hiddenView = [self hiddenEyeCon];
    self.revealView = [self revealEyeCon];
    
    self.rightViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapRevealIcon)];
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.borderStyle = UITextBorderStyleNone;
    self.secureTextEntry = YES;
    
    [self updateRightViewMode];
}

#pragma mark - Actions

- (void)handleDidTapRevealIcon {
    
    BOOL allowChange = YES;
    if ([self.delegate respondsToSelector:@selector(passwordTextField:shouldToggleSecureEntryMode:)]) {
        allowChange = [self.delegate passwordTextField:self shouldToggleSecureEntryMode:self.secureTextEntry];
    }
    
    if (allowChange) {
        
        BOOL isFirstResponder = self.isFirstResponder;
        
        if (isFirstResponder) {
            [self.pseudoTextField becomeFirstResponder];
        }
        
        self.secureTextEntry = !self.secureTextEntry;
        
        if (isFirstResponder) {
            [self becomeFirstResponder];
        }
        
        [self updateRightViewMode];
    }
}

- (void)updateRightViewMode {
    
    NSString *password = self.text;
    self.text = @"";
    self.text = password;
    
    self.rightView = self.secureTextEntry ? self.hiddenView : self.revealView;
    self.revealState = self.secureTextEntry ? LOCPasswordTextFieldRevealStateHidden : LOCPasswordTextFieldRevealStateRevealed;
    [self.rightView addGestureRecognizer:self.rightViewTapGestureRecognizer];
}

@end
