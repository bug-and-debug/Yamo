//
//  ProfileDTO.h
//  Yamo
//
//  Created by Hungju Lu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "UserSummary.h"
#import "Medium.h"
#import "RouteSummary.h"
#import "VenueSummary.h"
#import "Place.h"

@interface ProfileDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic) BOOL nicknameEnabled;
@property (nonatomic) BOOL ownProfile;
@property (nonatomic) BOOL userFollowing;
@property (nonatomic) BOOL reported;
@property (nonatomic) BOOL visible;
@property (nonatomic, strong) NSArray <Medium *> *mediums;
@property (nonatomic, strong) NSArray <RouteSummary *> *routes;
@property (nonatomic, strong) NSArray <VenueSummary *> *venues;
@property (nonatomic, strong) NSArray <Place *> *places;
@property (nonatomic, strong) NSArray <UserSummary *> *following;
@property (nonatomic, strong) NSArray <UserSummary *> *followers;

@end
