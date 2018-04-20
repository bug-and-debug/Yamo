//
//  ProfileTableViewCell.h
//  Yamo
//
//  Created by Dario Langella on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ProfileCellStyle) {
    
    // Default
    // AccessoryButton
    ProfileCellStyleDefault,
    ProfileCellStyleAccessoryButton,
};

@class ProfileTableViewCell;

@protocol ProfileTableViewCellDelegate <NSObject>

-(void) didPressButtonFollow:(ProfileTableViewCell *)cell;

@end

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) UIButton *addFriendButton;
@property (nonatomic) ProfileCellStyle cellStyle;
@property (nonatomic,assign) id <ProfileTableViewCellDelegate> profileCellDelegate;

@end
