//
//  LOCPasswordTextField.m
//  LOCPasswordTextField
//
//  Created by Peter Su on 16/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCPasswordTextField.h"

@interface LOCPasswordTextField ()

@property (nonatomic, strong) UIView *hiddenView;

@property (nonatomic, strong) UIView *revealView;

@property (nonatomic, strong) UITapGestureRecognizer *rightViewTapGestureRecognizer;

@end

@implementation LOCPasswordTextField

@synthesize revealState;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialise];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initialise];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self initialise];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialise];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self editingRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGFloat rightViewWidth = CGRectGetWidth(self.rightView.bounds);
    return CGRectMake(self.editingTextLeftRightPadding, 0, bounds.size.width - rightViewWidth - (self.editingTextLeftRightPadding * 2), bounds.size.height);
}

#pragma mark - Public

- (void)setEditingTextLeftRightPadding:(CGFloat)editingTextLeftRightPadding {
    _editingTextLeftRightPadding = editingTextLeftRightPadding;
}

- (void)setRevealRightPadding:(CGFloat)revealRightPadding {
    _revealRightPadding = revealRightPadding;
    
    self.hiddenView = [self hiddenEyeCon];
    self.revealView = [self revealEyeCon];
    [self updateRightViewMode];
}

- (void)setRevealLeftPadding:(CGFloat)revealLeftPadding {
    _revealLeftPadding = revealLeftPadding;
    
    self.hiddenView = [self hiddenEyeCon];
    self.revealView = [self revealEyeCon];
    [self updateRightViewMode];
}

#pragma mark - LOCPasswordTextFieldProtocol

- (UIView *)hiddenEyeCon {
    
    return [LOCPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_hidden"] leftPadding:self.revealLeftPadding rightPadding:self.revealRightPadding];
}

- (UIView *)revealEyeCon {
    
    return [LOCPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_reveal"] leftPadding:self.revealLeftPadding rightPadding:self.revealRightPadding];
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
    
    self.editingTextLeftRightPadding = 0.0f;
    
    self.hiddenView = [self hiddenEyeCon];
    self.revealView = [self revealEyeCon];
    
    self.rightViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapRevealIcon)];
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.borderStyle = UITextBorderStyleNone;
    
    [self updateRightViewMode];
}

#pragma mark - Actions

- (void)handleDidTapRevealIcon {
    
    BOOL allowChange = YES;
    if ([self.delegate respondsToSelector:@selector(passwordTextField:shouldToggleSecureEntryMode:)]) {
        allowChange = [self.delegate passwordTextField:self shouldToggleSecureEntryMode:self.secureTextEntry];
    }
    
    /*
     *  Need to resign responder and become first responder between changing secureTextEntry mode
     *  as it will causes issues with the font. However this causes another issue with the keyboard.
     *  Use LOCSubclassedPasswordTextField for now.
     */
    if (allowChange) {
        BOOL isFirstResponder = self.isFirstResponder;
        
        if (isFirstResponder) {
            [self resignFirstResponder];
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
