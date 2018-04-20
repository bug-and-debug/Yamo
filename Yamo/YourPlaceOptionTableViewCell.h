//
//  YourPlaceOptionTableViewCell.h
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YourPlaceOption;

@interface YourPlaceOptionTableViewCell : UITableViewCell

- (void)populateCellForData:(YourPlaceOption *)option;

@end
