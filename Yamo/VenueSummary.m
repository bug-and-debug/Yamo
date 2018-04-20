//
//  VenuesObject.m
//  Yamo
//
//  Created by Dario Langella on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "VenueSummary.h"
@import MTLModel_LOCExtensions;
#import "Tag.h"

@interface VenueSummary ()

@property (nonatomic) BOOL shouldInvalidateDisplayTags;
@property (nonatomic, strong, readwrite) NSArray<Tag *> *displayTags;

@end

@implementation VenueSummary

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[  ]
                                                             dictionary:@{ }];
    return propertyMappings;
}

+ (NSValueTransformer *)venueTypeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(VenueTypeUnspecified),
                            @"EXHIBITION" : @(VenueTypeExhibition),
                            @"GALLERY" : @(VenueTypeGallery),
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(VenueTypeUnspecified)
                                                     reverseDefaultValue:@(VenueTypeUnspecified)];
}


+ (NSValueTransformer *)tagsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:Tag.class];
}

#pragma mark - Getters

- (NSArray<Tag *> *)displayTags {
    
    if (!_displayTags || self.shouldInvalidateDisplayTags == YES) {
        
        NSMutableArray *tagsToDisplay = [NSMutableArray array];
        
        for (Tag *tag in self.tags) {
            
            if (tag.hexColour.length && tag.name.length) {
                
                [tagsToDisplay addObject:tag];
            }
        }
        
        _displayTags = tagsToDisplay;
        
        self.shouldInvalidateDisplayTags = NO;
    }
    
    return [_displayTags copy];
}


@end
