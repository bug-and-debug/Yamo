//
//  FilterSwitchCell.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterSwitchTableViewCell.h"

const CGFloat FilterSwitchTableViewCellExpandedHeight = 105.0f;
const CGFloat FilterSwitchTableViewCellDefaultHeight = 45.0f;

@interface FilterSwitchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *switchTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@end

@implementation FilterSwitchTableViewCell

- (void)setFilterItem:(FilterItem *)filterItem {
    [super setFilterItem:filterItem];
    [self configureView];
}

- (void)configureView {
    
    self.switchTitleLabel.text = self.filterItem.filterDescription;
    self.switchControl.on = [self.filterItem.filterSelection.firstObject boolValue];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
    self.filterItem.filterSelection = @[@(sender.on)];
    
    if ([self.delegate respondsToSelector:@selector(filterTableViewCellDidChangedSelection:)]) {
        [self.delegate filterTableViewCellDidChangedSelection:self];
    }
}

@end
