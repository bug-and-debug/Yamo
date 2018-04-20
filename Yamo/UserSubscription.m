//
//  UserSubscription.m
//  Yamo
//
//  Created by Peter Su on 06/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UserSubscription.h"
@import MTLModel_LOCExtensions;

@implementation UserSubscription

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{}];
    return propertyMappings;
}

+ (NSValueTransformer *)typeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(UserSubscriptionTypeUnspecified),
                            @"APPLE" : @(UserSubscriptionTypeGoogle),
                            @"GOOGLE" : @(UserSubscriptionTypeApple)
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(UserSubscriptionTypeUnspecified)
                                                     reverseDefaultValue:@(UserSubscriptionTypeUnspecified)];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)associateduserJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:User.class];
}

@end
