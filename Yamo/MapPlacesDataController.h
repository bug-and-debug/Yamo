//
//  MapPlacesDataController.h
//  Yamo
//
//  Created by Mo Moosa on 28/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesDataController.h"
@class MapPlacesDataController;

@protocol MapPlacesDataControllerDelegate <PlacesDataControllerDelegate>

- (void)mapPlacesDataController:(MapPlacesDataController *)mapPlacesDataController didSelectLocation:(id <RoutePlannerInterface>)item;

@end

@interface MapPlacesDataController : PlacesDataController

@property (nonatomic, weak) id <MapPlacesDataControllerDelegate> delegate;

- (void)updateSearchResultsForString:(NSString *)string;

@end
