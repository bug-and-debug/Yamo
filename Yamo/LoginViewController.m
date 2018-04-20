//
//  LoginViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "MapViewController.h"
#import "AuthenticationViewController.h"
#import "APIClient+Authentication.h"
#import "LOCFloatingPasswordTextField.h"
#import "LoginView.h"
#import "User.h"
#import "UserService.h"
#import "LOCMacros.h"
#import "Yamo-Swift.h"
#import "PasswordValidator.h"
#import "UIViewController+Network.h"
#import "LOCAppDefinitions.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ForgottenViewController.h"
@import UIAlertController_LOCExtensions;

@interface LoginViewController ()

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *switchButton;

@end

@implementation LoginViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 380, 50)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Sign In";
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(goRegister)];
    navItem.rightBarButtonItem = rightButton;
    
    navbar.items = @[ navItem];
    [self.view addSubview:navbar];
    
    [self bigScreen];
}

- (void) goRegister{
    
}

- (LOCForgotPasswordView *)alternativeViewForForgotPasswordState {
    
    LOCForgotPasswordView *new = [[LOCForgotPasswordView alloc] init];
    [new.formView.cancelButton addTarget:self action:@selector(bringToFrontMyViews) forControlEvents:UIControlEventTouchUpInside];
    return new;
}

- (void)bringToFrontMyViews {
   
    [self.loginView.loginButton bringToFront];
    [self.loginView.fbButton bringToFront];
}

- (void)bigScreen {
    self.scrollView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.loginView.loginButton bringToFront];
    [self.loginView.fbButton bringToFront];
    
}


#pragma mark - UI

- (LOCLoginView *)alternativeViewForLoginState {
    
    self.loginView = [LoginView new];
    for (UITextField *textField in self.loginView.formTextFields) {
        textField.delegate= self;
    }
    
    self.loginView.clipsToBounds = NO;
    
    [self.loginView.loginFormView.forgotPasswordButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.loginView.loginFormView.forgotPasswordButton addTarget:self action:@selector(handleForgottenPasswordButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return self.loginView;
    
}

- (void)handleForgottenPasswordButtonTap:(id)sender {

    if ([self.delegate respondsToSelector:@selector(loginForgottenPasswordButtonWasTapped:)]) {
     
        [self.delegate loginForgottenPasswordButtonWasTapped:self];
    }
}

- (LOCFormValidationState)validateRuleForValidateForm:(LOCStateView *)view withInput:(NSString *)input entryKey:(NSString *)key {
    if ([key isEqualToString:LOCFormViewPasswordKey]) {
        return [PasswordValidator validatePassword:input];
    }
    else {
        return [super validateRuleForValidateForm:view withInput:input entryKey:key];
    }
}

#pragma mark - API

- (void)authenticationViewLoginWithEmail:(NSString *)email
                                password:(NSString *)password {
    
    [self showIndicator:YES];
    [self enableUIUserInteractionState:NO];
    
    __weak typeof(self) weakSelf = self;
    [[APIClient sharedInstance] loginWithEmail:email
                                      password:password
                                  successBlock:^(id  _Nullable element) {
                                      
                                      [self showIndicator:NO];
                                      [self enableUIUserInteractionState:YES];
                                      
                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                      NSError *parseError = nil;
                                      User *loggedInUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:element error:&parseError];
                                      
                                      [[UserService sharedInstance] didLoginWithUser:loggedInUser];
                                      
                                      if ([strongSelf.delegate respondsToSelector:@selector(loginDidFinish:withUsername:password:)]) {
                                          [strongSelf.delegate loginDidFinish:strongSelf withUsername:email password:password];
                                      }
                                  } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                      
                                      [self showIndicator:NO];
                                      [self enableUIUserInteractionState:YES];
                                      NSLog(@"login error : %@ ( %@ )", error.localizedDescription,error);
                                      [self handleNetworkError:error statusCode:statusCode context:context];
                                      
                                  }];
}

