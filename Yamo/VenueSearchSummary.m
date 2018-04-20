//
//  VenueSearchSummary.m
//  Yamo
//
//  Created by Peter Su on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "VenueSearchSummary.h"
#import "Tag.h"
@import MTLModel_LOCExtensions;
#import "Yamo-Swift.h"
@import UIColor_LOCExtensions;
@import CoreLocation;

@interface VenueSearchSummary ()

@property (nonatomic) BOOL shouldInvalidateDisplayTags;

@property (nonatomic) BOOL shouldInvalidateColors;

@property (nonatomic, strong, readwrite) NSArray<Tag *> *displayTags;

@property (nonatomic, strong) NSArray<UIColor *> *cachedColors;

@end

@implementation VenueSearchSummary
@synthesize identifier;
@synthesize endDate;
@synthesize location;
@synthesize bearing;
@synthesize distance;
@synthesize annotationView;
@synthesize parent;
@synthesize colors;
@synthesize mapRelevance;
@synthesize exhibitionInfoData;

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSDictionary *propertyMappings = [self dictionaryIgnoringParameters:@[  ]
                                                             dictionary:@{ @"latitude": @"lat",
                                                                           @"longitude" : @"lon",
                                                                           @"venueDescription" : @"description" }];
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

#pragma mark - Setters

- (void)setTags:(NSArray<Tag *> *)tags {
    
    NSSet *existingTags = [NSSet setWithArray:_tags];
    NSSet *newTags = [NSSet setWithArray:tags];
    
    if (![existingTags isEqualToSet:newTags]) {
        
        _tags = tags;
        
        self.shouldInvalidateDisplayTags = YES;
        self.shouldInvalidateColors = YES;
    }
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

#pragma mark - ExploreMapAnnotation

- (NSString *)identifier {
    
    return self.uuid.stringValue;
}

- (CLLocationCoordinate2D)location {
    
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}


- (CGFloat)mapRelevance {

    return self.relevance;
}


- (NSArray <UIColor *> *)colors {
    
    if (self.cachedColors.count && !self.shouldInvalidateColors) {
        
        return self.cachedColors;
    }
    
    NSMutableArray *tagColors = [NSMutableArray array];
    
    for (Tag *tag in self.tags) {
    
        if (tag.hexColour.length) {
            
            [tagColors addObject:[[UIColor alloc] initWithHexString:tag.hexColour]];
        }
    }
    
    if (tagColors.count == 0) {
    
        [tagColors addObject:[UIColor colorWithWhite:0.75 alpha:1.0f]];
    }
    
    self.cachedColors = [tagColors copy];
    self.shouldInvalidateColors = NO;
    
    return tagColors;
}


#pragma mark - ExploreMapAnnotation

- (void)updateWithNewerVersionOfAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:[VenueSearchSummary class]]) {
        
        VenueSearchSummary *venueSummary = (VenueSearchSummary *)annotation;
        
        self.tags = venueSummary.tags;
        self.address = venueSummary.address;
        self.name = venueSummary.name;
        self.venueDescription = venueSummary.venueDescription;
        self.venueType = venueSummary.venueType;
        self.mapRelevance = venueSummary.mapRelevance;
        self.venueTypeValue = venueSummary.venueTypeValue;
        self.exhibitionInfoData = venueSummary.exhibitionInfoData;
    }
    
    self.location = annotation.location;
}

@end
