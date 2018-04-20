//
//  APIClient.m
//  Yamo
//
//  Created by Mo Moosa on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient.h"
#import "Response.h"
#import "BoolValueResponse.h"
#import "User.h"
#import "UserService.h"
#import "OAuthCredential.h"
#import "NetworkingConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const OAuthCodeGrantType = @"authorization_code";
NSString * const OAuthClientCredentialGrantType = @"client_credentials";
NSString * const OAuthPasswordCredentialGrantType = @"password";
NSString * const OAuthRefreshGrantType = @"refresh_token";

static NSString * const OAuthClientSecret = @"LXUYc4zd2AaBVbEr";
static NSString * const OAuthClientID = @"a4PqNmXHP482ZK89";
static NSString * const NoAuthUsername = @"v4p2Qj7EYswDuTSk";
static NSString * const NoAuthPassword = @"ts4aD4uhAJxz5zUX";

NS_ASSUME_NONNULL_END

@interface APIClient ()

@property (nonatomic) LOCSessionManager * _Nullable encodedSessionManager;

@property (nonatomic) LOCSessionManager * _Nullable nonOAuthUserSessionManager;

@property (nonatomic) LOCSessionManager * _Nullable userSessionManager;

@end

@implementation APIClient


#pragma mark - Default Session Manager

- (void)nonOAuthUserSessionManagerWithBlock:(LOCApiClientSessionManagerBlock)managerBlock
                               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if (self.nonOAuthUserSessionManager) {
        
        if (managerBlock) {
            
            managerBlock(self.nonOAuthUserSessionManager);
        }
    }
    else {
        
        [self setupSessionManager:managerBlock failureBlock:failureBlock];
    }
}

#pragma mark - URL Encoded Session Manager



- (LOCSessionManager *)sessionManagerDidAuthenticateWithAccessToken:(NSString *)accessToken {
    
    self.nonOAuthUserSessionManager = [[LOCSessionManager alloc] initWithBaseURL:self.baseURL];
    
    self.nonOAuthUserSessionManager.requestSerializer = [self requestSerializerWithAuthorizationHeaderFieldsForAccessToken:accessToken];
    
    return self.nonOAuthUserSessionManager;
}

- (void)setupSessionManager:(void (^)(LOCSessionManager * _Nullable))sessionManagerBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSDictionary *credentialsDTO = @{@"username" : NoAuthUsername,
                                     @"password" : NoAuthPassword,
                                     @"grant_type" : OAuthPasswordCredentialGrantType,
                                     @"scope" : @"read write",
                                     @"client_secret" : OAuthClientSecret,
                                     @"client_id" : OAuthClientID};
    
    [self encodedSessionManager:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager POST:@"oauth/token"
                  parameters:credentialsDTO
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSString *accessToken = responseObject[@"access_token"];
                         
                         if (sessionManagerBlock) {
                             
                             sessionManagerBlock([self sessionManagerDidAuthenticateWithAccessToken:accessToken]);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error setting up session manager: %@ (%@)", error.localizedDescription, error);
                         
                         [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                     }];
    }];
    
}

#pragma mark - URL Encoded Session Manager

- (void)encodedSessionManager:(LOCApiClientSessionManagerBlock)sessionManagerBlock {
    
    if (!self.encodedSessionManager) {
        
        self.encodedSessionManager = [[LOCSessionManager alloc] initWithBaseURL:self.baseURL];
        
        AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer new];
        
        [httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [httpRequestSerializer setAuthorizationHeaderFieldWithUsername:OAuthClientID password:OAuthClientSecret];
        
        self.encodedSessionManager.requestSerializer = httpRequestSerializer;
    }
    
    if (sessionManagerBlock) {
        
        sessionManagerBlock(self.encodedSessionManager);
    }
}


- (void)userSessionManagerForAuthenticatedUser:(LOCApiClientSessionManagerBlock)sessionManagerBlock
                                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self sessionManagerForAuthenticatedUser:sessionManagerBlock
                                       email:nil
                                    password:nil
                                failureBlock:failureBlock];
}

- (void)sessionManagerForAuthenticatedUser:(void (^_Nullable)(LOCSessionManager * _Nonnull sessionManager))sessionManagerBlock
                                     email:(NSString * _Nullable)email
                                  password:(NSString * _Nullable)password
                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    
    if (self.userSessionManager) {
        
        if (sessionManagerBlock) {
            
            sessionManagerBlock(self.userSessionManager);
        }
    }
    else {
        
        [self setupAuthenticatedForEmailAddress:email
                                       password:password
                            sessionManagerBlock:sessionManagerBlock
                                   failureBlock:failureBlock];
        
    }
}

