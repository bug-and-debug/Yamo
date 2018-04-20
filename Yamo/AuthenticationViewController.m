//
//  AuthentificateViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "SignUpController.h"
#import "LoginController.h"
#import "UIViewController+Network.h"
#import "UserService.h"
//#import "ForgottenPasswordViewController.h"
#import "Yamo-Swift.h"
#import "APIClient.h"

@import LOCPermissions_Swift;
@import LOCSubscription;
@import UIAlertController_LOCExtensions;

@interface AuthenticationViewController () <SignUpViewControllerDelegate, LoginViewControllerDelegate, SubscriptionFlowCoordinatorDelegate>

@property (nonatomic, weak) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) SignUpViewController *signupChildViewController;
@property (nonatomic, strong) LoginViewController *loginChildViewController;
@property (nonatomic, readwrite) AuthenticationType authenticationType;

@property (nonatomic, strong) NSString *loggingInUsingUsername;
@property (nonatomic, strong) NSString *loggingInUsingPassword;

@end

@implementation AuthenticationViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = self.isPayWallSubscription ? NO : YES;
   
    if (self.isPayWallSubscription) {
   
        self.authenticationType = AuthenticationTypeSignUp;
    }
    
        switch (self.authenticationType) {
            case AuthenticationTypeLogin:
                
                self.loginChildViewController = [LoginViewController new];
                self.loginChildViewController.delegate = self;
                self.currentViewController = self.loginChildViewController;
                self.loginChildViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
                self.loginChildViewController.isPayWallSubscription = self.isPayWallSubscription;
                
                break;
            case AuthenticationTypeSignUp:
                
                //self.signupChildViewController = [[SignUpViewController alloc] initWithAuthenticationState:AuthenticationStateSignupEmailPassword retainedValues:@{ LOCFormViewEmailKey : @"" }];
                self.signupChildViewController.delegate = self;
                self.signupChildViewController = self.signupChildViewController;
                self.signupChildViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
                self.signupChildViewController.isPayWallSubscription = self.isPayWallSubscription;
                self.currentViewController = self.signupChildViewController;

                break;
            default:
                break;
        }
        

    [self cycleFromViewController:nil toViewController:self.currentViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.currentViewController == self.signupChildViewController || self.isPayWallSubscription) {
        self.authenticationType = AuthenticationTypeSignUp;
    }
    
    if (self.currentViewController == self.loginChildViewController) {
        self.authenticationType = AuthenticationTypeLogin;
    }
}

- (void)addSubview:(UIView*)subView toView:(UIView*)parentView {
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0
                                 ],
                                [NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0
                                 ],
                                [NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0
                                 ],
                                [NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0
                                 ]
                                ]];
}

- (void)switchToLoginSignup {
    
    if ([[self.currentViewController class] isSubclassOfClass:[LoginViewController class] ]) {
        
        [self cycleFromViewController:self.currentViewController toViewController:self.signupChildViewController];
        self.currentViewController = self.signupChildViewController;
        self.authenticationType = AuthenticationTypeSignUp;
        
    } else {
        
        [self cycleFromViewController:self.currentViewController toViewController:self.loginChildViewController];
        self.currentViewController = self.loginChildViewController;
        self.authenticationType = AuthenticationTypeLogin;
    }
}

- (void)cycleFromViewController:(UIViewController*)oldViewController toViewController:(UIViewController*)newViewController {
    
//    [oldViewController.view removeFromSuperview];
//    [oldViewController willMoveToParentViewController:nil];
//    [self addChildViewController:newViewController];
//    
//    [oldViewController.view removeFromSuperview];
//    [self.containerView addSubview:newViewController.view];
//    [self addSubview:newViewController.view toView:self.containerView];
//    
//    
//    CATransition *transition = [CATransition new];
//    transition.type = kCATransitionFade;
//    transition.duration = 0.2;
//    
//    if ([oldViewController isKindOfClass:[LoginViewController class]]) {
//        transition.subtype = kCATransitionFromRight;
//    } else {
//        transition.subtype = kCATransitionFromLeft;
//    }
// 
//    [self.containerView.layer addAnimation:transition forKey:@"transition"];
//    
//    [newViewController didMoveToParentViewController:self];
//    [newViewController.view layoutIfNeeded];
    
    [self.navigationController pushViewController:newViewController animated:YES];
 
}

