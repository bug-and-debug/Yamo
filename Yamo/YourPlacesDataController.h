//
//  YourPlacesDataController.h
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesDataController.h"
#import "PlacesViewControllerContext.h"

@protocol YourPlacesDataControllerDelegate;

@interface YourPlacesDataController : PlacesDataController

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView
                                     context:(PlacesViewControllerContext)context;

- (void)updateSearchResultsForString:(NSString *)string;

- (void)refreshDataSource;

@property (nonatomic) BOOL invalidated;
@property (nonatomic, weak) id<YourPlacesDataControllerDelegate, PlacesDataControllerDelegate> delegate;

@end

@protocol YourPlacesDataControllerDelegate <PlacesDataControllerDelegate>

- (BOOL)yourPlacesDataControllerNeedToCheckDuplication:(id<RoutePlannerInterface>)place;

- (void)yourPlacesDataControllerDidSelectPlace:(id<RoutePlannerInterface>)place;

@end
