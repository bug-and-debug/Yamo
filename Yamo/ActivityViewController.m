//
//  ActivityViewController.m
//  Yamo
//
//  Created by Mo Moosa on 22/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "NotificationTableViewCell.h"
#import "APIClient+User.h"
#import "Notification.h"
#import "SideMenuViewController.h"
#import "Yamo-Swift.h"
#import "OtherProfileViewController.h"
#import "NoContentView.h"
#import "UIViewController+Network.h"
#import "UIViewController+Title.h"
@import NSDate_LOCExtensions;
@import UIView_LOCExtensions;

@interface ActivityViewController () <UITableViewDelegate,UITableViewDataSource,NotificationTableViewCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (strong, nonatomic) NoContentView *noContentView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isReloading;
@property (nonatomic) BOOL hasNextPage;
@property (nonatomic) double lastUpdate;
@property (nonatomic, strong) NSDate *firstUpdate;

@property (retain, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ActivityViewController
@synthesize preferredTitle = _preferredTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAttributedTitle:NSLocalizedString(@"Notification", nil)];
    [self setTableViewInViewController];
}

- (void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self setDatasourceForTableView];
}

#pragma mark - Setters

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    
    [self showIndicator:self.dataSource.count > 0 ? NO : isLoading];
}

#pragma mark - set TableView in View 

- (void) setTableViewInViewController {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    
    [self.view addSubview:self.tableView];
    [self setupConstraintsForTableView];
    
    [self setRefreshView];


    [self setupNoContentView];
}

- (void) setRefreshView {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor yamoYellow];
    [self.refreshControl addTarget:self
                            action:@selector(reloadNotification)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)setupNoContentView {
    
    self.noContentView = [[NoContentView alloc] initWithWithNoContentType:NoContentViewTypeNotifications];
    self.tableView.backgroundView = self.noContentView;
}

#pragma mark - set Data For tableView

- (void) setDatasourceForTableView {
    
    self.hasNextPage=YES;
    self.isLoading = NO;
    self.isReloading = NO;
    
    if (!self.firstUpdate) {
        self.firstUpdate = [NSDate date];
        self.lastUpdate = [self.firstUpdate timeIntervalSince1970];
        [self getNotificationListWithTime:self.lastUpdate withOlder:YES];

    } else {
        
        [self getNotificationListWithTime:[self.firstUpdate timeIntervalSince1970] withOlder:NO];
    }
}

