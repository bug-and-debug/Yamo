//
//  RoutePlannerVenueCollectionViewCell.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionViewCell.h"

@class RouteStep;

@interface RoutePlannerVenueCollectionViewCell : RoutePlannerCollectionViewCell

- (void)populateCollectionCellForStep:(RouteStep *)step canDelete:(BOOL)canDelete;

+ (CGFloat)calculateCellHeightForStep:(RouteStep *)step;

@end
