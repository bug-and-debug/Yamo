//
//  RouteObject.m
//  Yamo
//
//  Created by Dario Langella on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RouteSummary.h"
@import MTLModel_LOCExtensions;

@implementation RouteSummary

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ }];
    return propertyMappings;
}


+ (NSValueTransformer *)createdJSONTransformer {
    return [self iso8601ToDateTransformer];
}

@end
