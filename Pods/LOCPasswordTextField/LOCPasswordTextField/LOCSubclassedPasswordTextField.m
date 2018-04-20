//
//  LOCSubclassedPasswordTextField.m
//  LOCPasswordTextField
//
//  Created by Peter Su on 01/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSubclassedPasswordTextField.h"

@interface LOCSubclassedPasswordTextField ()

@property (nonatomic, strong) UIView *hiddenView;

@property (nonatomic, strong) UIView *revealView;

@property (nonatomic, strong) UITapGestureRecognizer *rightViewTapGestureRecognizer;

@property (nonatomic, strong) UITextField *pseudoTextField;

@end

@implementation LOCSubclassedPasswordTextField

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
    
    return [LOCSubclassedPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_hidden"] leftPadding:self.revealLeftPadding rightPadding:self.revealRightPadding];
}

- (UIView *)revealEyeCon {
    
    return [LOCSubclassedPasswordTextField viewForImageIcon:[UIImage imageNamed:@"eye_reveal"] leftPadding:self.revealLeftPadding rightPadding:self.revealRightPadding];
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
    
    self.pseudoTextField = [UITextField new];
    self.pseudoTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.pseudoTextField.secureTextEntry = YES;
    [self addSubview:self.pseudoTextField];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pseudoTextField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.pseudoTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.pseudoTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0]];
    
    self.editingTextLeftRightPadding = 0.0f;
    
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