- (LoginViewController *)loginChildViewController {
    
    if (_loginChildViewController == nil) {
        _loginChildViewController = [LoginViewController new];
        _loginChildViewController.delegate = self;
        _loginChildViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _loginChildViewController.isPayWallSubscription = self.isPayWallSubscription;
    }
    
    return _loginChildViewController;
}

- (SignUpViewController *)signupChildViewController {
    
    if (_signupChildViewController == nil) {
        //_signupChildViewController = [[SignUpViewController alloc] initWithAuthenticationState:AuthenticationStateSignupEmailPassword retainedValues:@{ LOCFormViewEmailKey : @"" }];;
        _signupChildViewController.delegate = self;
        _signupChildViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _signupChildViewController.isPayWallSubscription = self.isPayWallSubscription;
    }
    
    return _signupChildViewController;
}

#pragma mark SignUpViewControllerDelegate

- (void)signUpDidFinish:(UIViewController *)viewController withUsername:(NSString *)username andPassword:(NSString *)password {
    
    self.loggingInUsingUsername = username;
    self.loggingInUsingPassword = password;
    
    if (self.isPayWallSubscription) {
        
        [self completeSignUpLoginProcess];
    }
    else {
        
        if ([self.onboardingDelegate respondsToSelector:@selector(viewControllerDidFinish:)]) {
            [self.onboardingDelegate viewControllerDidFinish:self];
        }
    }
}

#pragma mark LoginViewControllerDelegate

- (void)loginDidFinish:(UIViewController *)viewController withUsername:(NSString *)username password:(NSString *)password {
    
    self.loggingInUsingUsername = username;
    self.loggingInUsingPassword = password;
    
    if (self.isPayWallSubscription) {
        [self completeSignUpLoginProcess];
    }
    else {
        if ([self.onboardingDelegate respondsToSelector:@selector(viewControllerDidFinish:)]) {
            [self.onboardingDelegate viewControllerDidFinish:self];
            
        }
    }
}

- (void)loginForgottenPasswordButtonWasTapped:(LoginViewController *)viewController {
    /*
    self.authenticationType = AuthenticationTypeForgottenPassword;
    
    ForgottenPasswordViewController *forgotPasswordViewController = [ForgottenPasswordViewController new];
    forgotPasswordViewController.delegate = self;
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
     */
}

/*
#pragma mark - ForgottenPasswordViewControllerDelegate

- (void)forgotPasswordViewControllerDidChangePassword:(ForgottenPasswordViewController *)viewController withUsername:(NSString *)username password:(NSString *)password {
    
    self.loggingInUsingUsername = username;
    self.loggingInUsingPassword = password;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
    
        [self completeSignUpLoginProcess];
    }];
    [self.navigationController popToViewController:self animated:YES];
    [CATransaction commit];
}
 */

#pragma mark - Handle purchase request notification

- (void)completeSignUpLoginProcess {
    
    if (self.selectedSubscription) {
        
        if ([self userHasSubscription]) {
            
            [UIAlertController showAlertInViewController:self
                                               withTitle:NSLocalizedString(@"Existing subscription", nil)
                                                 message:NSLocalizedString(@"This account already has a subscription, which will be used.", nil)
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil
                                                tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger index) {
                                                    
                                                    [self didCompleteAuthenticationWithSubscribedUserShouldReauthenticate:NO];
                                                }];
        } else {
            [self showIndicator:YES];
            [[StoreObserver sharedInstance] buy:self.selectedSubscription];
        }
    } else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

