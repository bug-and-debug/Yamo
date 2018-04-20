//
//  ExploreMapDataController.h
//  Yamo
//
//  Created by Mo Moosa on 24/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import Foundation;
#import "VenueSearchSummary.h"

@class ExploreMapDataController, VenueSearchSummary, GMSMapView;

@protocol ExploreMapDataControllerDelegate <NSObject>

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didUpdateLocation:(CLLocation *)location zoomLevel:(NSUInteger)zoomLevel shouldClearCache:(BOOL)shouldClearCache;

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didSelectVenue:(VenueSearchSummary *)summary;

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didDeselectVenue:(VenueSearchSummary *)summary;

- (void)exploreMapDataControllerDidSelectUserLocation:(ExploreMapDataController *)exploreMapDataController;

- (void)exploreMapDataControllerDidDeselectUserLocation:(ExploreMapDataController *)exploreMapDataController;

- (NSDate*)getCurrentDateFromCalendar:(ExploreMapDataController *)exploreMapDataController;

@end

@interface ExploreMapDataController : NSObject

@property (nonatomic, weak) id <ExploreMapDataControllerDelegate> delegate;

- (instancetype)initWithMapViews:(ExploreMapView *)mapView GooleMap:(GMSMapView *)gMapView;

- (void)setupData:(NSArray <VenueSearchSummary *> *)data;

- (void) deselectMapMarker;

@end
