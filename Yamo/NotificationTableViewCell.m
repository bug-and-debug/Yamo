//
//  FriendNotificationTableViewCell.m
//  Yamo
//
//  Created by Dario Langella on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NSNumber+Yamo.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timestampLabel.font =[UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    self.timestampLabel.textColor = [UIColor yamoBlack];
    
    self.titleLabel.font =[UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:22.0f];
    self.titleLabel.textColor = [UIColor yamoDarkGray];
    self.titleLabel.numberOfLines = 0;
    
    self.imageViewCell.clipsToBounds = YES;
    self.imageViewCell.layer.cornerRadius = self.imageViewCell.bounds.size.height * 0.5f;
}

// This method shows the "Add button in the accessory view"
- (void)setCellStyle:(NotificationCellStyle)cellStyle {
    _cellStyle = cellStyle;
    
    switch (_cellStyle) {
        case NotificationCellStyleAccessoryButton:
            
            self.addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 28)];
            [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"icon add friend"] forState:UIControlStateNormal ];
            [self.addFriendButton setBackgroundImage:[UIImage imageNamed:@"ButtonAddedFriends"] forState:UIControlStateSelected];
            [self.addFriendButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
            
            [self setAccessoryView:self.addFriendButton];
            break;
            
        case NotificationCellStyleDefault:
        default:
            
            [self setAccessoryView:nil];
            
            break;
    }
}

- (void)followUser{
    [self.notificationCellDelegate didPressButtonFollow:self];
}

@end
