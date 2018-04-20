//
//  PlacesDataController.h
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStore.h"
@import CoreLocation;

@class TempPlace;
@protocol PlacesDataControllerDelegate;
@protocol RoutePlannerInterface;

@interface PlacesDataController : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak) id<PlacesDataControllerDelegate> delegate;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) TempPlace *currentUserLocationPlace;
@property (nonatomic, strong) NSMutableArray<id<RoutePlannerInterface>> *placesArray;
@property (nonatomic, strong) NSMutableArray<id<RoutePlannerInterface>> *searchResultsArray;

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView;
- (void)initialSetup;
- (void)setupTableView;
- (void)setCurrentLocation:(CLLocation *)currentLocation;
- (void)updateDataSource;
- (void)loadRecentPlaces;
- (void)updateSearchResultsForAddressWithString:(NSString *)string;
- (BOOL)dataIsCurrentlySelected:(id<RoutePlannerInterface>)data;
+ (NSString *)nameForPlacemark:(CLPlacemark *)placemark;

#pragma mark - Data Helpers

- (NSInteger)countForTableViewForSection:(NSInteger)section;

- (id<RoutePlannerInterface>)dataForTableViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol PlacesDataControllerDelegate <NSObject>

- (void)placesDataControllerHasContent:(BOOL)hasContent;
- (void)persistTempPlace:(TempPlace *)tempPlace;

@optional

- (void)placesDataControllerDidStartFetchingPlaces;
- (void)placesDataControllerDidEndFetchingPlaces;

@end
