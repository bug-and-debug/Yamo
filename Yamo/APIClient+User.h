//
//  APIClient+User.h
//  Yamo
//
//  Created by Mo Moosa on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (User)

- (void)userGetUserWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

//Follow/Unfollow Users API REQUESTS

- (void)followUserWithUserID:(NSNumber * _Nonnull)userID
             andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)unfollowUserWithUserID:(NSNumber * _Nonnull)userID
               andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;


//Notification API REQUESTS

- (void)getNotificationListWithFromValue:(long long)fromValue
                                   older:(BOOL)wantOlder
                         andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                            failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock ;

- (void)markNotificationID:(NSNumber * _Nonnull)notificationID
           andSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)checkUnreadNotificationWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

// IAP Upgrade

- (void)userGuestSignupWithFirstName:(NSString * _Nonnull)firstName
                            lastName:(NSString * _Nonnull)lastName
                               email:(NSString * _Nonnull)emailAddress
                            password:(NSString * _Nonnull)password
                        imageContent:(NSString * _Nullable)imageContent
                          beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                           afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                        successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                        failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)userConnectWithFacebookWithFacebookToken:(NSString * _Nonnull)facebookToken
                                      facebookId:(NSString * _Nonnull)facebookId
                                           email:(NSString * _Nonnull)email
                                      beforeLoad:(LOCApiClientBeforeLoadBlockType _Nullable)beforeLoad
                                       afterLoad:(LOCApiClientAfterLoadBlockType _Nullable)afterLoad
                                    successBlock:(LOCApiClientSuccessSingleBlockType _Nullable)successBlock
                                    failureBlock:(LOCApiClientErrorWithContextBlockType _Nullable)failureBlock;

- (void)userUpgradeUserWithReceipt:(NSString * _Nonnull)receipt
                   andSuccessBlock:(LOCApiClientSuccessSingleBlockType _Nullable)successBlock
                      failureBlock:(LOCApiClientErrorWithContextBlockType _Nullable)failureBlock;

@end
