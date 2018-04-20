//
//  LOCSignupFormView.m
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSignupFormView.h"

@interface LOCSignupFormView ()

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;

//@property (nonatomic, strong) UIView *textFieldsContainer;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;
@property (nonatomic, strong) UITextField *emailAddressTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UITextField *phoneNumberTextField;

@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UIButton *goToLoginButton;

@end

@implementation LOCSignupFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

- (void)setup {
    [super setup];
    
    [self setupForm];
    
}

- (void)setupForm {
    
    [self initialiseTextFields];
    
    self.formTextFields = @[ self.usernameTextField,
                             self.firstNameTextField,
                             self.lastNameTextField,
                             self.emailAddressTextField,
                             self.phoneNumberTextField,
                             self.passwordTextField,
                             self.confirmPasswordTextField ];
    self.passwordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.secureTextEntry = YES;
    [self.formTextFields lastObject].returnKeyType = UIReturnKeyDone;
    
    [self addTextFieldsToContainer];
    [self addFormButtons];
}

- (void)addTextFieldsToContainer {
  
//    Might need this if we can user to be able to add their own fields in
//    Clean textFieldsContainer
//    for (UIView *subview in self.textFieldsContainer.subviews) {
//        [subview removeFromSuperview];
//    }
    
    for (NSInteger textFieldIndex = 0; textFieldIndex < self.formTextFields.count; textFieldIndex++) {
        
        UITextField *textField = self.formTextFields[textFieldIndex];
        
        [self addSubview:textField];
        [self pinView:textField forHeight:kTextFieldHeight];
        [self addConstraint:[self constraintForView:textField toView:self
                                          attribute:NSLayoutAttributeLeading
                                            padding:kTextFieldLeadingTrailingMargin]];
        [self addConstraint:[self constraintForView:self toView:textField
                                          attribute:NSLayoutAttributeTrailing
                                            padding:kTextFieldLeadingTrailingMargin]];
        
        if (textFieldIndex == 0) {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
        } else {
            
            UITextField *previousTextField = self.formTextFields[textFieldIndex - 1];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previousTextField
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:10]];
        }
    }
}

- (void)addFormButtons {
    
    // Login Button
    self.signupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.signupButton.backgroundColor = [UIColor blackColor];
    
    [self.signupButton setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
    self.signupButton.tintColor = [UIColor whiteColor];
    
    [self addSubview:self.signupButton];
    self.formValidatedButtons = @[ self.signupButton ];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:[self.formTextFields lastObject]
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:22]];
    
    [self addConstraint:[self constraintForView:self.signupButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeading
                                        padding:kTextFieldLeadingTrailingMargin]];
    [self addConstraint:[self constraintForView:self
                                         toView:self.signupButton
                                      attribute:NSLayoutAttributeTrailing 
                                        padding:kTextFieldLeadingTrailingMargin]];
    
    [self.signupButton addConstraint:[NSLayoutConstraint constraintWithItem:self.signupButton
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:kTextFieldHeight]];
    
    
    // Sign up button

    self.goToLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.goToLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.goToLoginButton setTitle:NSLocalizedString(@"Back to Login", nil) forState:UIControlStateNormal];
    [self addSubview:self.goToLoginButton];
    self.goToLoginButton.tintColor = [UIColor lightGrayColor];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.goToLoginButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.signupButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:22]];
    
    [self addConstraint:[self constraintForView:self.goToLoginButton
                                         toView:self
                                      attribute:NSLayoutAttributeCenterX]];
    
    [self.goToLoginButton addConstraint:[NSLayoutConstraint constraintWithItem:self.goToLoginButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:kTextFieldHeight]];
    
    [self addConstraint:[self constraintForView:self
                                         toView:self.goToLoginButton
                                      attribute:NSLayoutAttributeBottom
                                        padding:0]];
}

#pragma mark - Helpers

- (void)initialiseTextFields {
    
    self.usernameTextField = [self initialiseTextFieldWithKey:LOCFormViewUsernameKey];
    self.usernameTextField.placeholder = NSLocalizedString(@"Username", nil);
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.firstNameTextField = [self initialiseTextFieldWithKey:LOCFormViewFirstNameKey];
    self.firstNameTextField.placeholder = NSLocalizedString(@"First Name", nil);
    
    self.lastNameTextField = [self initialiseTextFieldWithKey:LOCFormViewLastNameKey];
    self.lastNameTextField.placeholder = NSLocalizedString(@"Last Name", nil);
    
    self.emailAddressTextField = [self initialiseTextFieldWithKey:LOCFormViewEmailKey];
    self.emailAddressTextField.placeholder = NSLocalizedString(@"Email", nil);
    self.emailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailAddressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.phoneNumberTextField = [self initialiseTextFieldWithKey:LOCFormViewPhoneNumberKey];
    self.phoneNumberTextField.placeholder = NSLocalizedString(@"Phone Number", nil);
    self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    
    self.passwordTextField = [self initialiseTextFieldWithKey:LOCFormViewPasswordKey];
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.passwordTextField.secureTextEntry = YES;
    
    self.confirmPasswordTextField = [self initialiseTextFieldWithKey:LOCFormViewConfirmPasswordKey];
    self.confirmPasswordTextField.placeholder = NSLocalizedString(@"Confirm Password", nil);
    self.confirmPasswordTextField.secureTextEntry = YES;
}

- (UITextField *)initialiseTextFieldWithKey:(NSString *)key {
    
    UITextField *formTextField = [UITextField new];
    formTextField.translatesAutoresizingMaskIntoConstraints = NO;
    formTextField.LOCLoginFormKey = key;
    formTextField.returnKeyType = UIReturnKeyNext;
    
    return formTextField;
}

@end
