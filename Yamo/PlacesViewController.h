//
//  PlacesViewController.h
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutePlannerInterface.h"
#import "PlacesViewControllerContext.h"
#import "PlacesDataController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

@import UIView_LOCExtensions;
@import LOCSearchBar;
@import LOCPermissions_Swift;
@import CoreLocation;

@protocol PlacesDataControllerDelegate;

@interface PlacesViewController : UIViewController <UITextFieldDelegate, PlacesDataControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topPlaceholderView;
@property (weak, nonatomic) IBOutlet LOCSearchTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

- (void)setupDataController;
- (UIView *)topView;
- (void)setupAppearance;
- (void)locationWasUpdated:(CLLocation *)location;
- (void)noContentViewSetVisible:(BOOL)visible;

@end
