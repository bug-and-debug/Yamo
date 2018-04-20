//
//  RouteStep.m
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RouteStep.h"
@import MTLModel_LOCExtensions;
#import "Venue.h"

@implementation RouteStep

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.sequenceOrder, self.venue.name];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryMapping:@{}];
}

+ (NSValueTransformer *)venueJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Venue.class];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - RoutePlannerInterface

- (NSString *)displayName {
    return self.venue.name;
}

- (CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(self.venue.latitude, self.venue.longitude);
}

@end
