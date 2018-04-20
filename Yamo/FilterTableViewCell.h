//
//  FilterTableViewCell.h
//
//  Created by Dario Langella on 03/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItem.h"

@class FilterTableViewCell;

@protocol FilterTableViewCellDelegate <NSObject>
- (void)filterTableViewCellDidTappedAccessoryButton:(FilterTableViewCell *)cell;
- (void)filterTableViewCellDidChangedSelection:(FilterTableViewCell *)cell;
@end

@interface FilterTableViewCell : UITableViewCell

@property (weak) id <FilterTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) FilterItem *filterItem;

@end
