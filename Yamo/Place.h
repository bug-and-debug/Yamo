//
//  Place.h
//  Yamo
//
//  Created by Hungju Lu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "RoutePlannerInterface.h"
#import "PlaceType.h"

@interface Place : MTLModel <MTLJSONSerializing, RoutePlannerInterface>

@property (nonatomic, strong) NSDate *created;
@property (nonatomic) double latitude;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic) double longitude;
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) NSNumber *placeTypeValue;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *uuid;

@end
