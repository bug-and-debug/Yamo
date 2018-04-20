//
//  FilterTagsCell.h
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewCell.h"

static NSString *FilterTagsTableViewCellIdentifier = @"filterTagsTableViewCell";

extern const CGFloat FilterTagsTableViewCellExpandedHeight;
extern const CGFloat FilterTagsTableViewCellDefaultHeight;

@interface FilterTagsTableViewCell : FilterTableViewCell

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource>)dataSourceDelegate forIndex:(NSInteger)index;
- (CGFloat)heightForCell;

@end
