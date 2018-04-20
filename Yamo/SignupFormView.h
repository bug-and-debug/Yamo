//
//  SignupFormView.h
//  RoundsOnMe
//
//  Created by Peter Su on 29/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <LOCGenericLogin/LOCFormView.h>
#import "TextField.h"
#import "PasswordTextField.h"

@interface SignupFormView : LOCFormView

@property (weak, nonatomic) IBOutlet TextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet TextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet TextField *emailTextField;
@property (weak, nonatomic) IBOutlet PasswordTextField *passwordTextField;

+ (SignupFormView *)loadFromNib;

@end