- (LOCSessionManager * _Nonnull)userSessionManagerForAccessToken:(NSString * _Nonnull)accessToken {
    
    self.userSessionManager = [[LOCSessionManager alloc] initWithBaseURL:[self baseURL]];
    self.userSessionManager.requestSerializer = [self requestSerializerWithAuthorizationHeaderFieldsForAccessToken:accessToken];
    
    __weak typeof(self) weakSelf = self;
    
    
    self.userSessionManager.beforeRetry = ^(LOCApiClientSessionManagerBlock completionBlock, LOCApiClientErrorWithContextBlockType failureBlock) {
        [weakSelf refreshAuthenticatedSessionManager:completionBlock failureBlock:failureBlock];
    };
    
    return self.userSessionManager;
}


- (void)setupAuthenticatedForEmailAddress:(NSString * _Nonnull)emailAddress
                                 password:(NSString * _Nonnull)password
                      sessionManagerBlock:(LOCApiClientSessionManagerBlock)sessionManagerBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    
    if (!emailAddress || !password) {
        
        NSError *error = [NSError errorWithDomain:@"APIClient" code:-1 userInfo:nil];
        
        failureBlock(error, -1, @"You must authenticate with your email & password first.");
        return;
    }
    
    NSDictionary *credentialsDTO = @{@"username" : emailAddress,
                                     @"password" : password,
                                     @"grant_type" : OAuthPasswordCredentialGrantType,
                                     @"scope" : @"read write",
                                     @"client_secret" : OAuthClientSecret,
                                     @"client_id" : OAuthClientID};
    
    [self encodedSessionManager:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager POST:@"oauth/token"
                  parameters:credentialsDTO
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSString *accessToken = responseObject[@"access_token"];
                         NSError *parseError = nil;
                         
                         OAuthCredential *credential = [MTLJSONAdapter modelOfClass:[OAuthCredential class] fromJSONDictionary:responseObject error:&parseError];
                         
                         if (!parseError) {
                             
                             [[UserService sharedInstance] didAuthenticateUsingOAuth:credential];
                             
                             LOCSessionManager *authenticatedSessionManager = [self userSessionManagerForAccessToken:accessToken];
                             
                             if (sessionManagerBlock) {
                                 
                                 sessionManagerBlock(authenticatedSessionManager);
                             }
                         }
                         else {
                             
                             if (failureBlock) {
                                 
                                 failureBlock(parseError, -1, @"Failed to parse response");
                                 
                             }
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error setting up session manager: %@ (%@)", error.localizedDescription, error);
                         
                         [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                     }];
    }];
    
}

- (void)refreshAuthenticatedSessionManager:(void (^)(LOCSessionManager * _Nullable))sessionManagerBlock
                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *refreshToken = [[UserService sharedInstance] refreshToken];
    
    if (refreshToken) {
        
        NSDictionary *credentialsDTO = @{@"grant_type": OAuthRefreshGrantType,
                                         @"refresh_token": refreshToken,
                                         @"client_secret": OAuthClientSecret,
                                         @"client_id": OAuthClientID};
        
        [self encodedSessionManager:^(LOCSessionManager * _Nonnull sessionManager) {
            
            [sessionManager POST:@"oauth/token"
                      parameters:credentialsDTO
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSError *parseError = nil;
                             OAuthCredential *credential = [MTLJSONAdapter modelOfClass:[OAuthCredential class] fromJSONDictionary:responseObject error:&parseError];
                             
                             if (!parseError) {
                                 
                                 [[UserService sharedInstance] didAuthenticateUsingOAuth:credential];
                                 LOCSessionManager *authenticatedSessionManager = [self userSessionManagerForAccessToken:credential.accessToken];
                                 
                                 if (sessionManagerBlock) {
                                     sessionManagerBlock(authenticatedSessionManager);
                                 }
                                 
                             }
                             else {
                                 
                                 if (failureBlock) {
                                     
                                     failureBlock(parseError, -1, @"Failed to parse the response.");
                                 }
                             }
                         }                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             [LOCApiClient parseErrorWithContextResponse:error
                                                            failureBlock:failureBlock];
                         }];
            
        }];
    }
    else {
        
        if (failureBlock) {
            
            NSError *error = [NSError errorWithDomain:API_ERROR_DOMAIN code:0 userInfo:@{}];
            failureBlock(error, -2, @"");
        }
    }
}

#pragma mark - Testing

- (void)forceRefreshAuthenticatedSessionManager:(void (^)(LOCSessionManager * _Nullable))managerBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSString *refreshToken = [[UserService sharedInstance] refreshToken];
    
    if (refreshToken) {
        
        NSDictionary *credentialsDTO = @{@"grant_type": OAuthRefreshGrantType,
                                         @"refresh_token": refreshToken,
                                         @"client_secret": OAuthClientSecret,
                                         @"client_id": OAuthClientID
                                         };
        
        
        [self encodedSessionManager:^(LOCSessionManager * _Nonnull sessionManager) {
            
            [sessionManager POST:@"oauth/token"
                      parameters:credentialsDTO
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             NSString *accessToken = responseObject[@"access_token"];
                             NSString *refreshToken = responseObject[@"refresh_token"];
                             NSLog(@"Forced authenticated accessToken: %@ refreshToken %@", accessToken, refreshToken);
                             
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             NSLog(@"This probably shouldn't happen.\nError: %@", error.localizedDescription);
                             [LOCApiClient parseErrorWithContextResponse:error
                                                            failureBlock:failureBlock];
                         }];
        }];
    }
    else {
        
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:API_ERROR_DOMAIN code:0 userInfo:@{}];
            failureBlock(error, -2, @"");
        }
    }
    
}

