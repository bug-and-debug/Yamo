//
//  PlacesDataController.m
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesDataController.h"
#import "PlaceTableViewCell.h"
#import "TempPlace.h"

@interface PlacesDataController ()

@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation PlacesDataController

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView {
 
    if (self = [super init]) {
        
        self.delegate = viewController;
        
        _tableView = tableView;
        _geocoder = [CLGeocoder new];
        _placesArray = [NSMutableArray new];
        _searchResultsArray = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Set up

- (void)initialSetup {
    
    [self setupTableView];
    [self updateDataSource];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(PlaceTableViewCell.class) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass(PlaceTableViewCell.class)];
    
    [self.tableView reloadData];
}

#pragma mark - Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    
    _userLocation = currentLocation;
    
    if (!self.currentUserLocationPlace) {
        self.currentUserLocationPlace = [TempPlace new];
        self.currentUserLocationPlace.locationName = NSLocalizedString(@"Current Location", nil);
    }
    
    self.currentUserLocationPlace.latitude = currentLocation.coordinate.latitude;
    self.currentUserLocationPlace.longitude = currentLocation.coordinate.longitude;
    
    [self.tableView reloadData];
}

#pragma mark - Public

- (void)updateDataSource {
    // Override in subclass
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
                                                  
                                                  for (NSInteger index = 0; index < results.count; index++) {
                                                      
                                                      NSManagedObject *resultObject = results[index];
                                                      
                                                      TempPlace *place = [MTLManagedObjectAdapter modelOfClass:TempPlace.class fromManagedObject:resultObject error:nil];
                                                      
                                                      [self.placesArray addObject:place];
                                                  }
                                                  
                                                  [self.tableView reloadData];
                                                  
                                                  
                                                  if ([self.delegate respondsToSelector:@selector(placesDataControllerDidEndFetchingPlaces)]) {
                                                      [self.delegate placesDataControllerDidEndFetchingPlaces];
                                                  }
                                              }];
}


- (void)updateSearchResultsForAddressWithString:(NSString *)string {
    
    if (self.geocoder.geocoding) {
        [self.geocoder cancelGeocode];
    }
    // Search postcode
    [self.geocoder geocodeAddressString:string
                      completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                          
                          if (error) {
                              
                              [self.searchResultsArray removeAllObjects];
                          } else {
                              
                              NSMutableArray *searchResultPlaces = [NSMutableArray new];
                              for (CLPlacemark *placemark in placemarks) {
                                  
                                  NSString *placeName = [[self class] nameForPlacemark:placemark];
                                  
                                  if (placeName) {
                                      TempPlace *tempPlace = [TempPlace new];
                                      tempPlace.locationName = placeName;
                                      tempPlace.latitude = placemark.location.coordinate.latitude;
                                      tempPlace.longitude = placemark.location.coordinate.longitude;
                                      
                                      [searchResultPlaces addObject:tempPlace];
                                  }
                              }
                              
                              self.searchResultsArray = searchResultPlaces;
                          }
                          
                          [self.tableView reloadData];
                      }];
}

#pragma mark - Helper

+ (NSString *)nameForPlacemark:(CLPlacemark *)placemark {
    
    if (placemark.subLocality.length && placemark.locality.length) {
        
        // e.g. Canary Wharf, London
        return [NSString stringWithFormat:@"%@, %@", placemark.subLocality, placemark.locality];
    }
    else if (placemark.subLocality) {
        
        return placemark.subLocality;
    }
    else if (placemark.locality.length && placemark.subAdministrativeArea) {
        
        return [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.subAdministrativeArea];
    }
    else if (placemark.locality.length) {
        
        return placemark.locality;
    }
    else if (placemark.administrativeArea.length) {
        
        return placemark.administrativeArea;
    }
    else if (placemark.country.length) {
        
        return placemark.country;
    }

    return nil;
}

- (BOOL)dataIsCurrentlySelected:(id<RoutePlannerInterface>)data {
    return NO;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PlaceTableViewCell.class) forIndexPath:indexPath];
    
    id<RoutePlannerInterface> data = [self dataForTableViewAtIndexPath:indexPath];
    [cell populateCellWithData:[data displayName]
                    isSelected:[self dataIsCurrentlySelected:data]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self countForTableViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PlaceTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

#pragma mark - Data helpers

- (NSInteger)countForTableViewForSection:(NSInteger)section {
    
    return 0;
}

- (id<RoutePlannerInterface>)dataForTableViewAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.currentUserLocationPlace) {
            
            if (indexPath.row == 0) {
                return self.currentUserLocationPlace;
            } else {
                return self.placesArray[indexPath.row - 1];
            }
        } else {
            return self.placesArray[indexPath.row];
        }
    } else {
        return self.searchResultsArray[indexPath.row];
    }
}

@end
