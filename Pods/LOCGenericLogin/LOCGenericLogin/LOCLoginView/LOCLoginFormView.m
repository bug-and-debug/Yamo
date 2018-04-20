//
//  LOCLoginFormView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCLoginFormView.h"

static CGFloat kButtonVerticalMargin = 104;

@interface LOCLoginFormView ()

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;

@property (nonatomic, strong) UITextField *emailLoginTextField;
@property (nonatomic, strong) UITextField *passwordLoginTextField;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *goToForgotPasswordButton;
@property (nonatomic, strong) UIButton *signupButton;

@end

@implementation LOCLoginFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

- (void)setup {
    [super setup];
    
    [self setupTextFields];
    [self setupButtons];
}

- (void)setupTextFields {
    
    self.emailLoginTextField = [self textFieldWithPlaceholder:NSLocalizedString(@"Email", nil)
                                                          key:LOCFormViewEmailKey];
    self.emailLoginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailLoginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailLoginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:self.emailLoginTextField];
    
    [self addConstraint:[self constraintForView:self.emailLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeTop padding:0]];
    [self addConstraint:[self constraintForView:self.emailLoginTextField
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.emailLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self.emailLoginTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.emailLoginTextField 
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:kTextFieldHeight]];
    
    
    self.passwordLoginTextField = [self textFieldWithPlaceholder:NSLocalizedString(@"Password", nil)
                                                             key:LOCFormViewPasswordKey];
    self.passwordLoginTextField.secureTextEntry = YES;
    [self addSubview:self.passwordLoginTextField];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordLoginTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.emailLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:kTextFieldVerticalPadding]];
    
    [self addConstraint:[self constraintForView:self.passwordLoginTextField
                                         toView:self attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.passwordLoginTextField
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self.passwordLoginTextField addConstraint:[NSLayoutConstraint
                            constraintWithItem:self.passwordLoginTextField
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:kTextFieldHeight]];
    
    self.formTextFields = @[ self.emailLoginTextField,
                             self.passwordLoginTextField ];
    self.formTextFields.lastObject.returnKeyType = UIReturnKeyDone;
}

- (void)setupButtons {
    
    // Forgot password button
    self.goToForgotPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.goToForgotPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.goToForgotPasswordButton setTitle:NSLocalizedString(@"Forgotten Password?", nil)
                                   forState:UIControlStateNormal];
    self.goToForgotPasswordButton.tintColor = [UIColor lightGrayColor];
    [self addSubview:self.goToForgotPasswordButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.goToForgotPasswordButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.passwordLoginTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[self constraintForView:self.emailLoginTextField
                                         toView:self.goToForgotPasswordButton
                                      attribute:NSLayoutAttributeRight]];
    
    [self.goToForgotPasswordButton addConstraint:[NSLayoutConstraint constraintWithItem:self.goToForgotPasswordButton
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0
                                                                               constant:kTextFieldHeight]];
    
    // Login Button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginButton.backgroundColor = [UIColor blackColor];
    
    [self.loginButton setTitle:NSLocalizedString(@"Log in", nil)
                      forState:UIControlStateNormal];
    self.loginButton.tintColor = [UIColor whiteColor];
    
    [self addSubview:self.loginButton];
    
    self.formValidatedButtons = @[ self.loginButton ];
    
    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:self.loginButton
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.goToForgotPasswordButton
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:kButtonVerticalMargin];
    verticalConstraint.priority = UILayoutPriorityDefaultLow;
    [self addConstraint:verticalConstraint];
    
    [self addConstraint:[self constraintForView:self.loginButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.loginButton
                                      attribute:NSLayoutAttributeTrailing
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self.loginButton addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:kTextFieldHeight]];
    
    // Sign up button
    self.signupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.signupButton.tintColor = [UIColor blackColor];
    [self addSubview:self.signupButton];
    [self.signupButton setTitle:NSLocalizedString(@"Sign up", nil)
                       forState:UIControlStateNormal];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.loginButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:23]];
    
    [self addConstraint:[self constraintForView:self.signupButton
                                         toView:self
                                      attribute:NSLayoutAttributeCenterX]];
    
    [self.signupButton addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:kTextFieldHeight]];
    
    [self addConstraint:[self constraintForView:self
                                         toView:self.signupButton
                                      attribute:NSLayoutAttributeBottom
                                        padding:0]];
}

#pragma mark - Helpers

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                      key:(NSString *)key {
    UITextField *textField = [UITextField new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.returnKeyType = UIReturnKeyNext;
    textField.LOCLoginFormKey = key;
    textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textField.placeholder = placeholder;
    
    return textField;
}

@end
