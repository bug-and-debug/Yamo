//
//  SideMenuMainViewController.h
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;
#import "SideMenuViewController.h"
#import "ContentNavigationController.h"
@class SideMenuMainViewController;

@protocol SideMenuMainViewControllerDelegate <NSObject>

@optional

- (void)sideMenuMainViewControllerDidSelectLogoutButton:(SideMenuMainViewController * _Nonnull)sideMenuMainViewController;

@end

@interface SideMenuMainViewController : UIViewController <SideMenuViewControllerDelegate>

@property (nullable, nonatomic, weak) id <SideMenuMainViewControllerDelegate> delegate;
@property (nullable, nonatomic) SideMenuViewController *sideMenuViewController;
@property (nullable, nonatomic) ContentNavigationController *contentNavigationController;
@property (nullable, nonatomic) NSArray *viewControllers;

@end
