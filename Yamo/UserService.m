//
//  UserService.m
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "UserService.h"
#import "LOCKeychainManager.h"
#import "CoreDataStore.h"
#import "LOCAppDefinitions.h"
#import "APIClient+User.h"
@import StoreKit;

NSString * const UserServiceUserTypeChangedNotification = @"UserServiceUserTypeChangedNotification";
NSString * const UserServiceGetToKnowMeRatingChangedNotification = @"UserServiceGetToKnowMeRatingChangedNotification";
NSString * const UserServiceShouldPurgeKeychain = @"UserServiceShouldPurgeKeychain";
NSString * const UserServiceRefreshExhibitionsNotification = @"UserServiceRefreshExhibitionsNotification";
NSString * const UserServiceNoInternetConnectionNotification = @"UserServiceNoInternetConnectionNotification";
NSString * const UserServiceShowShareButtonNotification = @"UserServiceShowShareButtonNotification";
NSString * const UserServiceHideShareButtonNotification = @"UserServiceHideShareButtonNotification";

@import LOCPermissions_Swift;

//#define kKeyChain_No_OAuth_Token  @"KEYCHAIN_USER_NO_OAUTH_TOKEN"
#define kKeyChain_User_OAuth_token  @"KEYCHAIN_USER_OAUTH_TOKEN"
#define kKeyChain_User_OAuth_refresh_token  @"KEYCHAIN_USER_OAUTH_REFRESH_TOKEN"

@interface UserService () <CLLocationManagerDelegate>

@property (nonatomic, strong, readwrite) User *loggedInUser;

@property (nonatomic, copy) LocationBlock locationBlock;

@end

@implementation UserService

+ (instancetype)sharedInstance {
    static UserService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UserService new];
    });
    
    return sharedInstance;
}

#pragma mark - Accessors

- (void)didLoginWithUser:(User *)user {
    
    // Store it in core data
    if (user && user.uuid) {
        
        NSManagedObjectContext *bmoc = [CoreDataStore sharedInstance].backgroundManagedObjectContext;
        
        // Map the Mantle model to Core Data,
        // MTLManagedObjectAdapter will handle the duplication based on the unique key we specified
        [MTLManagedObjectAdapter managedObjectFromModel:user insertingIntoContext:bmoc error:NULL];
        
        [[CoreDataStore sharedInstance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
            NSLog(@"logged in user persisted");
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kUserDefaultsCachedUserLastUpdated];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        User *previousLoggedInUser = self.loggedInUser;
        self.loggedInUser = user;
        
        // check if user status changed and post notification
        BOOL sameUserButChangedUserType = previousLoggedInUser && previousLoggedInUser.userType != user.userType;
        BOOL loggedInAsDifferentUser = [previousLoggedInUser.uuid compare:user.uuid] != NSOrderedSame;
        
        if (!previousLoggedInUser || loggedInAsDifferentUser || sameUserButChangedUserType) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserServiceUserTypeChangedNotification object:self];
        }
    }
    
    // Cache the profile picture
    if (user.profileImageUrl) {
        
        [[NSUserDefaults standardUserDefaults] setObject:user.profileImageUrl forKey:kUserDefaultsOwnUserProfilePictureURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didAuthenticateUsingOAuth:(OAuthCredential *)OAuthCredential {
    
    [LOCKeychainManager setPassword:OAuthCredential.accessToken forKey:kKeyChain_User_OAuth_token];
    [LOCKeychainManager setPassword:OAuthCredential.refreshToken forKey:kKeyChain_User_OAuth_refresh_token];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UserServiceShouldPurgeKeychain];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didLogout {
    
    // Remove from core data
    if (self.loggedInUser) {
        
        NSManagedObjectContext *bmoc = [CoreDataStore sharedInstance].backgroundManagedObjectContext;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), self.loggedInUser.uuid];
        
        __block NSManagedObject *user;
        [[CoreDataStore sharedInstance] fetchEntriesForEntityName:NSStringFromClass([User class])
                                                    withPredicate:predicate
                                                  sortDescriptors:nil
                                             managedObjectContext:bmoc
                                                     asynchronous:NO
                                                  completionBlock:^(NSArray *results) {
                                                      user = [results firstObject];
                                                  }];
        
        if (user) {
            
            [[CoreDataStore sharedInstance] deleteEntity:user inManagedObjectContext:bmoc];
            [[CoreDataStore sharedInstance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
                NSLog(@"logged in user removed");
            }];
        }
        
        self.loggedInUser = nil;
    }
    
    // Remove observers of changes on the internal database
    [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataStorePurgeUserDataNotification object:self];
    
    [self purgeCredentials];
}

