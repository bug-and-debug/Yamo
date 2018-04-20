//
//  SearchDTO.h
//  Yamo
//
//  Created by Peter Su on 09/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SearchDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double miles;
@property (nonatomic, copy) NSString *search;

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude
                        distance:(double)distanceMiles
                    searchString:(NSString *)searchString;

@end
