//
//  PlaceTableViewCell.h
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const PlaceTableViewCellHeight = 45.0f;

@interface PlaceTableViewCell : UITableViewCell

- (void)populateCellWithData:(NSString *)data
                  isSelected:(BOOL)isSelected;

@end
