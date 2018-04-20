//
//  SignUpViewController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 20/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <LOCGenericLogin/LOCAuthenticationViewController.h>
#import "SignUpController.h"
#import "Signup2ViewController.h"
#import "BaseViewController.h"

@interface SignUpViewController : BaseViewController
{
    IBOutlet UITextField* firstNameTextField;
    IBOutlet UITextField* lastNameTextField;
}

@property (nonatomic, weak) id<SignUpViewControllerDelegate> delegate;
@property BOOL isPayWallSubscription;
- (IBAction)gotoSignup2:(id)sender;
- (IBAction)gotoSignin:(id)sender;
@end
