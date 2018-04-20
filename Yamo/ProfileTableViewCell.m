//
//  ProfileTableViewCell.m
//  Yamo
//
//  Created by Dario Langella on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    self.titleLabel.textColor = [UIColor yamoDarkGray];
    self.titleLabel.numberOfLines = 0;
}

- (void)setCellStyle:(ProfileCellStyle)cellStyle {
    _cellStyle = cellStyle;
    
    switch (_cellStyle) {
        case ProfileCellStyleAccessoryButton:
            
            self.addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 28)];
            [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon add friend"] forState:UIControlStateNormal];
            [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"ButtonAddedFriends"] forState:UIControlStateSelected];
            [self.addFriendButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
            
            [self setAccessoryView:self.addFriendButton];
            break;
            
        case ProfileCellStyleDefault:
        default:
            
            [self setAccessoryView:nil];
            
            break;
    }
}

- (void) followUser{
    [self.profileCellDelegate didPressButtonFollow:self];
}

@end
