//
//  RouteStep.h
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "RoutePlannerInterface.h"

@class Venue;

@interface RouteStep : MTLModel <MTLJSONSerializing, RoutePlannerInterface>

@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSNumber *sequenceOrder;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) Venue *venue;

@end
