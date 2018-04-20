//
//  LOCForgotPasswordFormView.m
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCForgotPasswordFormView.h"

@interface LOCForgotPasswordFormView ()

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;

@property (nonatomic, strong) UILabel *forgotPasswordLabel;
@property (nonatomic, strong) UITextField *emailLoginTextField;
@property (nonatomic, strong) UIButton *submitEmailButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation LOCForgotPasswordFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

- (void)setup {
    [super setup];
    
    self.forgotPasswordLabel = [UILabel new];
    self.forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.forgotPasswordLabel.numberOfLines = 0;
    self.forgotPasswordLabel.text = NSLocalizedString(@"Reset your password by submitting your email", nil);
    [self addSubview:self.forgotPasswordLabel];
    
    self.emailLoginTextField = [UITextField new];
    self.emailLoginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailLoginTextField.returnKeyType = UIReturnKeyNext;
    self.emailLoginTextField.LOCLoginFormKey = LOCFormViewEmailKey;
    self.emailLoginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailLoginTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.emailLoginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailLoginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailLoginTextField.placeholder = NSLocalizedString(@"Enter your email", @"Reset password");
    [self addSubview:self.emailLoginTextField];
    
    self.formTextFields = @[ self.emailLoginTextField ];
    self.formTextFields.lastObject.returnKeyType = UIReturnKeyDone;
    
    self.submitEmailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitEmailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitEmailButton setTitle:NSLocalizedString(@"Submit Email", nil) forState:UIControlStateNormal];
    self.submitEmailButton.backgroundColor = [UIColor blackColor];
    self.submitEmailButton.tintColor = [UIColor whiteColor];
    [self addSubview:self.submitEmailButton];
    
    self.formValidatedButtons = @[ self.submitEmailButton ];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setTitle:NSLocalizedString(@"I remembered", @"Forgot password")
                       forState:UIControlStateNormal];
    self.cancelButton.tintColor = [UIColor lightGrayColor];
    [self addSubview:self.cancelButton];
    
    [self addConstraint:[self constraintForView:self.forgotPasswordLabel
                                         toView:self attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self constraintForView:self.forgotPasswordLabel
                                         toView:self attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self toView:self.forgotPasswordLabel
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.emailLoginTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.forgotPasswordLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:35]];
    [self addConstraint:[self constraintForView:self.emailLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.emailLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.emailLoginTextField forHeight:kTextFieldHeight];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.submitEmailButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.emailLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:15]];
    [self addConstraint:[self constraintForView:self.submitEmailButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.submitEmailButton
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self pinView:self.submitEmailButton forHeight:kTextFieldHeight];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.submitEmailButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[self constraintForView:self.cancelButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.cancelButton
        forHeight:kTextFieldHeight];
    [self addConstraint:[self constraintForView:self.cancelButton
                                         toView:self
                                      attribute:NSLayoutAttributeBottom]];

}

@end
