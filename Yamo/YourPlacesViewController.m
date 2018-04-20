//
//  YourPlacesViewController.m
//  Yamo
//
//  Created by Peter Su on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlacesViewController.h"
#import "YourPlacesDataController.h"
#import "YourPlaceActionSheetViewController.h"
#import "Place.h"
#import "TempPlace.h"
#import "EditPlaceViewController.h"
#import "Yamo-Swift.h"
#import "UIViewController+Title.h"
@import UIAlertController_LOCExtensions;

@interface YourPlacesViewController () <YourPlacesDataControllerDelegate, YourPlaceActionSheetViewControllerDelegate, PaywallNavigationViewControllerDelegate>

@property (nonatomic, strong) YourPlacesDataController *dataController;
@property (nonatomic, copy) NSString *previousSearchText;
@property (nonatomic) PlacesViewControllerContext context;

@end

@implementation YourPlacesViewController

+ (_Nonnull instancetype)yourPlacesViewControllerWithContext:(PlacesViewControllerContext)context {
    
    YourPlacesViewController *viewController = [[YourPlacesViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
    viewController.context = context;
    
    return viewController;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldRefreshData)
                                                 name:@"Test"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.dataController.invalidated) {
        self.dataController.invalidated = NO;
        [self.dataController refreshDataSource];
    }
}

#pragma mark - Overrides

- (void)setupDataController {
    
    self.dataController = [[YourPlacesDataController alloc] initWithParentViewController:self
                                                                               tableView:self.aTableView
                                                                                 context:self.context];
}

#pragma mark - Setup

- (void)setupAppearance {
    
    [super setupAppearance];
    
    [self setAttributedTitle: NSLocalizedString(@"Your places", @"Your places view controller")];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    if (self.context != PlacesViewControllerContextSelectAdditional) {
        UIImage *rightBarButtonImage = [[UIImage imageNamed:@"IconDarkEditYourPlace"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(handleDidPressRightBarButtonItem)];
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

#pragma mark - Actions

- (void)locationWasUpdated:(CLLocation *)location {
    
    [self.dataController setCurrentLocation:location];
}

- (void)shouldRefreshData {
    
    self.dataController.invalidated = YES;
}

- (void)handleDidPressRightBarButtonItem {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        if (hasSubscription) {
            
            YourPlaceActionSheetViewController *actionSheet = [YourPlaceActionSheetViewController new];
            actionSheet.delegate = self;
            
            [self presentViewController:actionSheet animated:NO completion:nil];
        }
        else {
            
            [PaywallNavigationController presentPaywallInViewController:self paywallDelegate:self];
        }
    }];
}

- (void)updateDataControllerWithDelayForSearchText:(NSString *)searchText {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(updateDataControllerWithSearchText:)
                                               object:self.previousSearchText];
    
    [self performSelector:@selector(updateDataControllerWithSearchText:) withObject:searchText afterDelay:0.3];
    self.previousSearchText = searchText;
}

- (void)updateDataControllerWithSearchText:(NSString *)searchText {
    
    [self.dataController updateSearchResultsForString:searchText];
}

#pragma mark - PaywallNavigationViewControllerDelegate

- (void)paywallDidFinishedSubscription:(BOOL)hasSubscription {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (!hasSubscription) {
            return;
        }
        
        YourPlaceActionSheetViewController *actionSheet = [YourPlaceActionSheetViewController new];
        actionSheet.delegate = self;
        
        [self presentViewController:actionSheet animated:NO completion:nil];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *query = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [self updateDataControllerWithDelayForSearchText:query];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self updateDataControllerWithDelayForSearchText:@""];
    
    return YES;
}

#pragma mark - YourPlacesDataControllerDelegate

- (void)placesDataControllerHasContent:(BOOL)hasContent {
    
    // Show / Hide no content view
    [self noContentViewSetVisible:hasContent];
}

- (BOOL)yourPlacesDataControllerNeedToCheckDuplication:(id<RoutePlannerInterface>)place {
    
    if ([self.delegate respondsToSelector:@selector(yourPlacesViewController:needToCheckDuplication:)]) {
        return [self.delegate yourPlacesViewController:self needToCheckDuplication:place];
    }
    
    return NO;
}

- (void)yourPlacesDataControllerDidSelectPlace:(id<RoutePlannerInterface>)place {
    
    switch (self.context) {
        case PlacesViewControllerContextSelectSource:
            
            if ([self.delegate respondsToSelector:@selector(yourPlacesViewController:didSelectSourceLocation:)]) {
                [self.delegate yourPlacesViewController:self didSelectSourceLocation:place];
            }
            break;
        case PlacesViewControllerContextSelectReturn:
            
            if ([self.delegate respondsToSelector:@selector(yourPlacesViewController:didSelectReturnLocation:)]) {
                [self.delegate yourPlacesViewController:self didSelectReturnLocation:place];
            }
            break;
        case PlacesViewControllerContextSelectAdditional:
            
            if ([self.delegate respondsToSelector:@selector(yourPlacesViewController:didSelectSourceLocation:)]) {
                [self.delegate yourPlacesViewController:self didSelectAdditionalLocation:place];
            }
            break;
        default:
            break;
    }
}

#pragma mark - YourPlaceActionSheetViewControllerDelegate

- (void)yourPlaceActionSheetViewController:(YourPlaceActionSheetViewController *)controller
                   shouldEditPlaceWithType:(YourPlaceOptionType)type {
    
    PlaceType editPlaceType = PlaceTypeUnspecified;
    switch (type) {
        case YourPlaceOptionTypeHome: {
            
            editPlaceType = PlaceTypeHome;
            break;
        }
        case YourPlaceOptionTypeWork: {
            
            editPlaceType = PlaceTypeWork;
            break;
        }
    }
    
    EditPlaceViewController *test = [EditPlaceViewController editPlacesViewControllerEditingType:editPlaceType];
    [self presentViewController:test animated:YES completion:nil];
}

@end
