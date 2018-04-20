//
//  LOCPasswordAcccessoryTextField.m
//  LOCPasswordTextField
//
//  Created by Peter Su on 13/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCPasswordAcccessoryTextField.h"

@interface LOCPasswordAcccessoryTextField ()

@property (nonatomic, strong) UIView *rightButtonContainerView;

@property (nonatomic, strong) UIImageView *rightButtonView;

@property (nonatomic, strong) UITapGestureRecognizer *rightViewTapGestureRecognizer;

@property (nonatomic, strong) UITextField *pseudoTextField;

@end

@implementation LOCPasswordAcccessoryTextField

@synthesize revealState;

- (void)initialise {
    [super initialise];
    
    self.secureTextEntry = YES;
    
    self.pseudoTextField = [UITextField new];
    self.pseudoTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.pseudoTextField.secureTextEntry = YES;
    [self addSubview:self.pseudoTextField];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.pseudoTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.pseudoTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
    
    self.rightViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapRevealIcon)];
}


- (void)setRevealImage:(UIImage *)revealImage {
    _revealImage = revealImage;
    
    [self updateRightView];
}

- (void)setHiddenImage:(UIImage *)hiddenImage {
    _hiddenImage = hiddenImage;
    
    [self updateRightView];
}

- (void)animateViewsForTextEntry {
    
    [super animateViewsForTextEntry];
    [self updateRightView];
}

- (void)animateViewsForTextDisplay {
    
    [super animateViewsForTextDisplay];
    [self updateRightView];
}

- (void)updateRightView {
    
    if (self.revealImage && self.hiddenImage) {
        
        if (!self.rightButtonContainerView) {
            
            self.rightButtonContainerView = [UIView new];
            self.rightButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
            
            self.rightButtonView = [[UIImageView alloc] initWithImage:self.hiddenImage highlightedImage:self.revealImage];
            self.rightButtonView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightButtonView.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat defaultPadding = 0.0f;
            
            [self.rightButtonContainerView addSubview:self.rightButtonView];
            
            [self.rightButtonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rightButtonContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
            [self.rightButtonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.rightButtonContainerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:defaultPadding]];
            
            [self.rightButtonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.rightButtonView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
            
            self.rightView = self.rightButtonContainerView;
            self.rightViewMode = UITextFieldViewModeAlways;
            
            [self.rightView addGestureRecognizer:self.rightViewTapGestureRecognizer];
        }
        
        
        if ((self.text && self.text.length > 0) || self.isFirstResponder) {
            
            self.rightButtonContainerView.hidden = NO;
        } else {
            
            self.rightButtonContainerView.hidden = YES;
        }
        
        self.rightButtonView.highlighted = !self.secureTextEntry;
        
    }
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
    
    self.rightButtonView.highlighted = !self.secureTextEntry;
    self.revealState = self.secureTextEntry ? LOCPasswordTextFieldRevealStateHidden : LOCPasswordTextFieldRevealStateRevealed;
}

@end
