//
//  FilterTableViewCell.m
//
//  Created by Dario Langella on 03/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [UIView new];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.y = (45 - CGRectGetHeight(self.accessoryView.frame)) / 2;
    self.accessoryView.frame = accessoryViewFrame;
    
    //Set Accessory Button
    UIImage *image;
    if (self.isExpanded) {
        image = [UIImage imageNamed:@"LegacyIconlightlist_down"];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        image = [UIImage imageNamed:@"Iconlightlist 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1"];
        self.backgroundColor = [UIColor clearColor];
    }
    
    [self.accessoryButton setImage:image forState:UIControlStateNormal];
}

- (IBAction)accessoryButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterTableViewCellDidTappedAccessoryButton:)]) {
        [self.delegate filterTableViewCellDidTappedAccessoryButton:self];
    }
}

@end
