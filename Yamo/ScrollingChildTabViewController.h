//
//  ScrollingChildTabViewController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 29/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollingChildTabViewType) {
    ScrollingChildTabViewTypePlaces,
    ScrollingChildTabViewTypeVenues,
    ScrollingChildTabViewTypeFriendsFollowing,
    ScrollingChildTabViewTypeFriendsFollowers,
    ScrollingChildTabViewTypeRoutes
};

@class UserSummary;
@class VenueSummary;
@class RouteSummary;

@protocol ScrollingChildTabViewControllerDelegate;

@interface ScrollingChildTabViewController : UIViewController

@property (nonatomic, weak) id<ScrollingChildTabViewControllerDelegate> delegate;
@property (nonatomic) ScrollingChildTabViewType type;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(ScrollingChildTabViewType)type;

- (void)reloadWithDataSource:(NSArray *)dataSource;
- (void)reloadData;

@end

@protocol ScrollingChildTabViewControllerDelegate <NSObject>

@optional

- (void)reloadAllData;
- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectUser:(UserSummary *)userSummary;
- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectVenue:(VenueSummary *)venueSummary;
- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectRoute:(RouteSummary *)routeSummary;
- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didFollowedUser:(UserSummary *)userSummary;
- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didUnfollowedUser:(UserSummary *)userSummary;

@end
