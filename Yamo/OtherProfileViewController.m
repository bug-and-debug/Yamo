//
//  OtherProfileViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "APIClient+MyProfile.h"
#import "UIViewController+Network.h"
#import "UIViewController+Title.h"

@import NSObject_LOCExtensions;
@import UIAlertController_LOCExtensions;
@import AFNetworking;

NSString * const followFriend = @"icon add friend";
NSString * const unFollowFriend = @"ButtonAddedFriends";

@interface OtherProfileViewController () <ProfileDataControllerDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAttributedTitle:self.username];
    [self setHeaderView];
    
    [self.view addConstraints:[self setConstraintsForHeaderView]];
    [self.headerView.friendUnFriendButton addTarget:self action:@selector(friendUnFriendAction) forControlEvents:UIControlEventTouchUpInside];
    [self setScrollingTabViewController];
}

- (void)friendUnFriendAction {
    
    if (self.user.userFollowing) {
        
        [[APIClient sharedInstance] unFollowUserWithID:self.uuid successBlock:^(id  _Nullable element) {
            [self.dataController getUserWithID:self.uuid];
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            NSLog(@"VAR unfollow failed with %@",error );
        }];
       
    } else {
        
        [[APIClient sharedInstance] followUserWithID:self.uuid successBlock:^(id  _Nullable element) {
            [self.dataController getUserWithID:self.uuid];
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            NSLog(@"Follow failed with %@",error );
        }];
     } 
}

- (void)setHeaderView {
    
    self.headerView = [[HeaderView alloc] initWithStyle:HeaderViewStyleOtherProfileUser];
    self.headerView.backgroundColor = [UIColor yamoLightGray];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.headerView addGestureRecognizer:_tapGesture];
    [self.view addSubview:self.headerView];
}

#pragma mark - Gesture Action

- (void) closeKeyboard{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.user) {
        [self showIndicator:YES];
    }
    [self.dataController getUserWithID:self.uuid];
}

#pragma mark - ProfileDataControllerDelegate

- (void)profileDataControllerDidFetchedProfile:(ProfileDTO *)profile {
    
    self.user = profile;
    self.headerView.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName ];
    self.headerView.locationLabel.text = [NSString stringWithFormat:@"%@", profile.locationName ];
    [self.headerView.profileImageView setImageWithURL:[NSURL URLWithString:profile.profileImageUrl] placeholderImage:[UIImage imageNamed:@"profile image 1"]];
    NSString *followUnFollowImage = self.user.userFollowing ? unFollowFriend : followFriend;
    [self.headerView.friendUnFriendButton setBackgroundImage:[UIImage imageNamed:followUnFollowImage] forState:UIControlStateNormal];
    
    // If profile is visible, hide no content view regardless, otherwise hide no content view if you are following that person
    self.noContentView.hidden = profile.visible;
    [self showIndicator:NO];
}

- (void)profileDataControllerDidFailedFetchProfile:(NSString *)message {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:@"Error"
                                         message:message
                               cancelButtonTitle:@"OK"
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:nil];
    
    [self showIndicator:NO];
}

- (NSArray *) setConstraintsForHeaderView{
    
    return @[
             [NSLayoutConstraint constraintWithItem:self.headerView
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeLeading
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self.headerView
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self.headerView
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self.headerView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0
                                           constant:100]
             ];
}

@end