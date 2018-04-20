//
//  Notification.h
//  Yamo
//
//  Created by Dario Langella on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeCurrentLocationSuggestion,
    NotificationTypeGetToKnowMe,
    NotificationTypeExibition,
    NotificationTypeFacebookFriend,
    NotificationTypeUnspecified,
};

@interface Notification : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *associatedUserProfileImageUrl;
@property (nonatomic, strong) NSString *userText;
@property (nonatomic, strong)  NSNumber *associatedVenue;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic) BOOL notificationRead;
@property (nonatomic) NotificationType type;
@property (nonatomic, strong)  NSNumber *typeValue;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong)  NSNumber *uuid;
@property (nonatomic, strong)  NSNumber *associatedUser;
@property (nonatomic, strong) NSString *venueText;
@property (nonatomic) BOOL following;
@property (nonatomic, strong) NSString *altText;

+ (NSString *)displayTextForNotification:(Notification *)notification;

@end
