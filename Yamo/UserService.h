//
//  UserService.h
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "OAuthCredential.h"
@import LOCSubscription;

extern NSString * const UserServiceUserTypeChangedNotification;
extern NSString * const UserServiceGetToKnowMeRatingChangedNotification;
extern NSString * const UserServiceShouldPurgeKeychain;
extern NSString * const UserServiceRefreshExhibitionsNotification;
extern NSString * const UserServiceNoInternetConnectionNotification;
extern NSString * const UserServiceShowShareButtonNotification;
extern NSString * const UserServiceHideShareButtonNotification;

typedef void (^CheckSubscriptionStatusCompletionBlock)(User * user, BOOL hasSubscription);

// London as default location
static double const UserServiceDefaultLocationLatitude = 51.5285582;
static double const UserServiceDefaultLocationLongitude = -0.2416798;
static double const UserServiceDefaultSearchMilesRadius = 0;

static NSTimeInterval const UserServiceLocationExpirePeriod = 60 * 5; // 5 minutes

@import CoreLocation;

typedef void (^LocationBlock)(CLLocation *location, NSError *error);

@interface UserService : NSObject <StoreObserverDelegate>

@property (nonatomic, strong, readonly) User *loggedInUser;

@property (nonatomic, strong) OAuthCredential *nonOAuthCredential;

@property (nonatomic, strong, readonly) NSString *nonOAuthCredentialRefreshToken;

+ (instancetype)sharedInstance;

- (void)didLoginWithUser:(User *)user;

- (void)didAuthenticateUsingOAuth:(OAuthCredential *)OAuthCredential;

- (void)didLogout;

- (void)purgeCredentials;

- (NSString *)accessToken;

- (NSString *)refreshToken;

- (void)currentLocationForUser:(LocationBlock)location;

- (void)checkSubscriptionStatus:(CheckSubscriptionStatusCompletionBlock)completionBlock;


@end
