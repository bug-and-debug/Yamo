//
//  MapPlacesViewController.h
//  Yamo
//
//  Created by Mo Moosa on 28/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesViewController.h"
@class MapPlacesViewController;

@protocol MapPlacesViewControllerDelegate <NSObject>

- (void)mapPlacesViewController:(MapPlacesViewController *)controller didSelectLocation:(id<RoutePlannerInterface>)location;

@end

@interface MapPlacesViewController : PlacesViewController

@property (nonatomic, weak) id <MapPlacesViewControllerDelegate> delegate;

@end
