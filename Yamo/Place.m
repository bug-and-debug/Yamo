//
//  Place.m
//  Yamo
//
//  Created by Hungju Lu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "Place.h"
@import MTLModel_LOCExtensions;

@implementation Place

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ @"latitude" : @"lat",
                                                                           @"longitude" : @"lon",
                                                                           @"locationName" : @"location" }];
    return propertyMappings;
}

+ (NSValueTransformer *)placeTypeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(PlaceTypeUnspecified),
                            @"HOME" : @(PlaceTypeHome),
                            @"WORK" : @(PlaceTypeWork),
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(PlaceTypeUnspecified)
                                                     reverseDefaultValue:@(PlaceTypeUnspecified)];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - RoutePlannerInterface

- (NSString *)displayName {
    
    switch (self.placeType) {
        case PlaceTypeHome:
            return NSLocalizedString(@"Home", @"Place type Home");
        case PlaceTypeWork:
            return NSLocalizedString(@"Work", @"Place type Home");
        default:
            return @"";
    }
}

- (CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
