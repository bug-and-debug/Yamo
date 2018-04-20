//
//  LoginViewControllerDelegate.h
//  Yamo
//
//  Created by Vlad Buhaescu on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginDidFinish:(UIViewController *)viewController withUsername:(NSString *)username password:(NSString *)password;

@optional

- (void)loginForgottenPasswordButtonWasTapped:(LoginViewController *)viewController;

- (BOOL)loginShouldBeSkipped:(UIViewController *)viewController;

@end