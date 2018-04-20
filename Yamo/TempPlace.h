//
//  TempPlace.h
//  Yamo
//
//  Created by Peter Su on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>
#import "RoutePlannerInterface.h"
#import "CoreDataOrganizeService.h"

static NSInteger const NumberOfRecentPlaces = 3;

/*
 *  This model is not on the server side.
 *  It is only used to store recent addresses and represents the model for current location
 *  when selecting a place in Your Places + Route Planner.
 */
@interface TempPlace : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing, RoutePlannerInterface, CoreDataOrganizable>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, strong) NSDate *storeDate;
@property (nonatomic, strong) NSNumber *uuid;

- (BOOL)isEqualToTempPlace:(TempPlace *)otherPlace;

@end
