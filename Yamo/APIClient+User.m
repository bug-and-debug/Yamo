//
//  APIClient+User.m
//  Yamo
//
//  Created by Mo Moosa on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient+User.h"
#import "Notification.h"
#import "UserSubscription.h"
#import "UserService.h"
#import "SignUpDTO.h"
#import "LOCAppDefinitions.h"

static NSString * const NotificationListPath = @"/user/notification/list?%@";
static NSString * const NotificationMarkPath = @"/user/notification/%@/mark";
static NSString * const NotificationBadgePath = @"/user/counters";

static NSString * const FollowUserPath = @"/user/%@/follow";
static NSString * const UnfollowUserPath = @"/user/%@/un-follow";

static NSString * const UserPathGetUser = @"user";

static NSString * const UserPathGuestSignUp = @"user/sign-up/guest";
static NSString * const UserPathGuestConnectFacebook = @"user/connect/facebook";
static NSString * const UserPathUpgradeUser = @"user/upgrade/apple";

@implementation APIClient (User)

- (void)userGetUserWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    NSLog(@"Get user");
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:UserPathGetUser
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseOwnUserResponse:response successBlock:successBlock failureBlock:failureBlock];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
    } failureBlock:failureBlock];
}

#pragma mark - Notification API requests

- (void)getNotificationListWithFromValue:(long long)fromValue
                                   older:(BOOL)wantOlder
                         andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                            failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *notificationDTO = [NSString stringWithFormat:@"from=%llu&older=%@", fromValue, wantOlder ? @"true" : @"false"];
        
        NSString *URLPath = [NSString stringWithFormat:NotificationListPath, notificationDTO];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:URLPath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self parseNotificationResponse:response
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock ];
                                    
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

- (void)markNotificationID:(NSNumber * _Nonnull)notificationID
           andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *URLPath = [NSString stringWithFormat:NotificationMarkPath, notificationID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:URLPath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    successBlock(response);
                                    
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

- (void)checkUnreadNotificationWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:NotificationBadgePath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    successBlock(response);
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}


- (void)parseNotificationResponse:(NSArray *)response
                     successBlock:(LOCApiClientSuccessArrayBlockType)successBlock
                     failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSArray class]]) {
        NSError *parseError = nil;
        NSArray *arrayOfNotification = [MTLJSONAdapter modelsOfClass:[Notification class] fromJSONArray:response error:&parseError];
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(arrayOfNotification);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
        
        
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a Notification", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}


#pragma mark - Follow/Unfollow API requests

- (void)followUserWithUserID:(NSNumber * _Nonnull)userID
           andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *URLPath = [NSString stringWithFormat:FollowUserPath, userID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:URLPath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    successBlock(response);
                                    
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}


- (void)unfollowUserWithUserID:(NSNumber * _Nonnull)userID
             andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *URLPath = [NSString stringWithFormat:UnfollowUserPath, userID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:URLPath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    successBlock(response);
                                    
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

#pragma mark - IAP Upgrade

- (void)userGuestSignupWithFirstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                               email:(NSString *)emailAddress
                            password:(NSString *)password
                        imageContent:(NSString *)imageContent
                          beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                           afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                        successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                        failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        SignUpDTO *signupDTO = [[SignUpDTO alloc] initWithFirstName:firstName
                                                           lastName:lastName
                                                              email:emailAddress
                                                           password:password
                                                       imageContent:imageContent];
        
        NSDictionary *signupDTOMantle = [MTLJSONAdapter JSONDictionaryFromModel:signupDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:UserPathGuestSignUp
                             parameters:signupDTOMantle
                             beforeLoad:beforeLoad
                              afterLoad:afterLoad
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self setupAuthenticatedForEmailAddress:emailAddress
                                                                   password:password
                                                        sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                                                            
                                                            if (successBlock) {
                                                                successBlock(response);
                                                            }
                                                            
                                                        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                                            NSLog(@"signup error : %@ ( %@ )", error.localizedDescription,error);
                                                        }];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    NSLog(@"signup error : %@ ( %@ )", error.localizedDescription,error);
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)userConnectWithFacebookWithFacebookToken:(NSString *)facebookToken
                                      facebookId:(NSString *)facebookId
                                           email:(NSString *)email
                                      beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                       afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                    successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                    failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userShouldLoginWithFacebookToken:facebookToken
                              emailAddress:email
                                beforeLoad:beforeLoad
                                 afterLoad:afterLoad
                              successBlock:^(id  _Nullable element) {
                                  
                                  NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];
                                  
                                  [self setupAuthenticatedForEmailAddress:email
                                                                 password:tempPassword
                                                      sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                                                          
                                                          if (successBlock) {
                                                              successBlock(element);
                                                          }
                                                          
                                                      } failureBlock:failureBlock];
                                  
                              } failureBlock:failureBlock];
}

- (void)userShouldLoginWithFacebookToken:(NSString *)facebookToken
                            emailAddress:(NSString *)emailAddress
                              beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                               afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                            successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                            failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *stringDTO = @{ @"value" : facebookToken };
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:UserPathGuestConnectFacebook
                             parameters:stringDTO
                             beforeLoad:beforeLoad
                              afterLoad:afterLoad
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseOwnUserResponse:response
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

- (void)userUpgradeUserWithReceipt:(NSString * _Nonnull)receipt
                   andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                      failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *parameters = @{ @"receiptData" : receipt};
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:UserPathUpgradeUser
                             parameters:parameters
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                       
                                    [APIClient parseUserSubscriptionResponse:response successBlock:^(id  _Nullable element) {
                                        
                                        if ([element isKindOfClass:UserSubscription.class]) {
                                            
                                            UserSubscription *subscriptionObject = (UserSubscription *)element;
                                            [[UserService sharedInstance] didLoginWithUser:subscriptionObject.associatedUser];
                                            
                                            if (successBlock)
                                                successBlock(subscriptionObject);
                                            
                                        } else {
                                            NSError *parseError = nil;
                                            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
                                        }
                                    } failureBlock:failureBlock];
                                    
                                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       
                                       [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                   }];
    } failureBlock:failureBlock];
}

#pragma mark - Parsers

+ (void)parseUserSubscriptionResponse:(NSDictionary *)response
             successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        UserSubscription *subscribedUser = [MTLJSONAdapter modelOfClass:[UserSubscription class] fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(subscribedUser);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a UserSubscription", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}


@end
