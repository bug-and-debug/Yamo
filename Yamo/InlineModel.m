//
//  InlineModel.m
//  Yamo
//
//  Created by Vlad Buhaescu on 17/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "InlineModel.h"
@import MTLModel_LOCExtensions;

@implementation InlineModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[ ]
                                                             dictionary:@{ }];
    return propertyMappings;
}

+ (NSValueTransformer *)artWorksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ArtWork class]];
}

@end
