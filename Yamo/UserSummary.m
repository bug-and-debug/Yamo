//
//  UserSummary.m
//  Yamo
//
//  Created by Dario Langella on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UserSummary.h"
@import MTLModel_LOCExtensions;

@implementation UserSummary

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ }];
    return propertyMappings;
}
@end
