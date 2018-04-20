//
//  Venue.m
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "Venue.h"
@import MTLModel_LOCExtensions;

@interface Venue ()

@property (nonatomic) BOOL shouldInvalidateDisplayTags;
@property (nonatomic, strong, readwrite) NSArray<Tag *> *displayTags;

@end

@implementation Venue

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{ @"latitude": @"lat",
                                                 @"longitude" : @"lon",
                                                 @"locationName" : @"location",
                                                 @"venueDescription" : @"description" }];
}

+ (NSValueTransformer *)venueTypeJSONTransformer {
    NSDictionary *types = @{
                            @"UNSPECIFIED" : @(VenueTypeUnspecified),
                            @"EXHIBITION" : @(VenueTypeExhibition),
                            @"GALLERY" : @(VenueTypeGallery),
                            @"ARTIST" : @(VenueTypeArtist)
                            };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:types
                                                            defaultValue:@(VenueTypeUnspecified)
                                                     reverseDefaultValue:@(VenueTypeUnspecified)];
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)endDateJSONTransformer {
    
    return [self timestampToDateTransformer];
}

+ (MTLValueTransformer *)timestampToDateTransformer {
    
    // Super's implementation will always return a date even if the source date is nil but in this case
    // we need to know if the date should be nil or not. Therefore we should not call super.
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id date, BOOL *success, NSError *__autoreleasing *error) {
        if ([date isKindOfClass:NSNumber.class]) {
            NSNumber *dateNumber = (NSNumber *)date;
            return [NSDate dateWithTimeIntervalSince1970:([dateNumber doubleValue] / 1000)];
        }
        
        return nil;
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000];
    }];
}


+ (NSValueTransformer *)feeJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:NSDecimalNumber.class]) {
            return value;
        } else if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *valueNumber = (NSNumber *)value;
            return [NSDecimalNumber decimalNumberWithDecimal:valueNumber.decimalValue];
        } else {
            return nil;
        }
    }];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)tagsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Tag class]];
}

+ (NSValueTransformer *)recommendedJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VenueSearchSummary class]];
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
