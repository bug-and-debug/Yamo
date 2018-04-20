//
//  FilterDataController.h
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSearchDTO.h"

static NSString const *FilterItemsCacheFileName = @"FilterItemsCache.plist";

@interface FilterDataController : NSObject

@property (nonatomic) BOOL userChangedFilterItems;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)reloadData;

- (void)resetFilter;

- (void)cacheFilterItems;

/**
 *  @return A FilterSearchDTO object filled with popular, priceMin, priceMax and tagIds
 */
- (FilterSearchDTO *)currentFilterSearchDTO;

@end