- (void) reloadNotification {
    
    //    [self setDatasourceForTableView];
    self.lastUpdate = [[NSDate date] timeIntervalSince1970];
    self.hasNextPage=YES;
    self.isReloading = YES;
    [self getNotificationListWithTime:self.lastUpdate withOlder:YES];
    
    // End the refreshing
    if (self.refreshControl) {

        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Set Constraints

- (void) setupConstraintsForTableView {
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.noContentView.hidden = self.dataSource.count > 0;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell = (NotificationTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForHeader];

    Notification *notification = self.dataSource[indexPath.row];
    if ([notification isKindOfClass:[Notification class]]) {
        
        NSString *textLabel = [Notification displayTextForNotification:notification];
        NSString *dateLabel =[notification.updated relativeDateString];
        
        NSDictionary *titleAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:22],
                                           NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:22],
                                           NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                           NSParagraphStyleAttributeName: style};
        NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:textLabel attributes:titleAttributes];
        
        cell.titleLabel.attributedText = titleAttributedString;
        
        NSDictionary *dateAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
                                           NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
                                           NSForegroundColorAttributeName: [UIColor yamoBlack]};
        NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:dateLabel attributes:dateAttributes];
        
        cell.timestampLabel.attributedText = dateAttributedString;
        
        cell.notificationCellDelegate=self;
        cell.backgroundColor = !notification.notificationRead ? [UIColor yamoLightGray] : [UIColor whiteColor];
        
        [self configureCell:cell forNotification:notification atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)configureCell:(NotificationTableViewCell *)cell forNotification:(Notification *)notification atIndexPath:(NSIndexPath *) indexPath{
    
    switch (notification.type) {
            
        case NotificationTypeFacebookFriend:
            
            cell.cellStyle = NotificationCellStyleAccessoryButton;
            cell.addFriendButton.selected = notification.following? YES : NO;
            cell.notificationCellDelegate=self;
            [cell.imageViewCell setImage:[UIImage imageWithColor:[UIColor yamoCornflowerBlue]]];
            break;
            
        default:
            
            cell.cellStyle = NotificationCellStyleDefault;
            [cell.imageViewCell setImage:[UIImage imageWithColor:[UIColor yamoDarkGray]]];
            
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    Notification *notification = self.dataSource[indexPath.row];
    
    if ([notification isKindOfClass:[Notification class]]) {
        
        if (!notification.notificationRead) {
            [self markNotificationAsReadWithNotificationID:notification indexPath:indexPath];
        }
        
        switch (notification.type) {
                
            case NotificationTypeGetToKnowMe:{
                
                GetToKnowMeOnboardingViewController *getToKnowMeViewController = [[GetToKnowMeOnboardingViewController alloc] initWithNibName:@"GetToKnowMeOnboardingViewController" bundle:nil];
                [self.navigationController pushViewController:getToKnowMeViewController animated:YES];
                
                break;
            }
            case NotificationTypeCurrentLocationSuggestion:
            case NotificationTypeExibition:{
                
                if (notification.associatedVenue){
                    ExhibitionInfoViewController *exhibitionInfoViewController = [[ExhibitionInfoViewController alloc] initWithNibName:@"ExhibitionInfoViewController" bundle:nil];
                    exhibitionInfoViewController.venueUUID = notification.associatedVenue;
                    
                    [self.navigationController pushViewController:exhibitionInfoViewController animated:YES];
                }
                
                break;
            }
            case NotificationTypeFacebookFriend: {
                
                if (notification.associatedUser) {
                    OtherProfileViewController *otherVC = [[OtherProfileViewController alloc] initWithNibName:@"OtherProfileViewController" bundle:nil];
                    otherVC.uuid = notification.associatedUser;
                    [self.navigationController pushViewController:otherVC animated:YES];
                }
                
                break;
            }
            case NotificationTypeUnspecified:
                
                break;
            default:
                break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row == self.dataSource.count - 1 && !self.isLoading && self.hasNextPage ){
        //end of loading
        //for example [activityIndicator stopAnimating];
        [self getNotificationListWithTime:self.lastUpdate withOlder:YES];
    }
}

#pragma mark - Notification APIs

- (void) getNotificationListWithTime:(double) fromTime withOlder:(BOOL) wantOlder{

    long long timeInMilisInt64 = (long long)(fromTime * 1000);
    self.isLoading = YES;
    [[APIClient sharedInstance] getNotificationListWithFromValue:timeInMilisInt64 older:wantOlder andSuccessBlock:^(id  _Nullable element) {
                
        if ([element isKindOfClass:[NSArray class]]) {
            
            if (self.isReloading){
                [self.dataSource removeAllObjects];
                self.isReloading = NO;
            }
            
            NSMutableArray *arrayOfNotification = [element mutableCopy];
            Notification *notification;
            
            if (arrayOfNotification.count > 0) {
                
                if ([[arrayOfNotification firstObject] isKindOfClass:[Notification class]]) {
                    notification = [arrayOfNotification firstObject];
                }
                
                if (wantOlder) {
                    
                    if (!self.dataSource.count){
                        self.firstUpdate = notification.created;
                        self.dataSource = arrayOfNotification;
                    }
                    else {
                        
                        [self.dataSource addObjectsFromArray:arrayOfNotification];
                    }
                    
                }
                else {
                    
                    [arrayOfNotification addObjectsFromArray:self.dataSource];
                    self.dataSource = arrayOfNotification;
                    
                }
                
                if ([[self.dataSource lastObject] isKindOfClass:[Notification class]]) {
                    Notification *notificationLast = [self.dataSource lastObject];
                    self.lastUpdate = [notificationLast.created timeIntervalSince1970];
                }
            }
            else {
                
                self.hasNextPage = NO;
            }
            
            self.isLoading = NO;
            [self.tableView reloadData];
            
        }
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        NSLog(@"ERROR %@", error);
        self.isLoading = NO;
        
    }];
    
}


- (void) markNotificationAsReadWithNotificationID:(Notification *) notification indexPath:(NSIndexPath *) indexPath{
    
    [[APIClient sharedInstance] markNotificationID:notification.uuid andSuccessBlock:^(id  _Nullable element) {
        NSLog(@"Response %@", [element description]);
        notification.notificationRead=YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        notification.notificationRead=NO;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"ERROR %@", error);
    }];

}

#pragma mark - Follow User


- (void) didPressButtonFollow:(NotificationTableViewCell *)cell{
    
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    
    Notification *notification = self.dataSource[indexPath.row];
    
    if ([notification isKindOfClass:[Notification class]]) {
        
        if (!notification.following) {
            [self followUserFromNotification:notification indexPath:indexPath];
        }
        else {
            [self unfollowUserFromNotification:notification indexPath:indexPath];
        }
    }

}

- (void) followUserFromNotification:(Notification *)notification indexPath:(NSIndexPath *) indexPath {
    
    [[APIClient sharedInstance] followUserWithUserID:notification.associatedUser andSuccessBlock:^(id  _Nullable element) {
        NSLog(@"Response %@", [element description]);
        
        notification.following=YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"ERROR %@", error);
        
    }];
}

- (void) unfollowUserFromNotification:(Notification *)notification indexPath:(NSIndexPath *) indexPath {
    
    [[APIClient sharedInstance] unfollowUserWithUserID:notification.associatedUser andSuccessBlock:^(id  _Nullable element) {
        NSLog(@"Response %@", [element description]);
        
        notification.following=NO;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"ERROR %@", error);
        
    }];
}

#pragma mark - Side Menu Titles

- (SideMenuItemAvailability)featureAvailability {
    return SideMenuItemRequiresSubscription;
}

- (NSString *)preferredTitle {
    
    return NSLocalizedString(@"Notifications", nil);
}

- (NSString *)preferredPremiumTitle {
    
    return NSLocalizedString(@"Notifications", nil);
}

- (NSString *) preferredDetailText {

    return @"3";
}

@end
