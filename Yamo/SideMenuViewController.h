//
//  SideMenuViewController.h
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;
@class SideMenuViewController;

extern CGFloat const SideMenuViewControllerVelocityThreshold;

@protocol SideMenuViewControllerDelegate <NSObject>

- (void)sideMenuViewController:(SideMenuViewController * _Nonnull )sideMenuViewController didSelectItemAtIndex:(NSUInteger)index;

@optional

- (void)sideMenuViewControllerDidSelectFooter:(SideMenuViewController * _Nonnull )sideMenuViewController;
- (void)sideMenuViewControllerDidSelectHeader:(SideMenuViewController * _Nonnull )sideMenuViewController;

@end

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, nullable) id <SideMenuViewControllerDelegate> delegate;

@property (nonatomic, nullable) UIView *headerView;
@property (nonatomic, nullable) UIView *footerView;
@property (nonatomic, nullable) UITableView *menuTableView;
@property (nonatomic, nullable) UIImageView *gradientView;


@property (nonatomic) CGFloat  headerViewHeight;
@property (nonatomic) CGFloat  footerViewHeight;
@property (nonatomic) UIColor * _Nullable cellBackgroundColor;
@property (nonatomic) UIColor * _Nullable cellSelectedBackgroundColor;
@property (nonatomic) UIColor * _Nullable menuBackgroundColor;
@property (nonatomic) UIColor * _Nullable viewBackgroundColor;

+ (SideMenuViewController * _Nullable) sharedInstance;
- (void)setViewControllers:(NSArray * _Nullable)viewControllers;
- (void)selectViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void) loadNotificationBadge;

@end
