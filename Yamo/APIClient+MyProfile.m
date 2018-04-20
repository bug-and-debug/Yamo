//
//  APIClient+MyProfile.m
//  Yamo
//
//  Created by Dario Langella on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient+MyProfile.h"
#import "ProfileDTO.h"
#import "EditProfileDTO.h"
#import "ResponseDTO.h"

static NSString * const UserProfilePath = @"/user/profile";
static NSString * const UserProfileEdit = @"/user/profile/edit";
static NSString * const UserProfileWithUserID = @"/user/%@/profile";
static NSString * const followUserWithID = @"/user/%@/follow";
static NSString * const unFollowUserWithID = @"/user/%@/un-follow";

@implementation APIClient (MyProfile)

- (void)getUserProfileWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:UserProfilePath
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseProfileResponse:response
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)getUserProfileWithUserID:(NSNumber*)userID
                    successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                    failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *pathWithUserID = [NSString stringWithFormat:UserProfileWithUserID,userID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:pathWithUserID
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseProfileResponse:response
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
                                    
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)editUserProfileWithEditedObject:(NSDictionary*)parameters
                           successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                           failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:UserProfileEdit
                             parameters:parameters
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                     [APIClient parseProfileResponse:response
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)followUserWithID:(NSNumber*)userID
            successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
            failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {

     NSString *pathWithUserID = [NSString stringWithFormat:followUserWithID,userID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:pathWithUserID
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                     [APIClient parseFollowUnFollowResponse:response
                                                               successBlock:successBlock
                                                               failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)unFollowUserWithID:(NSNumber*)userID
              successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *pathWithUserID = [NSString stringWithFormat:unFollowUserWithID,userID];
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeDelete
                                   path:pathWithUserID
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseFollowUnFollowResponse:response
                                                              successBlock:successBlock
                                                              failureBlock:failureBlock];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

#pragma mark - Parse

+ (void)parseProfileResponse:(NSDictionary *)response
                successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        ProfileDTO *profile = [MTLJSONAdapter modelOfClass:[ProfileDTO class] fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, [NSString stringWithFormat:@"Could not parse response: %@", response]);
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(profile);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a user", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}

+ (void)parseFollowUnFollowResponse:(NSDictionary *)response
                successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        ResponseDTO *responseMTL = [MTLJSONAdapter modelOfClass:[ResponseDTO class] fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(responseMTL);
            }
        } else {
            if (failureBlock) {
                failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
            }
        }
    } else {
        
        NSError *wrongTypeError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                             code:0
                                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"Response is not a user", nil)}];
        if (failureBlock) {
            failureBlock(wrongTypeError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
    }
}

@end
