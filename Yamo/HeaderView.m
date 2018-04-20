//
//  HeaderView.m
//  Yamo
//
//  Created by Vlad Buhaescu on 28/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "HeaderView.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"

NSString * const iconFollowFriend = @"icon add friend";
NSString * const iconUnFollowFriend = @"ButtonAddedFriends";

static const CGFloat trailingConstant = 15.0f;
static const CGFloat trailingConstantWithAddFriend = 80.0f;

@interface HeaderView()
@property HeaderViewStyle headerViewStyle;
@end

@implementation HeaderView

- (instancetype)initWithStyle:(HeaderViewStyle)headerViewStyle {
	self = [super init];
	if (self) {
        self.headerViewStyle = headerViewStyle;
        [self initView];
	}
	return self;
}

- (void)initView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.profileImageView = [[UIImageView alloc] init];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.profileImageView.layer.cornerRadius = 27.5f;
    self.profileImageView.layer.masksToBounds = YES;
    [self addSubview:self.profileImageView];
    [self addConstraints:[self setConstraintsForProfileImageView]];
    
    self.usernameAndLocationContainerView = [[UIView alloc] init];
    self.usernameAndLocationContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.usernameAndLocationContainerView];
    [self addConstraints:[self setConstraintsForContainerView]];
    
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameLabel.text = @"";
    self.usernameLabel.textColor = [UIColor yamoBlack];
    [self.usernameLabel setFont:[UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:22.0f]];
    [self.usernameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.usernameAndLocationContainerView addSubview:self.usernameLabel];
    [self addConstraints:[self setConstraintsForUsernameLabel]];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationLabel.text = @"";
    self.locationLabel.textColor = [UIColor yamoDarkGray];
    [self.locationLabel setFont:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f]];
    [self.locationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.usernameAndLocationContainerView addSubview:self.locationLabel];
    [self addConstraints:[self setConstraintsForLocationLabel]];
    
    if (self.headerViewStyle == HeaderViewStyleOtherProfileUser) {
        
        self.friendUnFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.friendUnFriendButton setBackgroundImage:[UIImage imageNamed:iconFollowFriend] forState:UIControlStateNormal];
        self.friendUnFriendButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.friendUnFriendButton];
        [self addConstraints:[self setConstraintsForFollowUnfollowButton]];
    }
}

#pragma mark - Set Constraints

- (NSArray *) setConstraintsForUsernameLabel{
    
    return @[
             [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                           constant:-10],
             [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeLeading
                                         multiplier:1.0
                                           constant:10],
             [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:-20],
             [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0
                                           constant:25]
             
             ];
    
}
- (NSArray *) setConstraintsForLocationLabel{
    
    return @[
             [NSLayoutConstraint constraintWithItem:self.locationLabel
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameLabel
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                           constant:3],
             [NSLayoutConstraint constraintWithItem:self.locationLabel
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeLeading
                                         multiplier:1.0
                                           constant:10],
             [NSLayoutConstraint constraintWithItem:self.locationLabel
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:-20],
             [NSLayoutConstraint constraintWithItem:self.locationLabel
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0
                                           constant:15]
             
             ];
}


- (NSArray *) setConstraintsForProfileImageView{
    
    return @[
      [NSLayoutConstraint constraintWithItem:self.profileImageView
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0],
      [NSLayoutConstraint constraintWithItem:self.profileImageView
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1.0
                                    constant:25],
      [NSLayoutConstraint constraintWithItem:self.profileImageView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1.0
                                    constant:55],
      [NSLayoutConstraint constraintWithItem:self.profileImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:1.0
                                    constant:55],
      ];
}

- (NSArray *) setConstraintsForContainerView {
    
    CGFloat labelsContainerFollowButtonConstraint = _headerViewStyle == HeaderViewStyleOtherProfileUser ? trailingConstantWithAddFriend : trailingConstant;

    return @[
             [NSLayoutConstraint constraintWithItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.profileImageView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:15],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:labelsContainerFollowButtonConstraint],
             [NSLayoutConstraint constraintWithItem:self.usernameAndLocationContainerView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0
                                           constant:80]
             ];
}


- (NSArray *) setConstraintsForFollowUnfollowButton {
    
    return @[
             [NSLayoutConstraint constraintWithItem:self.friendUnFriendButton
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.friendUnFriendButton
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0
                                           constant:15],
             [NSLayoutConstraint constraintWithItem:self.friendUnFriendButton
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0
                                           constant:30],
             [NSLayoutConstraint constraintWithItem:self.friendUnFriendButton
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1.0
                                           constant:45]
             ];
}
@end
