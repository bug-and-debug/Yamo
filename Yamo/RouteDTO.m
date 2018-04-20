//
//  RouteDTO.m
//  Yamo
//
//  Created by Peter Su on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RouteDTO.h"
#import "Route.h"
#import "RouteStep.h"
#import "Venue.h"
@import MTLModel_LOCExtensions;

@interface RouteStepDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, strong) NSNumber *sequenceOrder;

@end

@implementation RouteStepDTO

- (instancetype)initWithVenueId:(NSNumber *)venueId
                  sequenceOrder:(NSNumber *)sequenceOrder {
    
    
    if (self = [super init]) {
        _venueId = venueId;
        _sequenceOrder = sequenceOrder;
    }
    
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryMapping:@{}];
}

@end

@implementation RouteDTO

- (instancetype)initWithRouteName:(NSString *)routeName route:(Route *)route {
    
    if (self = [super init]) {
        
        _steps = [self convertRouteToRouteSteps:route];
        _name = routeName;
    }
    
    return self;
}

#pragma mark - Helper

- (NSArray<RouteStepDTO *> *)convertRouteToRouteSteps:(Route *)route {
    
    NSMutableArray<RouteStepDTO *> *steps = [NSMutableArray new];
    
    for (RouteStep *routeStep in route.steps) {
        
        if (routeStep.venue) {
            
            RouteStepDTO *dto = [[RouteStepDTO alloc] initWithVenueId:routeStep.venue.uuid
                                                        sequenceOrder:routeStep.sequenceOrder];
            
            [steps addObject:dto];
        }
    }
    return steps;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryMapping:@{}];
}

+ (NSValueTransformer *)stepsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:RouteStepDTO.class];
}

@end
