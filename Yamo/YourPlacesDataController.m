//
//  YourPlacesDataController.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlacesDataController.h"
#import "YourPlaceTableHeaderView.h"
#import "APIClient+Venue.h"
#import "RouteStep.h"
#import "Venue.h"
#import "Place.h"
#import "TempPlace.h"
#import "SearchDTO.h"
#import "CoreDataStore.h"
#import "PlaceTableViewCell.h"
#import "UserService.h"

@import MapKit;

@interface YourPlacesDataController () <MKLocalSearchCompleterDelegate>

@property (nonatomic) PlacesViewControllerContext context;

@end

@implementation YourPlacesDataController

@dynamic delegate;

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView
                                     context:(PlacesViewControllerContext)context {
    
    if (self = [super initWithParentViewController:viewController tableView:tableView]) {
        _context = context;
        
        [self initialSetup];
    }
    
    return self;
}

#pragma mark - Set up

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(YourPlaceTableHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(YourPlaceTableHeaderView.class)];
    
    [super setupTableView];
}

#pragma mark - Data Helper

- (NSInteger)countForTableViewForSection:(NSInteger)section {
    
    NSInteger countForTableView = 0;
    NSInteger totalCountForTableView = [self totalNumberOfRowsInAllSections];
    
    if (section == 0) {
        
        if (self.context == PlacesViewControllerContextSelectAdditional) {
            countForTableView = 0;
        } else if (self.currentUserLocationPlace) {
            countForTableView = self.placesArray.count + 1;
        } else {
            countForTableView = self.placesArray.count;
        }
        
    } else {
        countForTableView = self.searchResultsArray.count;
    }
    
    if ([self.delegate respondsToSelector:@selector(placesDataControllerHasContent:)]) {
        [self.delegate placesDataControllerHasContent:(totalCountForTableView > 0)];
    }
    
    return countForTableView;
}

- (NSInteger)totalNumberOfRowsInAllSections {
    
    NSInteger totalCountForTableView = 0;
    
    if (self.context == PlacesViewControllerContextSelectAdditional) {
        totalCountForTableView = 0;
    } else if (self.currentUserLocationPlace) {
        totalCountForTableView += self.placesArray.count + 1;
    } else {
        totalCountForTableView += self.placesArray.count;
    }
    
    totalCountForTableView += self.searchResultsArray.count;
    
    return totalCountForTableView;
}

- (void)refreshDataSource {
    
    [self.placesArray removeAllObjects];
    [self.tableView reloadData];
    
    [self updateDataSource];
}

- (void)updateDataSource {
    
    if ([self.delegate respondsToSelector:@selector(placesDataControllerDidStartFetchingPlaces)]) {
        [self.delegate placesDataControllerDidStartFetchingPlaces];
    }
    
    [[APIClient sharedInstance] venueListPlacesWithSuccessBlock:^(NSArray * _Nullable elements) {
        
        [self.placesArray addObjectsFromArray:elements];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        NSLog(@"Error %ld when fetching places: %@", (long)statusCode, context);
    } afterBlock:^{
        
        switch (self.context) {
            case PlacesViewControllerContextSelectSource:
            case PlacesViewControllerContextSelectReturn: {
                [self loadRecentPlaces];
                break;
            }
            case PlacesViewControllerContextSelectAdditional: {
                
                if ([self.delegate respondsToSelector:@selector(placesDataControllerDidEndFetchingPlaces)]) {
                    [self.delegate placesDataControllerDidEndFetchingPlaces];
                }
                break;
            }
        }
    }];
}

