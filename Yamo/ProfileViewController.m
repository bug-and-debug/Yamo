//
//  ProfileViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ProfileViewController.h"
#import "ScrollingChildTabViewController.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "APIClient+MyProfile.h"
#import "APIClient+Venue.h"
#import "RoutePlannerViewController.h"
#import "Yamo-Swift.h"
#import "OtherProfileViewController.h"
#import "NSNumber+Yamo.h"

@import UIView_LOCExtensions;
@import UIAlertController_LOCExtensions;

@interface ProfileViewController ()  <ScrollingTabViewControllerDelegate, UIGestureRecognizerDelegate, ProfileDataControllerDelegate, ScrollingChildTabViewControllerDelegate>
@property (nonatomic, strong) ScrollingTabViewController *scrollingTabViewController;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setScrollingTabViewController {
    self.scrollingTabViewController = [[ScrollingTabViewController alloc] init];
    
    self.scrollingTabViewController.selectedTextAttributes = @{NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                                               NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                                               NSForegroundColorAttributeName: [UIColor yamoYellow]};
    
    self.scrollingTabViewController.normalTextAttributes = @{NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                                               NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                                               NSForegroundColorAttributeName: [UIColor yamoGray]};
    
    self.scrollingTabViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.scrollingTabViewController];
    [self.view addSubview:self.scrollingTabViewController.view];
    self.scrollingTabViewController.delegate = self;
    [self.view addConstraints:[self setConstraintsForScollingTabView]];
    
    // Setting Tabs for ScrollingTabViewController
    NSArray *scrollingChildTabViewControllers = [self scrollingChildTabViewControllers];
    self.scrollingTabViewController.viewControllers = scrollingChildTabViewControllers;
    
    self.dataController = [[ProfileDataController alloc] initWithChildTabViewControllers:scrollingChildTabViewControllers];
    self.dataController.delegate = self;
    
    [self.scrollingTabViewController didMoveToParentViewController:self];
    
    [self setupNoContentView];
}

- (void)setupNoContentView {
    
    self.noContentView = [[NoContentView alloc] initWithWithNoContentType:NoContentViewTypeOtherProfilePrivate];
    self.noContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.noContentView];
    
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeTop toView:self.scrollingTabViewController.contentScrollView];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeLeading toView:self.scrollingTabViewController.contentScrollView];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeTrailing toView:self.scrollingTabViewController.contentScrollView];
    [self.view pinView:self.noContentView withAttribute:NSLayoutAttributeBottom toView:self.scrollingTabViewController.contentScrollView];
    
    self.noContentView.hidden = YES;
}

- (NSArray *)scrollingChildTabViewControllers {
    
    NSMutableArray *scrollingChildTabViewControllers = [[NSMutableArray alloc] init];
    
    ScrollingChildTabViewController *venuesTabViewController = [[ScrollingChildTabViewController alloc] initWithNibName:NSStringFromClass([ScrollingChildTabViewController class])
                                                                                             bundle:nil type:ScrollingChildTabViewTypeVenues];
    venuesTabViewController.delegate = self;
    venuesTabViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    venuesTabViewController.title = NSLocalizedString(@"Places", "places");
    venuesTabViewController.view.backgroundColor = [UIColor yamoLightGray];
    [scrollingChildTabViewControllers addObject:venuesTabViewController];
    
    ScrollingChildTabViewController *followingTabViewController = [[ScrollingChildTabViewController alloc] initWithNibName:NSStringFromClass([ScrollingChildTabViewController class])
                                                                                             bundle:nil type:ScrollingChildTabViewTypeFriendsFollowing];
    followingTabViewController.delegate = self;
    followingTabViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    followingTabViewController.title = NSLocalizedString(@"Following", "following");
    followingTabViewController.view.backgroundColor = [UIColor yamoLightGray];
    [scrollingChildTabViewControllers addObject:followingTabViewController];
    
    ScrollingChildTabViewController *followersTabViewController = [[ScrollingChildTabViewController alloc] initWithNibName:NSStringFromClass([ScrollingChildTabViewController class])
                                                                                             bundle:nil type:ScrollingChildTabViewTypeFriendsFollowers];
    followersTabViewController.delegate = self;
    followersTabViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    followersTabViewController.title = NSLocalizedString(@"Followers", "followers");
    followersTabViewController.view.backgroundColor = [UIColor yamoLightGray];
    [scrollingChildTabViewControllers addObject:followersTabViewController];
    
    ScrollingChildTabViewController *routesTabViewController = [[ScrollingChildTabViewController alloc] initWithNibName:NSStringFromClass([ScrollingChildTabViewController class])
                                                                                             bundle:nil type:ScrollingChildTabViewTypeRoutes];
    routesTabViewController.delegate = self;
    routesTabViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    routesTabViewController.title = NSLocalizedString(@"Route", "route");
    routesTabViewController.view.backgroundColor = [UIColor yamoLightGray];
    [scrollingChildTabViewControllers addObject:routesTabViewController];
    
    return scrollingChildTabViewControllers;
}

