//
//  UserSubscription.h
//  Yamo
//
//  Created by Peter Su on 06/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "User.h"

typedef NS_ENUM(NSInteger, UserSubscriptionType) {
    UserSubscriptionTypeUnspecified,
    UserSubscriptionTypeApple,
    UserSubscriptionTypeGoogle
};

@interface UserSubscription : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) User *associatedUser;
@property (nonatomic) BOOL autoRenewing;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *developerPayload;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) BOOL expired;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *packageName;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic) NSInteger purchaseState;
@property (nonatomic) NSInteger purchaseTime;
@property (nonatomic, strong) NSString *purchaseToken;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) UserSubscriptionType type;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *uuid;

@end
