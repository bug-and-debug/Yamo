//
//  FriendNotificationTableViewCell.h
//  Yamo
//
//  Created by Dario Langella on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

typedef NS_ENUM(NSUInteger, NotificationCellStyle) {
    
    // Default
    // AccessoryButton
    NotificationCellStyleDefault,
    NotificationCellStyleAccessoryButton,
};

@class NotificationTableViewCell;

@protocol NotificationTableViewCellDelegate <NSObject>

- (void) didPressButtonFollow:(NotificationTableViewCell *)cell;

@end

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCell;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (nonatomic) UIButton *addFriendButton;
@property (nonatomic) NotificationCellStyle cellStyle;
@property (nonatomic,assign) id <NotificationTableViewCellDelegate> notificationCellDelegate;


- (void) followUser;

@end
