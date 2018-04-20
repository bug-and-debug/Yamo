//
//  LOCValidateCodeFormView.m
//  GenericLogin
//
//  Created by Peter Su on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCValidateCodeFormView.h"

@interface LOCValidateCodeFormView ()

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;

@property (nonatomic, strong) UILabel *forgotPasswordLabel;
@property (nonatomic, strong) UITextField *codeLoginTextField;
@property (nonatomic, strong) UITextField *passwordLoginTextField;
@property (nonatomic, strong) UITextField *confirmPasswordLoginTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation LOCValidateCodeFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

- (void)setup {
    [super setup];
    
    self.forgotPasswordLabel = [UILabel new];
    self.forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.forgotPasswordLabel.numberOfLines = 0;
    self.forgotPasswordLabel.text = NSLocalizedString(@"Reset your password by submitting your email", nil);
    [self addSubview:self.forgotPasswordLabel];
    
    self.codeLoginTextField = [UITextField new];
    self.codeLoginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeLoginTextField.returnKeyType = UIReturnKeyNext;
    self.codeLoginTextField.LOCLoginFormKey = LOCFormViewEmailKey;
    self.codeLoginTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.codeLoginTextField.placeholder = NSLocalizedString(@"Enter code", nil);
    [self addSubview:self.codeLoginTextField];
    
    self.passwordLoginTextField = [UITextField new];
    self.passwordLoginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordLoginTextField.returnKeyType = UIReturnKeyNext;
    self.passwordLoginTextField.LOCLoginFormKey = LOCFormViewPasswordKey;
    self.passwordLoginTextField.secureTextEntry = YES;
    self.passwordLoginTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.passwordLoginTextField.placeholder = NSLocalizedString(@"Password", nil);
    [self addSubview:self.passwordLoginTextField];
    
    self.confirmPasswordLoginTextField = [UITextField new];
    self.confirmPasswordLoginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.confirmPasswordLoginTextField.returnKeyType = UIReturnKeyNext;
    self.confirmPasswordLoginTextField.LOCLoginFormKey = LOCFormViewConfirmPasswordKey;
    self.confirmPasswordLoginTextField.secureTextEntry = YES;
    self.confirmPasswordLoginTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.confirmPasswordLoginTextField.placeholder = NSLocalizedString(@"Confirm password", nil);
    [self addSubview:self.confirmPasswordLoginTextField];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitButton setTitle:NSLocalizedString(@"Reset password", nil) forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor blackColor];
    [self addSubview:self.submitButton];
    
    self.formValidatedButtons = @[ self.submitButton ];
    
    [self addConstraint:[self constraintForView:self.forgotPasswordLabel
                                         toView:self
                                      attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self constraintForView:self.forgotPasswordLabel
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.forgotPasswordLabel
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.codeLoginTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.forgotPasswordLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:35]];
    
    [self addConstraint:[self constraintForView:self.codeLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self addConstraint:[self constraintForView:self
                                         toView:self.codeLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.codeLoginTextField
        forHeight:kTextFieldHeight];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordLoginTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.codeLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:15]];
    [self addConstraint:[self constraintForView:self.passwordLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.passwordLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.passwordLoginTextField
        forHeight:kTextFieldHeight];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.confirmPasswordLoginTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.passwordLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:15]];
    [self addConstraint:[self constraintForView:self.confirmPasswordLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.confirmPasswordLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.confirmPasswordLoginTextField
        forHeight:kTextFieldHeight];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.submitButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.confirmPasswordLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:15]];
    [self addConstraint:[self constraintForView:self.submitButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.submitButton
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self pinView:self.submitButton
        forHeight:kTextFieldHeight];
    [self addConstraint:[self constraintForView:self.submitButton
                                         toView:self
                                      attribute:NSLayoutAttributeBottom]];
    
    self.formTextFields = @[ self.codeLoginTextField,
                             self.passwordLoginTextField,
                             self.confirmPasswordLoginTextField];
    self.formTextFields.lastObject.returnKeyType = UIReturnKeyDone;
    
}

@end
