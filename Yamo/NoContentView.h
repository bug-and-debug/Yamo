//
//  NoContentView.h
//  Yamo
//
//  Created by Peter Su on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NoContentViewType) {
    NoContentViewTypeNotifications,
    NoContentViewTypeOtherProfilePrivate,
    NoContentViewTypeOtherProfileNoContentForGetToKnowMe,
    NoContentViewTypeOtherProfileNoContentForVenues,
    NoContentViewTypeOtherProfileNoContentForFriendsFollowing,
    NoContentViewTypeOtherProfileNoContentForFriendsFollowers,
    NoContentViewTypeOtherProfileNoContentForRoutes,
    NoContentViewTypeNotSpecified
};

@interface NoContentView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic) NoContentViewType type;

- (instancetype)initWithWithNoContentType:(NoContentViewType)type;

- (void)setAttributedText:(NSAttributedString *)text;

@end
