//
//  LOCSignupFormView.h
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFormView.h"

@interface LOCSignupFormView : LOCFormView

//@property (nonatomic, strong, readonly) UIView *textFieldsContainer;
@property (nonatomic, strong, readonly) UITextField *usernameTextField;
@property (nonatomic, strong, readonly) UITextField *firstNameTextField;
@property (nonatomic, strong, readonly) UITextField *lastNameTextField;
@property (nonatomic, strong, readonly) UITextField *emailAddressTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;
@property (nonatomic, strong, readonly) UITextField *confirmPasswordTextField;
@property (nonatomic, strong, readonly) UITextField *phoneNumberTextField;

@property (nonatomic, strong, readonly) UIButton *signupButton;
@property (nonatomic, strong, readonly) UIButton *goToLoginButton;

@end
