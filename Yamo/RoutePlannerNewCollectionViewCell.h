//
//  RoutePlannerNewCollectionViewCell.h
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionViewCell.h"

typedef NS_ENUM(NSInteger, RoutePlannerNewCellType) {
    RoutePlannerNewCellTypeAddStart,
    RoutePlannerNewCellTypeAddNew,
    RoutePlannerNewCellTypeAddReturn
};

@interface RoutePlannerNewCollectionViewCell : RoutePlannerCollectionViewCell

- (void)updateAppearanceForType:(RoutePlannerNewCellType)type;

@end
