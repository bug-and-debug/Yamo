//
//  RoutePlannerPlaceCollectionViewCell.h
//  Yamo
//
//  Created by Peter Su on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionViewCell.h"

@interface RoutePlannerPlaceCollectionViewCell : RoutePlannerCollectionViewCell

- (void)updateLayoutForDeleteMode;

- (void)populateCollectionCellForLocation:(NSString *)location isSource:(BOOL)isSource;

+ (CGFloat)calculateCellHeightForLocation:(NSString *)location;

@end
