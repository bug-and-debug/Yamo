//
//  LoginView.h
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <LOCGenericLogin/LOCLoginView.h>
#import "LoginFormView.h"

@interface LoginView : LOCLoginView

@property (nonatomic, strong) LoginFormView *loginFormView;
@property (nonatomic, strong)  UIButton *loginButton;
@property (nonatomic, strong)  UIButton *fbButton;

@end
