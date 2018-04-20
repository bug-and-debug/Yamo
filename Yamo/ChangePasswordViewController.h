//
//  ChangePasswordViewController.h
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchNavigationViewController.h"

@protocol ChangePasswordViewDelegate;

@interface ChangePasswordViewController : UIViewController

@property (nonatomic, weak) id<ChangePasswordViewDelegate> delegate;

@end

@protocol ChangePasswordViewDelegate <NSObject>
@required
- (NSString *)currentEmailForChangingPassword;
- (void)changePasswordViewControllerDidChangePassword:(ChangePasswordViewController *)viewController withUsername:(NSString *)username password:(NSString *)password;
@end
