//
//  ForgottenPasswordViewController.h
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchNavigationViewController.h"
#import "ChangePasswordViewController.h"

@protocol ForgottenPasswordViewControllerDelegate;

@interface ForgottenPasswordViewController : UIViewController <LaunchNavigationViewController, ChangePasswordViewDelegate>

@property (nonatomic, weak) id<ForgottenPasswordViewControllerDelegate> delegate;

@end

@protocol ForgottenPasswordViewControllerDelegate <NSObject>

- (void)forgotPasswordViewControllerDidChangePassword:(ForgottenPasswordViewController *)viewController withUsername:(NSString *)username password:(NSString *)password;

@end
