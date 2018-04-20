//
//  User.m
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "User.h"
@import MTLModel_LOCExtensions;

@implementation User

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ @"latitude" : @"lat",
                                                                           @"longitude" : @"lon",
                                                                           @"locationName" : @"location" }];
    return propertyMappings;
}

+ (NSValueTransformer *)userTypeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(UserRoleTypeUnspecified),
                            @"USER" : @(UserRoleTypeStandard),
                            @"ADMIN" : @(UserRoleTypeAdmin),
                            @"GUEST" : @(UserRoleTypeGuest)
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(UserRoleTypeUnspecified)
                                                     reverseDefaultValue:@(UserRoleTypeUnspecified)];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)dateOfBirthJSONTransformer {
    return [self iso8601ToDateTransformer];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return NSStringFromClass([User class]);
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObjects:NSStringFromSelector(@selector(uuid)), nil];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ }];
    return propertyMappings;
}

@end
