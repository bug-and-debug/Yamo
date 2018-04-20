//
//  SideMenuTableViewCell.m
//  Yamo
//
//  Created by Dario Langella on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SideMenuTableViewCell.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

@implementation SideMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:17.0f];
    self.detailLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:17.0f];
    self.detailLabel.layer.masksToBounds = YES;
    self.detailLabel.layer.cornerRadius = self.detailLabel.frame.size.width * 0.5f;
    self.detailLabel.textColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setActive:(BOOL)active {
    _active = active;
    
    if (_active) {
        
        self.backgroundColor = self.activeColor;
    }
    else {
        
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
