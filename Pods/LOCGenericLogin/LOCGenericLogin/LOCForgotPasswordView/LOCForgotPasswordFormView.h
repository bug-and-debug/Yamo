//
//  LOCForgotPasswordFormView.h
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFormView.h"

@interface LOCForgotPasswordFormView : LOCFormView

@property (nonatomic, strong, readonly) UILabel *forgotPasswordLabel;
@property (nonatomic, strong, readonly) UITextField *emailLoginTextField;
@property (nonatomic, strong, readonly) UIButton *submitEmailButton;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

@end
