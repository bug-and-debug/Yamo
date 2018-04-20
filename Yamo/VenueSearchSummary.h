//
//  VenueSearchSummary.h
//  Yamo
//
//  Created by Peter Su on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueType.h"
#import <Mantle/Mantle.h>
#import "ExploreMapView.h"

@class Tag;
@class Venue;

@interface VenueSearchSummary :  MTLModel <MTLJSONSerializing, ExploreMapAnnotation>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *venueDescription;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) CGFloat distance;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) double relevance;
@property (nonatomic) BOOL relevant;
@property (nonatomic, strong) NSArray<Tag *> *tags;
@property (nonatomic, strong, readonly) NSArray<Tag *> *displayTags;
@property (nonatomic, strong) Venue *exhibitionInfoData;

@property (nonatomic) VenueType venueType;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *venueTypeValue;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *galleryName;

- (void)updateWithNewerVersionOfAnnotation:(id<ExploreMapAnnotation>)annotation;

@end