- (void)connectWithFacebookWithFacebookToken:(NSString *)fbToken facebookId:(NSString *)facebookId emailAddress:(NSString *)emailAddress {
    
    void (^afterLoad)() = ^{
        [self showIndicator:NO];
        [self enableUIUserInteractionState:YES];
    };
    
    void (^successBlock)(id element) = ^(id  _Nullable element) {
        
        NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];
        
        if ([self.delegate respondsToSelector:@selector(loginDidFinish:withUsername:password:)]) {
            [self.delegate loginDidFinish:self withUsername:emailAddress password:tempPassword];
        }
    };
    
    void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
    ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        NSDictionary *errorDictionary = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] ? error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] : @{};
        
        NSLog(@"Error dictionary: %@", errorDictionary);
        [self handleNetworkError:error statusCode:statusCode context:context];
    };
    
    if (self.isPayWallSubscription) {
        [[APIClient sharedInstance] userConnectWithFacebookWithFacebookToken:fbToken
                                                                  facebookId:facebookId
                                                                       email:emailAddress
                                                                  beforeLoad:nil
                                                                   afterLoad:afterLoad
                                                                successBlock:successBlock
                                                                failureBlock:failureBlock];
    } else {
        [[APIClient sharedInstance] authenticationConnectWithFacebookWithFacebookToken:fbToken
                                                                            facebookId:facebookId
                                                                                 email:emailAddress
                                                                            beforeLoad:nil
                                                                             afterLoad:afterLoad
                                                                          successBlock:successBlock
                                                                          failureBlock:failureBlock];
    }
}

- (void)loginViewSignupButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
    AuthenticationViewController *parent = (AuthenticationViewController*)self.parentViewController;
    [parent switchToLoginSignup];
}

- (void)loginViewDidPressConnectWithSocialMediaType:(AllowedSocialMediaType)socialMediaType{
    
    if (socialMediaType == AllowedSocialMediaTypeFacebook) {
        
        [self showIndicator:YES];
        [self enableUIUserInteractionState:NO];
        
        self.facebookButton.userInteractionEnabled = NO;
        void (^loginBlock)() = ^{
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"email"}];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                if(!error) {
                    NSString *fbUserId = [[FBSDKAccessToken currentAccessToken] userID];
                    NSString *fbToken =  [[FBSDKAccessToken currentAccessToken] tokenString];
                    NSString *fbEmail =  result[@"email"];
                    
                    [self connectWithFacebookWithFacebookToken:fbToken facebookId:fbUserId emailAddress:fbEmail];
                }
                else {
                    NSLog(@"Connect with Facebook error is %@",error.description );
                }
                [self showIndicator:NO];
                [self enableUIUserInteractionState:YES];
            }];
        };
        
        if (![[FBSDKAccessToken currentAccessToken] tokenString]) {
            
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                
                if ([result.grantedPermissions containsObject:@"email"]) {
                    loginBlock();
                } else {
                    
                    [self showIndicator:NO];
                    [self enableUIUserInteractionState:YES];
                }
            }];
        } else {
            loginBlock();
        }
    }
}


 */

- (void) viewDid;
{
    [super viewDidLoad];
    NSLog(@" ----  login view did load ----");
}

- (void) viewWillAppear:(BOOL)animated
{
    tf_email.text = @"";
    tf_password.text = @"";
    
    [tf_email becomeFirstResponder];
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

- (IBAction)gotoSignup:(id)sender
{
    
    SignUpViewController* s = [[SignUpViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:s animated:YES];
    
}

- (IBAction)login:(id)sender
{
    if(![Utility isValidEmail:tf_email.text])
    {
        [Utility showToast:@"Invalid email address" icon:ICON_NONE toView:self.view afterDelay:2.0];
        tf_email.text = @"";
        [tf_email becomeFirstResponder];
        return;
    }
    if(tf_password.text.length < 1)
    {
        [Utility showToast:@"Please enter password" icon:ICON_NONE toView:self.view afterDelay:2.0];
        [tf_password becomeFirstResponder];
        return;
    }
    [self authenticationViewLoginWithEmail:tf_email.text password:tf_password.text];
    
}


- (IBAction)fblogin:(id)sender
{

    self.facebookButton.userInteractionEnabled = NO;
    
    [self showIndicator:YES];
    //[self enableUIUserInteractionState:NO];
    
    void (^loginBlock)() = ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"email, first_name, last_name"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if(!error) {
                NSString *fbUserId = [[FBSDKAccessToken currentAccessToken] userID];
                NSString *fbToken =  [[FBSDKAccessToken currentAccessToken] tokenString];
                NSString *fbEmail =  result[@"email"];
                
                //hans modified - flurry
                NSDictionary *flurry_fb_param = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    result[@"email"], @"fb-email",
                                                    [NSString stringWithFormat:@"%@ %@", result[@"first_name"], result[@"last_name"]], @"fb-name",
                                                    nil];
                [[Utility sharedObject] flurryLogEvent:FLURRY_FB param:flurry_fb_param];
                //
                
                [self connectWithFacebookWithFacebookToken:fbToken facebookId:fbUserId emailAddress:fbEmail];
            }
            else {
                NSLog(@"Connect with Facebook error is %@",error.description );
                
                [self showIndicator:NO];
                //                [self enableUIUserInteractionState:YES];
            }
        }];
    };
    
    if (![[FBSDKAccessToken currentAccessToken] tokenString]) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email", @"public_profile", @"user_birthday", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                loginBlock();
            } else {
                
                [self showIndicator:NO];
                [self enableUIUserInteractionState:YES];
            }
        }];
    } else {
        loginBlock();
    }

    
}