//
//forceRefreshAuthenticatedSessionManager:(void (^)(LOCSessionManager * _Nullable))sessionManagerBlock
//failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
//
//    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authenticated_refresh_token"];
//
//    NSLog(@"Existing authenticated refreshToken: %@", refreshToken);
//    if (refreshToken) {
//        NSDictionary *credentialsDTO = @{ @"grant_type" : OAuthRefreshGrantType,
//                                          @"refresh_token" : refreshToken,
//                                          @"client_secret" : OAUTH_CLIENT_SECRET,
//                                          @"client_id" : OAUTH_CLIENT_ID };
//
//        [self urlEncodedSessionManager:^(LOCSessionManager * _Nonnull sessionManager) {
//
//            [sessionManager POST:@"oauth/token"
//                      parameters:credentialsDTO
//                        progress:nil
//                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                             NSString *accessToken = responseObject[@"access_token"];
//                             NSString *refreshToken = responseObject[@"refresh_token"];
//                             NSLog(@"Forced authenticated accessToken: %@", accessToken);
//
//                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//                             NSLog(@"This probably shouldn't happen.\nError: %@", error.localizedDescription);
//                             [LOCApiClient parseErrorWithContextResponse:error
//                                                            failureBlock:failureBlock];
//                         }];
//        }];
//    } else {
//
//        if (failureBlock) {
//            NSError *error = [NSError errorWithDomain:MyLocalApiClientErrorDomain code:0 userInfo:@{}];
//            failureBlock(error, -2, @"");
//        }
//    }
//}

#pragma mark - URL

- (NSURL *)baseURL {
    return [NSURL URLWithString:BASE_URL];
}

#pragma mark - Parse

+ (void)parseStandardResponse:(NSDictionary *)response
                 successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                 failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSError *parseError = nil;
    Response *responseObject = [MTLJSONAdapter modelOfClass:[Response class] fromJSONDictionary:response error:&parseError];
    
    if (parseError) {
        
        if (failureBlock) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
    } else {
        
        if ([responseObject.responseText isEqualToString:@"OK"]) {
            
            if (successBlock) {
                successBlock();
            }
        } else {
            
            NSString *message = responseObject.responseText;
            NSInteger statusCode = responseObject.status.integerValue;
            
            NSError *notOKError = [NSError errorWithDomain:API_ERROR_DOMAIN code:statusCode userInfo:@{ NSLocalizedDescriptionKey: message }];
            
            if (failureBlock) {
                failureBlock(notOKError, statusCode, message);
            }
        }
    }
}

+ (void)parseErrorWithMessageResponse:(NSError * _Nonnull)error
                         failureBlock:(LOCApiClientErrorWithContextBlockType _Nullable)failureBlock {
    
    NSInteger statusCode = 0;
    NSString *context = nil;
    
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    
    if (errorData) {
        NSError* parseError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:errorData
                                                             options:kNilOptions
                                                               error:&parseError];
        
        if (parseError) {
            NSString *errorBody = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"errorBody: %@", errorBody);
        } else {
            statusCode = [json[@"status"] integerValue];
            context = json[@"message"];
        }
    }
    
    if (failureBlock) {
        failureBlock(error, statusCode, context);
    }
}

+ (void)parseBoolValueResponse:(NSDictionary *)response
                  successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSError *parseError = nil;
    BoolValueResponse *responseObject = [MTLJSONAdapter modelOfClass:[BoolValueResponse class] fromJSONDictionary:response error:&parseError];
    
    if (parseError) {
        
        if (failureBlock) {
            failureBlock(parseError, -1, @"Could not parse response");
        }
    } else {
        
        if (successBlock) {
            successBlock(@(responseObject.value));
        }
    }
}

+ (void)parseOwnUserResponse:(NSDictionary *)response
                successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self parseUserResponse:response successBlock:^(id  _Nullable element) {
        
        [[UserService sharedInstance] didLoginWithUser:element];
        
        if (successBlock) {
            successBlock(element);
        }
    } failureBlock:failureBlock];
}

+ (void)parseUserResponse:(NSDictionary *)response
             successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSError *parseError = nil;
        User *loggedInUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parseError];
        
        if (failureBlock && parseError) {
            failureBlock(parseError, API_PARSE_RESPONSE_ERROR, @"Could not parse response");
        }
        
        if (!parseError) {
            
            if (successBlock) {
                successBlock(loggedInUser);
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
