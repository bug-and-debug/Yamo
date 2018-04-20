//
//  SavePlaceDTO.m
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SavePlaceDTO.h"
@import MTLModel_LOCExtensions;

@interface SavePlaceDTO ()

@property (nonatomic, strong, readwrite) NSNumber *placeType;

@end

@implementation SavePlaceDTO

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ @"type" ]
                                                             dictionary:@{ @"latitude" : @"lat",
                                                                           @"longitude" : @"lon",
                                                                           @"locationName" : @"location" }];
    return propertyMappings;
}

+ (NSValueTransformer *)typeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(PlaceTypeUnspecified),
                            @"HOME" : @(PlaceTypeHome),
                            @"WORK" : @(PlaceTypeWork),
                            };
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(PlaceTypeUnspecified)
                                                     reverseDefaultValue:@(PlaceTypeUnspecified)];
}

#pragma mark - Setters

- (void)setType:(PlaceType)type {
    _type = type;
    
    switch (type) {
        case PlaceTypeUnspecified:
            _placeType = @(0);
            break;
        case PlaceTypeHome:
            _placeType = @(1);
            break;
        case PlaceTypeWork:
            _placeType = @(2);
            break;
    }
}

@end
