//
//  TagGroup.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "TagGroup.h"
@import MTLModel_LOCExtensions;

@implementation TagGroup

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{ }];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self iso8601ToDateTransformer];
}

+ (NSValueTransformer *)tagsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Tag class]];
}

@end
