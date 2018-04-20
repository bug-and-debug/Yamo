//
//  Venue.h
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "VenueType.h"
#import "Tag.h"
#import "VenueSummary.h"
#import "VenueSearchSummary.h"


@interface Venue : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray<NSString *> *associatedImageUrls;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *venueDescription;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSNumber *favouriteUsersCount;
@property (nonatomic) BOOL favouriteUsersTapped;
@property (nonatomic, strong) NSDecimalNumber *fee;
@property (nonatomic) double latitude;
@property (nonatomic, strong) NSNumber *likeUsersCount;
@property (nonatomic) BOOL likeUsersTapped;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *openingTimes;
@property (nonatomic, strong) NSArray<NSString *> *spaceImageUrls;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSArray <Tag *> *tags;
@property (nonatomic, strong, readonly) NSArray <Tag *> *displayTags;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic) VenueType venueType;
@property (nonatomic, strong) NSNumber *venueTypeValue;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) VenueSummary *summary;
@property (nonatomic, strong) NSArray<VenueSearchSummary *> *recommended;
@property (nonatomic, strong) NSString *galleryName;

@end