- (void)connectWithFacebookWithFacebookToken:(NSString *)fbToken
                                  facebookId:(NSString *)facebookId
                                emailAddress:(NSString *)emailAddress {
    void (^afterLoad)() = ^{
        
        [self showIndicator:NO];
        [self enableUIUserInteractionState:YES];
    };
    
    void (^successBlock)(id element) = ^(id  _Nullable element) {
        
        [self gotoHome];
        
        //NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];
        
        //if ([self.delegate respondsToSelector:@selector(signUpDidFinish:withUsername:andPassword:)]) {
        //    [self signUpDidFinish:self withUsername:emailAddress andPassword:tempPassword];
        //}
    };
    
    void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
    ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {NSDictionary *errorDictionary = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] ? error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] : @{};
        
        NSLog(@"Error dictionary: %@", errorDictionary);
        [self handleNetworkError:error statusCode:statusCode context:nil];
    };
    
    if (self.isPayWallSubscription) {
        [[APIClient sharedInstance] userConnectWithFacebookWithFacebookToken:fbToken
                                                                  facebookId:facebookId
                                                                       email:emailAddress
                                                                  beforeLoad:nil
                                                                   afterLoad:afterLoad
                                                                successBlock:successBlock
                                                                failureBlock:failureBlock];
    } else {
        [[APIClient sharedInstance] authenticationConnectWithFacebookWithFacebookToken:fbToken
                                                                            facebookId:facebookId
                                                                                 email:emailAddress
                                                                            beforeLoad:nil
                                                                             afterLoad:afterLoad
                                                                          successBlock:successBlock
                                                                          failureBlock:failureBlock];
    }
}

#pragma mark - API

- (void)authenticationViewLoginWithEmail:(NSString *)email
                                password:(NSString *)password {
    
    [[Utility sharedObject] showMBProgress:self.view message:@""];
    [[APIClient sharedInstance] loginWithEmail:email
                                      password:password
                                  successBlock:^(id  _Nullable element) {
                                      [[Utility sharedObject] hideMBProgress];
                                      [Utility showToast:@"User login success" icon:ICON_SUCCESS toView:self.view afterDelay:2];
                                      NSError *parseError = nil;
                                      User *loggedInUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:element error:&parseError];
                                      [[UserService sharedInstance] didLoginWithUser:loggedInUser];
                                      
                                      [[Utility sharedObject] setDefaultObject:@"1" forKey:USER_SAVED];
                                      [[Utility sharedObject] setDefaultObject:email forKey:USER_NAME];
                                      [[Utility sharedObject] setDefaultObject:password forKey:USER_PASSWORD];
                                      
                                      
                                      //hans modified
                                      NSDictionary *flurry_email_param = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     loggedInUser.email, @"email",
                                                                     [NSString stringWithFormat:@"%@ %@", loggedInUser.firstName, loggedInUser.lastName], @"name",
                                                                     nil];
                                      [[Utility sharedObject] flurryLogEvent:FLURRY_EMAIL param:flurry_email_param];
                                      //
                                      [self gotoHome];
                                      
                                  } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                      [[Utility sharedObject] hideMBProgress];
                                      [Utility showToast:@"Please check your credential." icon:ICON_FAIL toView:self.view afterDelay:2];
                                  }];
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

#pragma mark - UI

- (void)enableUIUserInteractionState:(BOOL)enable {
    
    self.loginView.userInteractionEnabled = enable;
}
- (IBAction)btnForgotten:(id)sender
{
    ForgottenViewController * s = [[ForgottenViewController alloc] initWithNibName:@"ForgottenViewController" bundle:nil];
    [self.navigationController pushViewController:s animated:YES];
}
@end
