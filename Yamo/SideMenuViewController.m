//
//  SideMenuViewController.m
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuItemViewModel.h"
#import "SideMenuChildViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "SideMenuTableViewCell.h"
#import "APIClient+User.h"
#import "UserService.h"
#import "Yamo-Swift.h"

CGFloat const SideMenuViewControllerDefaultHeaderHeight = 200.0f;
CGFloat const SideMenuViewControllerDefaultFooterHeight = 55.0f;
CGFloat const SideMenuViewControllerDefaultCellHeight = 55.0f;
NSString * const SideMenuViewControllerCellIdentifier = @"SideMenuViewControllerCellIdentifier";
CGFloat const SideMenuViewControllerVelocityThreshold = 100.0f;

@interface SideMenuViewController () <PaywallNavigationViewControllerDelegate>

@property (nonatomic, nonnull) NSArray *menuItems;
@property (nonatomic, strong) NSString *notificationBadge;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedIndexPathBeforePaywall;

@property (nonatomic) BOOL cachedUserHasSubscription;

@end

@implementation SideMenuViewController

+ (instancetype)sharedInstance {
    static SideMenuViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.headerViewHeight = SideMenuViewControllerDefaultHeaderHeight;
        self.footerViewHeight = SideMenuViewControllerDefaultFooterHeight;
        self.menuTableView = [[UITableView alloc] init];
        self.gradientView = [[UIImageView alloc] init];
        self.menuBackgroundColor = [UIColor clearColor];
        self.viewBackgroundColor= [UIColor yamoYellow];
        self.cellSelectedBackgroundColor = [UIColor yamoOrange];
        
        [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
            self.cachedUserHasSubscription = hasSubscription;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUserSubscriptionStatusChangedForMenu:)
                                                     name:UserServiceUserTypeChangedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:self.viewBackgroundColor];
    
    self.gradientView.image = [UIImage imageNamed:@"gradientMenu"];
    
    self.menuTableView.backgroundColor = self.menuBackgroundColor;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    
    [self.view addSubview:self.gradientView];
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.menuTableView registerNib:[UINib nibWithNibName:@"SideMenuTableViewCell" bundle:nil] forCellReuseIdentifier:SideMenuViewControllerCellIdentifier];

    self.menuTableView.rowHeight =  SideMenuViewControllerDefaultCellHeight;
    self.footerViewHeight =  SideMenuViewControllerDefaultFooterHeight;

    self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupConstraintsForBackgroundGradient];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat const heightForYamoHeader = self.view.bounds.size.height - (self.menuTableView.contentSize.height + self.headerViewHeight + self.footerViewHeight);
    self.menuTableView.contentInset = UIEdgeInsetsMake(heightForYamoHeader, 0, 0, 0);
    [self loadNotificationBadge];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.menuTableView.scrollEnabled = self.menuTableView.contentSize.height > self.menuTableView.frame.size.height;
}

#pragma mark - ViewControllers

- (void)setViewControllers:(NSArray *)viewControllers {
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (UIViewController *viewController in viewControllers) {
        
        SideMenuItemViewModel *cellItem = [SideMenuItemViewModel new];
        
        if ([viewController conformsToProtocol:@protocol(SideMenuChildViewController)]) {
            
            UIViewController <SideMenuChildViewController> *childViewController = (UIViewController <SideMenuChildViewController> *) viewController;
            
            cellItem.featureAvailability = [childViewController featureAvailability];
            
            cellItem.title = [childViewController preferredTitle];
            
            if ([childViewController respondsToSelector:@selector(preferredPremiumTitle)]) {
                
                cellItem.premiumTitle = [childViewController preferredPremiumTitle];
            }
            
            if ([childViewController respondsToSelector:@selector(preferredDetailText)]) {
                
                cellItem.detailText = [childViewController preferredDetailText];
            }
        }
        else {
            
            cellItem.title = viewController.title;
        }

        [menuItems addObject:cellItem];
    }

    self.menuItems = [menuItems copy];
    
    [self selectViewControllerAtIndex:1 animated:NO];
}

