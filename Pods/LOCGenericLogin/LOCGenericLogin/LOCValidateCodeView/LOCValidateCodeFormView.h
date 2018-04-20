//
//  LOCValidateCodeFormView.h
//  GenericLogin
//
//  Created by Peter Su on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFormView.h"

@interface LOCValidateCodeFormView : LOCFormView

@property (nonatomic, strong, readonly) UILabel *forgotPasswordLabel;
@property (nonatomic, strong, readonly) UITextField *codeLoginTextField;
@property (nonatomic, strong, readonly) UITextField *passwordLoginTextField;
@property (nonatomic, strong, readonly) UITextField *confirmPasswordLoginTextField;
@property (nonatomic, strong, readonly) UIButton *submitButton;

@end