- (void)loadRecentPlaces {
    
    NSManagedObjectContext *bmoc = [CoreDataStore sharedInstance].backgroundManagedObjectContext;
    NSSortDescriptor *tempPlaceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(storeDate))
                                                                              ascending:NO];
    
    [[CoreDataStore sharedInstance] fetchEntriesForEntityName:NSStringFromClass([TempPlace class])
                                                withPredicate:nil
                                              sortDescriptors:@[tempPlaceSortDescriptor]
                                         managedObjectContext:bmoc
                                                 asynchronous:NO
                                                   fetchLimit:NumberOfRecentPlaces
                                              completionBlock:^(NSArray *results) {
                                                  
                                                  NSMutableSet *set = [NSMutableSet set];
                                                  
                                                  for (NSInteger index = 0; index < results.count; index++) {
                                                      
                                                      NSManagedObject *resultObject = results[index];
                                                      
                                                      TempPlace *place = [MTLManagedObjectAdapter modelOfClass:TempPlace.class fromManagedObject:resultObject error:nil];
                                                      
                                                      [set addObject:place];
                                                  }
                                                  
                                                  [self.placesArray addObjectsFromArray:[set allObjects]];
                                                  
                                                  [self.tableView reloadData];
                                                  
                                                  if ([self.delegate respondsToSelector:@selector(placesDataControllerDidEndFetchingPlaces)]) {
                                                      [self.delegate placesDataControllerDidEndFetchingPlaces];
                                                  }
                                              }];
}

- (void)updateSearchResultsForString:(NSString *)string {
    
    switch (self.context) {
        case PlacesViewControllerContextSelectSource:
        case PlacesViewControllerContextSelectReturn: {
            [self updateSearchResultsForAddressWithString:string];
            break;
        }
        case PlacesViewControllerContextSelectAdditional: {
            
            [self updateSearchResultsForVenuesWithString:string];
            break;
        }
    }
}

- (void)updateSearchResultsForVenuesWithString:(NSString *)string {
    
    if (string && string.length) {
        // Create SearchDTO
        double latitude = self.userLocation ? self.userLocation.coordinate.latitude : 0;
        double longitude = self.userLocation ? self.userLocation.coordinate.longitude : 0;
        
        SearchDTO *searchDTO = [[SearchDTO alloc] initWithLatitude:latitude
                                                         longitude:longitude
                                                          distance:UserServiceDefaultSearchMilesRadius
                                                      searchString:string];
        
        [[APIClient sharedInstance] venueSearchVenuesWithSearchDTO:searchDTO
                                                      successBlock:^(NSArray * _Nullable elements) {
                                                          
                                                          // Convert the elements to a temporary RouteStep
                                                          NSMutableArray *stepResults = [NSMutableArray new];
                                                          for (Venue *venue in elements) {
                                                              RouteStep *newRouteStep = [RouteStep new];
                                                              newRouteStep.venue = venue;
                                                              
                                                              [stepResults addObject:newRouteStep];
                                                          }
                                                          
                                                          self.searchResultsArray = stepResults;
                                                          
                                                          [self.tableView reloadData];
                                                          
                                                      } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                                          
                                                          [self.searchResultsArray removeAllObjects];
                                                          [self.tableView reloadData];
                                                      }];
    } else {
        
        [self.searchResultsArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (BOOL)dataIsCurrentlySelected:(id<RoutePlannerInterface>)data {
    
    BOOL duplicated = NO;
    
    if ([self.delegate respondsToSelector:@selector(yourPlacesDataControllerNeedToCheckDuplication:)]) {
        duplicated = [self.delegate yourPlacesDataControllerNeedToCheckDuplication:data];
    }
    
    return duplicated;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1f;
    } else {
        return 30.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YourPlaceTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(YourPlaceTableHeaderView.class)];
    
    NSString *sectionTitleString = @"";
    
    if (section == 1) {
        if (self.searchResultsArray.count > 0) {
            sectionTitleString = NSLocalizedString(@"Search results", nil);
        }
    }
    
    [headerView populateWithData:sectionTitleString];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<RoutePlannerInterface> item = [self dataForTableViewAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(yourPlacesDataControllerDidSelectPlace:)] && ![self dataIsCurrentlySelected:item]) {
        
        switch (self.context) {
            case PlacesViewControllerContextSelectSource:
            case PlacesViewControllerContextSelectReturn: {
                
                if (indexPath.section == 1 && [item isKindOfClass:TempPlace.class]) {
                    
                    // Persist for recent location if it's a temp place
                    if ([self.delegate respondsToSelector:@selector(persistTempPlace:)]) {
                        [self.delegate persistTempPlace:(TempPlace *)item];
                    }
                }
                break;
            }
            case PlacesViewControllerContextSelectAdditional:
            default: {
                break;
            }
        }
        
        [self.delegate yourPlacesDataControllerDidSelectPlace:item];
    }
}


@end
