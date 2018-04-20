//
//  Signup2ViewController.m
//  Yamo
//
//  Created by Jin on 7/10/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "Signup2ViewController.h"
#import "APIClient+Authentication.h"
#import "LoginViewController.h"
#import "Yamo-Swift.h"

@import UIAlertController_LOCExtensions;

#import <UIKit/UIKit.h>

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoSignin:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}

- (IBAction)done:(id)sender
{
    
    void (^beforeLoad)() = ^{

    };
    
    void (^afterLoad)() = ^{
        
    };
    
    void (^successBlock)(id element) = ^(id  _Nullable element) {
        [[Utility sharedObject] hideMBProgress];
        [UIAlertController showAlertInViewController:self
                                           withTitle:NSLocalizedString(@"Great", nil)
                                             message:NSLocalizedString(@"Register Success!", nil)
                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil
                                            tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull alertAction, NSInteger index) {
                                                [self  gotoHome];
                                            }];
        
    };
    
    void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
        ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
         [[Utility sharedObject] hideMBProgress];
          [Utility showToast:@"Network is not available" icon:ICON_FAIL toView:self.view afterDelay:2.0];
    };
    
    if(![Utility isValidEmail:emailTextField.text])
    {
        [Utility showToast:@"Invalid email address" icon:ICON_NONE toView:self.view afterDelay:2.0];
        [emailTextField becomeFirstResponder];
        return;
    }
    if(passwordTextField.text.length < 6)
    {
        [Utility showToast:@"Password length must be more then 6" icon:ICON_NONE toView:self.view afterDelay:2.0];
        [passwordTextField becomeFirstResponder];
        return;
    }

    [[Utility sharedObject] showMBProgress:self.view message:@""];
    [[APIClient sharedInstance] authenticationSignupWithFirstName:self.firstName
                                                         lastName:self.lastName
                                                         email:emailTextField.text
                                                         password:passwordTextField.text
                                                         imageContent:nil
                                                         beforeLoad:beforeLoad
                                                         afterLoad:afterLoad
                                                         successBlock:successBlock
                                                         failureBlock:failureBlock];
}

- (void) gotoHome
{
   
    RootViewController* r = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [r setExploreType:1];
    RootViewController* v = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [v setExploreType:2];
    SettingsViewController* s = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    NSArray *controllerArray = [NSArray arrayWithObjects:r, v, s, nil];
    NSArray * titleArray = TABBAR_TITLE_ARRAY;
    NSArray *imageArray= TABBAR_NORMAL_IMAGE_ARRAY;
    NSArray *selImageArray = TABBAR_SEL_IMAGE_ARRAY;
    CGFloat tabBarHeight = 49.0;
    
    XHTabBar* tabBar= [[XHTabBar alloc] initWithControllerArray:controllerArray titleArray:titleArray imageArray:imageArray selImageArray:selImageArray height:tabBarHeight];
    //self.window.rootViewController = tabBar;
    [self.navigationController pushViewController:tabBar animated:YES];
}

#pragma mark - Error Handler

- (void)handleNetworkError:(NSError *)error statusCode:(NSInteger)statusCode context:(NSString *)context {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:NSLocalizedString(@"Error", nil)
                                         message:[self errorMessageForLoginStatusCode:statusCode error:error]
                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull alertAction, NSInteger index) {
                                            
                                        }];
}


- (NSString *)errorMessageForLoginStatusCode:(NSInteger)statusCode error:(NSError *)error {
    
    switch (statusCode) {
        case 404: // User does not exist
        case 409: // Wrong password
            return NSLocalizedString(@"Wrong email or password", nil);
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (userInfo[NSLocalizedDescriptionKey]) {
        return userInfo[NSLocalizedDescriptionKey];
    }
    
    return NSLocalizedString(@"Failed to log in", nil);
}


@end
