//
//  MyProfileViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 27/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "Yamo-Swift.h"
#import "MyProfileViewController.h"
#import "ProfileDTO.h"
#import "EditProfileDTO.h"
#import "RouteSummary.h"
#import "VenueSummary.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "APIClient+MyProfile.h"
#import "ScrollingChildTabViewController.h"
#import "UIViewController+Title.h"

@import AFNetworking;
@import UIAlertController_LOCExtensions;
@import NSString_LOCExtensions;

NSString * const editProfileImage = @"Icondarkeditdisabled";

@interface MyProfileViewController () <ScrollingChildTabViewControllerDelegate, ProfileDataControllerDelegate>

@property (nonatomic, strong) EditProfileDTO *editProfileDTO;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation MyProfileViewController
@synthesize preferredTitle = _preferredTitle;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setAttributedTitle:NSLocalizedString(@"My profile", nil)];
    
    [self setHeaderView];
    [self.view addConstraints:[self setConstraintsForHeaderView]];
    [self setScrollingTabViewController];
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:editProfileImage] style:UIBarButtonItemStylePlain target:self action:@selector(presentEdit)];
     
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)setHeaderView {
    
    self.headerView = [[HeaderView alloc] initWithStyle:HeaderViewStyleOwnUser];
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

- (void)presentEdit {
    
    EditProfileViewController *new = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    new.userObjectToEdit = self.editProfileDTO ;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.user) {
        [self showIndicator:YES];
    }
    [self.dataController reloadData];
}

#pragma mark - Setup

#pragma mark - ProfileDataControllerDelegate

- (void)profileDataControllerDidFetchedProfile:(ProfileDTO *)profile {
    
    NSDictionary *usernameAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:22.0f],
                                          NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:22.0f],
                                          NSForegroundColorAttributeName: [UIColor yamoBlack] };
    NSAttributedString *usernameAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName ]
                                                                                   attributes:usernameAttributes];
    self.headerView.usernameLabel.attributedText = usernameAttributedString;
    
    NSDictionary *locationAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                          NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                          NSForegroundColorAttributeName: [UIColor yamoDarkGray] };
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", profile.locationName ]
                                                                                   attributes:locationAttributes];
    
    self.headerView.locationLabel.attributedText = locationAttributedString;
    
    [self.headerView.profileImageView setImageWithURL:[NSURL URLWithString:profile.profileImageUrl] placeholderImage:[UIImage imageNamed:@"profile image 1"]];
    
    self.editProfileDTO = [[EditProfileDTO alloc] initWithFirstName:profile.firstName lastName:profile.lastName nickname:profile.nickname nickNameEnabled:profile.nicknameEnabled city:@"London" imageContent:profile.profileImageUrl visible:profile.visible];
    self.user = profile;
    
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

//- (void)presentOtherProfile {
//    
//    OtherProfileViewController *otherVC = [[OtherProfileViewController alloc] initWithNibName:@"OtherProfileViewController" bundle:nil];
//    //  otherVC.uuid = [self.user.followers.lastObject.uuid isValidObject] ? self.user.followers.lastObject.uuid : [NSNumber numberWithInteger:1];
//    otherVC.uuid = [NSNumber numberWithInteger:41];
//    [self.navigationController pushViewController:otherVC animated:YES];
//    //  [self presentViewController:otherVC animated:YES completion:nil];
//    
//}

- (void) reloadAllData {
    [self.dataController reloadData];
}


#pragma mark - Constraints

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

#pragma mark - Side Menu Titles

- (SideMenuItemAvailability)featureAvailability {
    
    return SideMenuItemRequiresSubscription;
}

- (NSString *)preferredTitle {
    
    return NSLocalizedString(@"Join Now", nil);
}

- (NSString *)preferredPremiumTitle {
    
    return NSLocalizedString(@"Profile", nil);
}

@end
