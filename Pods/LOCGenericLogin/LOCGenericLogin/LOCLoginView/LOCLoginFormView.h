//
//  LOCLoginFormView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFormView.h"

@interface LOCLoginFormView : LOCFormView

@property (nonatomic, strong, readonly) UITextField *emailLoginTextField;
@property (nonatomic, strong, readonly) UITextField *passwordLoginTextField;

@property (nonatomic, strong, readonly) UIButton *goToForgotPasswordButton;
@property (nonatomic, strong, readonly) UIButton *loginButton;
@property (nonatomic, strong, readonly) UIButton *signupButton;

@end