- (void)selectViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {

    if (index < self.menuItems.count) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.menuTableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SideMenuViewControllerCellIdentifier forIndexPath:indexPath];

    SideMenuItemViewModel *item = self.menuItems[indexPath.row];
    
    NSString *title;
    switch (item.featureAvailability) {
        case SideMenuItemAlwaysAvailable:
            title = [item title];
            break;
        case SideMenuItemRequiresSubscription:
            title = self.cachedUserHasSubscription ? [item premiumTitle] : [item title];
            break;
        default:
            title = @"";
            break;
    }
    
    NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:title];
    [titleAttributedText addAttribute:NSKernAttributeName value:@(1.0f) range:NSMakeRange(0, [titleAttributedText length])];
    cell.titleLabel.attributedText = titleAttributedText;
    
    if (item.detailText.length == 0)
        cell.detailLabel.hidden = YES;
    else
        cell.detailLabel.text = self.notificationBadge;
    
    cell.activeColor = self.cellSelectedBackgroundColor;
    
    cell.active = [self.selectedIndexPath isEqual:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:self.cellSelectedBackgroundColor];
    [cell setSelectedBackgroundView:bgColorView];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuItemViewModel *item = self.menuItems[indexPath.row];
    
    if (item.featureAvailability == SideMenuItemRequiresSubscription && !self.cachedUserHasSubscription) {
        
        self.selectedIndexPathBeforePaywall = indexPath;
        [PaywallNavigationController presentPaywallInViewController:self paywallDelegate:self];
    }
    else {
        
        [tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        
        [self tableView:tableView didDeselectRowAtIndexPath:self.selectedIndexPath];
        
        self.selectedIndexPath = indexPath;
        [self.delegate sideMenuViewController:self didSelectItemAtIndex:indexPath.row];
        
        SideMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.active = YES;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.active = NO;
}

#pragma mark - PaywallNavigationViewControllerDelegate

- (void)paywallDidFinishedSubscription:(BOOL)hasSubscription {

    [self dismissViewControllerAnimated:YES completion:^{
        
        if (!hasSubscription) {
            return;
        }
        
        self.cachedUserHasSubscription = hasSubscription;
        [self.menuTableView reloadData];
        
        NSIndexPath *indexPath = self.selectedIndexPathBeforePaywall;
        
        self.selectedIndexPath = indexPath;
        [self.delegate sideMenuViewController:self didSelectItemAtIndex:indexPath.row];
        
        SideMenuTableViewCell *cell = [self.menuTableView cellForRowAtIndexPath:indexPath];
        
        cell.active = YES;
    }];
}

#pragma mark - Actions

- (void)handleUserSubscriptionStatusChangedForMenu:(id)sender {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        self.cachedUserHasSubscription = hasSubscription;
        [self.menuTableView reloadData];
    }];
}

- (void)handleHeaderViewTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    
}

- (void)handleFooterViewTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    
}

#pragma mark - Constraints and layout

- (void)setupConstraints {
    
    CGFloat const defaultHeight = self.view.bounds.size.height * 0.2f;
    
    if (self.headerView) {

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:0.0f]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:self.headerViewHeight]];
        
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
//                                                              attribute:NSLayoutAttributeBottom
//                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                                 toItem:self.menuTableView
//                                                              attribute:NSLayoutAttributeTop
//                                                             multiplier:1.0f
//                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.headerView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:0]];

    }
    else {
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuTableView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:defaultHeight]];
    }
    
    if (self.footerView) {
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:-8.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerView
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:self.footerViewHeight]];
        
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerView
//                                                              attribute:NSLayoutAttributeTop
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.menuTableView
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1.0f
//                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuTableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.footerView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
    else {
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.menuTableView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:defaultHeight]];

    }
    
    // Generic constraints

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuTableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuTableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:0.0f]];

}

- (void) setupConstraintsForBackgroundGradient {
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    



}

#pragma mark - API Request

- (void) loadNotificationBadge {
    
    // Only load notifications if the user has logged in and is a standard user
    
    if ([UserService sharedInstance].loggedInUser.userType == UserRoleTypeStandard) {
        
        [[APIClient sharedInstance] checkUnreadNotificationWithSuccessBlock:^(id  _Nullable element) {
            
            NSNumber *notificationCount = [NSNumber numberWithFloat:[[element objectForKey:@"notificationCount"] floatValue]];
            NSLog(@"notificationCount VAR %@",notificationCount );
            if (notificationCount.integerValue > 0) {
                self.notificationBadge = [NSString stringWithFormat:@"%@", notificationCount ];
                
            }else {
                self.notificationBadge = @"";
            }
            
            [self.menuTableView reloadData];
            
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            
            NSLog(@"ERROR %@", error);
        }];
    }
}

#pragma mark - Memory Management


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
