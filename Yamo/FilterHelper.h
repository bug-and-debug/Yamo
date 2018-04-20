//
//  FilterHelper.h
//  Yamo
//
//  Created by Peter Su on 27/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterSearchDTO.h"

static NSString const *FilterSearchCacheFileName = @"FilterSearchDTOCache.plist";

@interface FilterHelper : NSObject

+ (void)cacheFilterSearchDTO:(FilterSearchDTO *)dto;

+ (FilterSearchDTO *)cachedFilterSearchDTO;

@end
