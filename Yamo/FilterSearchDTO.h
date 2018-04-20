//
//  FilterSearchDTO.h
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FilterSearchDTO : MTLModel <MTLJSONSerializing, NSCoding>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double miles;
@property (nonatomic) BOOL mostPopular;

/*
 0: no filter
 1: free [0.00]
 2: cheap [0.01 - 5.00]
 3: medium price [5.01 - 15.00]
 4: expensive [15.01 - 500.00]
 */
@property (nonatomic) NSInteger priceFilter;

@property (nonatomic, copy) NSString *search;
@property (nonatomic, strong) NSArray <NSNumber *> *tagIds;

@end