- (void)purgeCredentials {
    
    [LOCKeychainManager removePasswordForKey:kKeyChain_User_OAuth_token];
    [LOCKeychainManager removePasswordForKey:kKeyChain_User_OAuth_refresh_token];
}

- (NSString *)accessToken {
    
    NSString *token = [LOCKeychainManager passwordForKey:kKeyChain_User_OAuth_token];
    
    return token;
}

- (NSString *)refreshToken {
    
    NSString *refreshToken = [LOCKeychainManager passwordForKey:kKeyChain_User_OAuth_refresh_token];
    
    return refreshToken;
}

- (void)currentLocationForUser:(LocationBlock)location {
    
    // Fetch user
    if ([[PermissionRequestLocation sharedInstance] currentStatus] == PermissionRequestStatusSystemPromptAllowed) {
        
        self.locationBlock = location;
        
        CLLocationManager *manager = [CLLocationManager new];
        manager.delegate = self;
        
        if (manager.location) {
            
            NSDate *now = [NSDate date];
            NSTimeInterval secondsSince = [manager.location.timestamp timeIntervalSinceDate:now];
            
            if (secondsSince < UserServiceLocationExpirePeriod) {
            
                if (self.locationBlock) {
                    self.locationBlock(manager.location, nil);
                    self.locationBlock = nil;
                }
            }
            else {
                
                [manager stopUpdatingLocation];
                [manager startUpdatingLocation];
            }
            
        } else {
            
            [manager startUpdatingLocation];
        }
        
    } else {
        
        NSError *permissionDeniedError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                                    code:0
                                                                userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Permission denied, using default location", nil)}];
        
        
        CLLocation *defaultLocation = [[CLLocation alloc] initWithLatitude:UserServiceDefaultLocationLatitude longitude:UserServiceDefaultLocationLongitude];
        
        location(defaultLocation, permissionDeniedError);
    }
}

- (void)checkSubscriptionStatus:(CheckSubscriptionStatusCompletionBlock)completionBlock {
    
    NSDate *updated = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCachedUserLastUpdated];
    
    static const NSTimeInterval secondsIn1Day = 86400;
    
    NSDate *now = [NSDate new];
    NSTimeInterval secondsPassedSinceNow = now.timeIntervalSinceReferenceDate;
    NSTimeInterval seocondsPassedSinceUpdate = updated.timeIntervalSinceReferenceDate;
    NSTimeInterval seoncdsPassedSinceUpdate = secondsPassedSinceNow - seocondsPassedSinceUpdate;
    
    if (self.loggedInUser && updated && seoncdsPassedSinceUpdate < secondsIn1Day) {
        
        completionBlock(self.loggedInUser, (self.loggedInUser.userType == UserRoleTypeStandard));
        
        return;
    }
    
    // It is more than 24 hours since we asked server about subscription
    
    if ([UserService sharedInstance].loggedInUser) {
        
        [[APIClient sharedInstance] userGetUserWithSuccessBlock:^(User *element) {
            
            [self didLoginWithUser:element];
            
            completionBlock(element, (element.userType == UserRoleTypeStandard));
            
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            
            completionBlock(nil, false);
        }];
    } else {
        completionBlock(nil, false);
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (self.locationBlock) {
        self.locationBlock([locations firstObject], nil);
    }
    
    [manager stopUpdatingLocation];
    self.locationBlock = nil;
}

#pragma mark - StoreObserverDelegate

- (void)storeObserverShouldValidateReceipt:(NSString * _Nonnull)receipt
                            forTransaction:(SKPaymentTransaction * _Nonnull)transaction
                           completionBlock:(void (^)())completionBlock
                              failureBlock:(void (^)(NSInteger errorCode, NSString *errorMessage))failureBlock {
    
    NSLog(@"Receipt: %@\nTransaction: %@", receipt, transaction);
    
    if (![UserService sharedInstance].loggedInUser) {
        failureBlock(-1, @"Endpoint not yet integrated");
        // Endpoint
    } else {
        
        [[APIClient sharedInstance] userUpgradeUserWithReceipt:receipt andSuccessBlock:^(id  _Nullable element) {
            
            completionBlock();
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            failureBlock(statusCode, context);
        }];
    }
}

@end
