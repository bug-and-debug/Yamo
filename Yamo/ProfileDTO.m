//
//  ProfileDTO.m
//  Yamo
//
//  Created by Hungju Lu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ProfileDTO.h"
@import MTLModel_LOCExtensions;

@implementation ProfileDTO

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ @"locationName" : @"location" }];
    return propertyMappings;
}

+ (NSValueTransformer *)followersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[UserSummary class]];
}

+ (NSValueTransformer *)mediumsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Medium class]];
}

+ (NSValueTransformer *)routesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RouteSummary class]];
}

+ (NSValueTransformer *)venuesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VenueSummary class]];
}

+ (NSValueTransformer *)placesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Place class]];
}

+ (NSValueTransformer *)followingJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[UserSummary class]];
}

@end
