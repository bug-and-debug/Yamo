//
//  User.h
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>

typedef NS_ENUM(NSInteger, UserRoleType) {
    UserRoleTypeUnspecified,
    UserRoleTypeStandard,
    UserRoleTypeAdmin,
    UserRoleTypeGuest
};

@interface User : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *email;
@property (nonatomic) BOOL enabled;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) BOOL followersTapped;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic) float latitude;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic) float longitude;
@property (nonatomic) BOOL nickNameEnabled;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic) BOOL ready;
@property (nonatomic) NSInteger reportsCount;
@property (nonatomic) BOOL reportsTapped;
@property (nonatomic) BOOL signUpCompleted;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic) UserRoleType userType;
@property (nonatomic, strong) NSNumber *userTypeValue;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic) BOOL visible;

@end
