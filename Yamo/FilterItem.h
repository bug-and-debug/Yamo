//
//  FilterItem.h
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FilterItemType) {
    FilterItemTypeSwitch,
    FilterItemTypeTags,
    FilterItemTypeSlider
};

@interface FilterItem : NSObject <NSCoding>

@property (nonatomic) FilterItemType type;

@property (nonatomic, strong) NSString *filterName;

@property (nonatomic, strong) NSString *filterDescription;

/**
 *  This is only for the Tags type use, it will store the
 *  fetched tag groups uuid.
 */
@property (nonatomic, strong) NSNumber *sourceId;

/**
 *  It depends on what the type being specified,
 *  - Switch type: the options should be @YES and @NO.
 *  - Tags: the options should be NSNumber objects which represents the tag uuid.
 *  - Slider: the options should be series of NSNumber objects.
 */
@property (nonatomic, strong) NSArray *filterOptions;

/**
 *  For display usage, now only the Tag type will use this value.
 */
@property (nonatomic, strong) NSArray <NSString *> *filterOptionsDisplayNames;

/**
 *  The user selection from the `filterOptions` array.
 */
@property (nonatomic, strong) NSArray *filterSelection;

@property (nonatomic) BOOL multipleSelection;

@end
