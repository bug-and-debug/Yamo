//
//  LoginFormView.h
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <LOCGenericLogin/LOCFormView.h>
#import "TextField.h"
#import "PasswordTextField.h"

@interface LoginFormView : LOCFormView

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet TextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet PasswordTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

+ (LoginFormView *)loadFromNib;

@end