// Update the UI according to the purchase request notification result
- (void)handlePurchasesNotification:(NSNotification *)notification {
    
    StoreObserver *storeObserver = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)storeObserver.status;
    
    switch (status) {
        case IAPPurchaseFailed: {
            [self alertWithTitle:NSLocalizedString(@"Purchase Failed", @"Subscription store alert title")
                         message:storeObserver.message];
            break;
        }
        case IAPPurchaseSucceeded: {
            [UIAlertController showAlertInViewController:self
                                               withTitle:nil
                                                 message:NSLocalizedString(@"Purchase succeeded", nil)
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil
                                                tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger index) {
                                                    
                                                    [self didCompleteAuthenticationWithSubscribedUserShouldReauthenticate:YES];
                                                }];
            break;
        }
        case IAPRestoredSucceeded: {
            // Never happens. There's no restore button.
            break;
        }
        case IAPPurchaseCancelled: {
            [UIAlertController showAlertInViewController:self
                                               withTitle:nil
                                                 message:NSLocalizedString(@"Purchase cancelled", nil)
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil
                                                tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger index) {
                                                    
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];
            break;
        }
        case IAPRestoredFailed: {
            [self alertWithTitle:NSLocalizedString(@"Restore Failed", @"Subscription store alert title")
                         message:storeObserver.message];
            break;
        }
        case IAPPurchaseDeferred: {
            [self alertWithTitle:NSLocalizedString(@"Purchase Deferred", @"Subscription store alert title")
                         message:storeObserver.message];
            break;
        }
        case IAPPurchaseUpgradeFailed: {
            [self alertWithTitle:NSLocalizedString(@"Upgrade Failed", @"Subscription store alert title")
                         message:storeObserver.message];
            break;
        }
            
        default: {
            break;
        }
    }
    
    [self showIndicator:NO];
}

#pragma mark - Upgrade User

- (BOOL)userHasSubscription {
    
    return [UserService sharedInstance].loggedInUser.userType == UserRoleTypeStandard;
}

- (void)reauthenticateWithCompletion:(void (^)())completion {
    
    if (self.loggingInUsingUsername && self.loggingInUsingPassword) {
        
        [[APIClient sharedInstance] setupAuthenticatedForEmailAddress:self.loggingInUsingUsername
                                                             password:self.loggingInUsingPassword
                                                  sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                                                      
                                                      self.loggingInUsingUsername = nil;
                                                      self.loggingInUsingPassword = nil;
                                                      
                                                      completion();
                                                  } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                                      
                                                      [self alertWithTitle:NSLocalizedString(@"Failed to authenticate", @"Failed to authenticate")
                                                                   message:NSLocalizedString(@"Please try again", nil)];
                                                  }];
    } else {
        
        [self alertWithTitle:NSLocalizedString(@"Failed to authenticate", @"Failed to authenticate")
                     message:NSLocalizedString(@"Please try again", nil)];
    }
}

- (void)didCompleteAuthenticationWithSubscribedUserShouldReauthenticate:(BOOL)reauthenticate {
    
    void (^didReauthenticateBlock)() = ^void() {
        
        SubscriptionFlowCoordinator *coordinator = [SubscriptionFlowCoordinator new];
        coordinator.delegate = self;
        
        UIViewController *nextViewController = [coordinator nextViewForCurrentViewController:self];
        
        if (!nextViewController) {
            
            [self subscriptionFlowDidFinishWithViewController:self];
        } else if (nextViewController) {
            
            if (![[self.navigationController.viewControllers lastObject] isKindOfClass:[nextViewController class]]) {
                [self.navigationController pushViewController:nextViewController animated:YES];
            } else {
                NSLog(@"Attempting to push view controller of the same class");
            }
        }
    };
    
    if (reauthenticate) {
        [self reauthenticateWithCompletion:didReauthenticateBlock];
    } else {
        didReauthenticateBlock();
    }
}

#pragma mark - Alert Helper

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:title
                                         message:message
                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:nil];
}

#pragma mark - SubscriptionFlowCoordinatorDelegate

- (void)subscriptionFlowDidFinishWithViewController:(UIViewController *)viewController {
    
    if ([self.navigationController isKindOfClass:[PaywallNavigationController class]]) {
        
        PaywallNavigationController *navigationController = (PaywallNavigationController *)self.navigationController;
        
        [navigationController.paywallDelegate paywallDidFinishedSubscription:YES];
    } else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