- (NSArray *) setConstraintsForScollingTabView{
    
    return @[
             [NSLayoutConstraint constraintWithItem:self.scrollingTabViewController.view
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeLeading
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self.scrollingTabViewController.view
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.headerView
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                           constant:100],
             [NSLayoutConstraint constraintWithItem:self.scrollingTabViewController.view
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:0]
             ,
             [NSLayoutConstraint constraintWithItem:self.scrollingTabViewController.view
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                           constant:0]
             ];
}

#pragma mark ScrollingTabViewController

- (void)scrollingTabViewControllerDidSelectViewController:(ScrollingTabViewController *)scrollingTabViewController selectedViewController:(UIViewController *)selectedViewController {
    
    [self.view endEditing:YES];
}

- (BOOL)tabsShouldHaveDynamicWidth {
    return NO;
}

- (CGFloat)tabsMarginForDynamicWidth {
    return 0.0f;
}

#pragma mark - ScrollingChildTabViewControllerDelegate

- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectUser:(UserSummary *)userSummary {
    
    NSLog(@"follow?%@",[userSummary description]);
    OtherProfileViewController *otherVC = [[OtherProfileViewController alloc] initWithNibName:@"OtherProfileViewController" bundle:nil];
    otherVC.uuid = userSummary.uuid;
    otherVC.username = userSummary.username;
    [self.navigationController pushViewController:otherVC animated:YES];
    
}

- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectVenue:(VenueSummary *)venueSummary {
    
    ExhibitionInfoViewController *exhibitionInfoViewController = [[ExhibitionInfoViewController alloc] initWithNibName:@"ExhibitionInfoViewController" bundle:nil];
    exhibitionInfoViewController.venueUUID = venueSummary.uuid;
    
    [self.navigationController pushViewController:exhibitionInfoViewController animated:YES];
}

- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didSelectRoute:(RouteSummary *)routeSummary {
    
    // Fetch single route and then open route planner
    [self showIndicator:YES];
    
    [[APIClient sharedInstance] venueGetSingleRoute:routeSummary.uuid withSuccessBlock:^(id  _Nullable element) {
        [self showIndicator:NO];
        
        if ([element isKindOfClass:Route.class]) {
            Route *route = (Route *)element;
            RoutePlannerViewController *routePlannerViewController = [[RoutePlannerViewController alloc] initWithRoute:route];
            [self.navigationController pushViewController:routePlannerViewController animated:YES];
        } else {
            [self showAlertWithMessage:NSLocalizedString(@"Failed to fetch route", nil)];
        }
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        [self showIndicator:NO];
        [self showAlertWithMessage:NSLocalizedString(@"Failed to fetch route", nil)];
    }];
}

- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didFollowedUser:(UserSummary *)userSummary {
    
    ScrollingChildTabViewController *currentController = (ScrollingChildTabViewController *)self.scrollingTabViewController.selectedViewController;
    
    switch (currentController.type) {
        case ScrollingChildTabViewTypeFriendsFollowers:
            
            [self.dataController appendData:userSummary forChildTabType:ScrollingChildTabViewTypeFriendsFollowing];
            
            break;
        case ScrollingChildTabViewTypeFriendsFollowing:
            
            [self.dataController updateData:userSummary forChildTabType:ScrollingChildTabViewTypeFriendsFollowers];
            
            break;
        default:
            break;
    }
}

- (void)scrollingChildTabViewController:(ScrollingChildTabViewController *)childViewController didUnfollowedUser:(UserSummary *)userSummary {
    
    ScrollingChildTabViewController *currentController = (ScrollingChildTabViewController *)self.scrollingTabViewController.selectedViewController;
    
    switch (currentController.type) {
        case ScrollingChildTabViewTypeFriendsFollowers:
            
            [self.dataController removeData:userSummary forChildTabType:ScrollingChildTabViewTypeFriendsFollowing];
            
            break;
        case ScrollingChildTabViewTypeFriendsFollowing:
            
            [self.dataController updateData:userSummary forChildTabType:ScrollingChildTabViewTypeFriendsFollowers];
            
            break;
        default:
            break;
    }
}

#pragma mark - Alert

- (void)showAlertWithMessage:(NSString *)message {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:nil
                                         message:message
                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:nil];
}

@end
