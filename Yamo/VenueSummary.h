//
//  VenuesObject.h
//  Yamo
//
//  Created by Dario Langella on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueType.h"
#import <Mantle/Mantle.h>
@class Tag;

@interface VenueSummary :  MTLModel <MTLJSONSerializing>

@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nonnull) NSString *locationName;
@property (nonatomic) VenueType venueType;
@property (nonatomic) BOOL popularVenue;
@property (nonatomic, strong)  NSNumber * _Nonnull venueTypeValue;
@property (nonatomic, strong)  NSNumber * _Nonnull uuid;
@property (nonatomic)  double latitude;
@property (nonatomic)  double longitude;
@property (nonatomic, strong) NSArray <Tag *> * _Nullable tags;
@property (nonatomic, strong, readonly) NSArray<Tag *> * _Nullable displayTags;

@end
