//
//  APIClient.h
//  Yamo
//
//  Created by Mo Moosa on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import LOCManagers;

NS_ASSUME_NONNULL_BEGIN

static NSString * _Nonnull const API_ERROR_DOMAIN = @"API_ERROR_DOMAIN";
static NSString * const API_PARSE_RESPONSE_ERROR_DOMAIN = @"API_ERROR_DOMAIN";
static NSInteger const API_PARSE_RESPONSE_ERROR = -100;

@interface APIClient : LOCApiClient

- (void)nonOAuthUserSessionManagerWithBlock:(LOCApiClientSessionManagerBlock)managerBlock
                               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)userSessionManagerForAuthenticatedUser:(LOCApiClientSessionManagerBlock)managerBlock
                       failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (void)setupAuthenticatedForEmailAddress:(NSString * _Nonnull)emailAddress
                                 password:(NSString * _Nonnull)password
                           sessionManagerBlock:(LOCApiClientSessionManagerBlock)managerBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

- (LOCSessionManager * _Nonnull)userSessionManagerForAccessToken:(NSString * _Nonnull)accessToken;

- (void)forceRefreshAuthenticatedSessionManager:(void (^)(LOCSessionManager * _Nullable))managerBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

#pragma mark - Parse

+ (void)parseErrorWithMessageResponse:(NSError * _Nonnull)error
                         failureBlock:(LOCApiClientErrorWithContextBlockType _Nullable)failureBlock;

+ (void)parseStandardResponse:(NSDictionary * _Nonnull)response
                 successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

+ (void)parseBoolValueResponse:(NSDictionary * _Nonnull)response
                  successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

+ (void)parseOwnUserResponse:(NSDictionary *_Nonnull)response
                successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

+ (void)parseUserResponse:(NSDictionary * _Nonnull)response
             successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock;

NS_ASSUME_NONNULL_END

@end
