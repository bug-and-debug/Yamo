//
//  LoginViewController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LOCGenericLogin/LOCAuthenticationViewController.h>
#import "LoginController.h"
#import "SignUpViewController.h"
#import "BaseViewController.h"
@class RootViewController;

@interface LoginViewController : BaseViewController
{
    IBOutlet UITextField* tf_email;
    IBOutlet UITextField* tf_password;
}
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property BOOL isPayWallSubscription;
- (IBAction)gotoSignup:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)fblogin:(id)sender;
- (IBAction)btnForgotten:(id)sender;

@end
