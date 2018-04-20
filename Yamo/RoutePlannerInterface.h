//
//  RoutePlannerInterface.h
//  Yamo
//
//  Created by Peter Su on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import CoreLocation;

@protocol RoutePlannerInterface <NSObject>

- (NSString *)displayName;

- (CLLocationCoordinate2D)coordinate;

@end
