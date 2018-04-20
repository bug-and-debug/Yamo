//
//  AuthentificateViewController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchNavigationViewController.h"
@import StoreKit;

typedef NS_ENUM(NSInteger, AuthenticationType) {
    AuthenticationTypeLogin,
    AuthenticationTypeSignUp,
    AuthenticationTypeForgottenPassword
};

@interface AuthenticationViewController : UIViewController <LaunchNavigationViewController>

@property (nonatomic, weak) id <LaunchNavigationViewControllerDelegate> onboardingDelegate;
@property (nonatomic, readonly) AuthenticationType authenticationType;

@property (nonatomic, strong) SKProduct *selectedSubscription;

@property BOOL isPayWallSubscription;

- (void)switchToLoginSignup;

@end
