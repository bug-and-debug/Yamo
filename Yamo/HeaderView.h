//
//  HeaderView.h
//  Yamo
//
//  Created by Vlad Buhaescu on 28/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Foundation;

typedef NS_ENUM(NSUInteger, HeaderViewStyle) {
    HeaderViewStyleOwnUser,
    HeaderViewStyleOtherProfileUser
};

@interface HeaderView : UIView

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIView *usernameAndLocationContainerView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *friendUnFriendButton;

- (instancetype)initWithStyle:(HeaderViewStyle)headerViewStyle;

@end
