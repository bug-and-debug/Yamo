//
//  ArtWork.m
//  Yamo
//
//  Created by Vlad Buhaescu on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ArtWork.h"
@import MTLModel_LOCExtensions;

@implementation ArtWork

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ @"artWorkDescription" : @"description",
                                                                           @"imageUrlArtWork" : @"imageUrl"
                                                                            }];
    return propertyMappings;
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

@end
