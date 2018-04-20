//
//  Tag.m
//  Yamo
//
//  Created by Hungju Lu on 10/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "Tag.h"
@import MTLModel_LOCExtensions;

@implementation Tag

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{ }];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

@end
