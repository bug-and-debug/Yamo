//
//  OAuthRequestManager.m
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "OAuthRequestManager.h"
#import "AFHTTPSessionManager.h"
#import "LOCNetworking.h"

NSString * const OAuthCodeGrantType = @"authorization_code";
NSString * const OAuthClientCredentialGrantType = @"client_credentials";
NSString * const OAuthPasswordCredentialGrantType = @"password";
NSString * const OAuthRefreshGrantType = @"refresh_token";

@implementation OAuthRequestManager

+ (void)requestOAUTHWithEmail:(NSString *)emailAddress
                   facebookId:(NSString *)facebookId
                      success:(void (^)(OAuthCredential *))success
                      failure:(void (^)(NSError *))failure {
    
    NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];
    
    [self requestOAUTHWithEmail:emailAddress password:tempPassword success:success failure:failure];
}

+ (void)requestOAUTHWithEmail:(NSString *)emailAddress
                     password:(NSString *)password
                      success:(void (^)(OAuthCredential *))success
                      failure:(void (^)(NSError *))failure {
    
    if ([emailAddress isValidString] && [password isValidString]) {
        NSDictionary *credentialsDTO = @{ @"username" : emailAddress,
                                          @"password" : password,
                                          @"grant_type" : OAuthPasswordCredentialGrantType,
                                          @"scope" : @"read write",
                                          @"client_secret" : OAUTH_CLIENT_SECRET,
                                          @"client_id" : OAUTH_CLIENT_ID };
        
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer new];
        [httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [httpRequestSerializer setAuthorizationHeaderFieldWithUsername:OAUTH_CLIENT_ID password:OAUTH_CLIENT_SECRET];
        
        httpSessionManager.requestSerializer = httpRequestSerializer;
        
        [httpSessionManager POST:@"oauth/token"
                      parameters:credentialsDTO
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSError *parseError = nil;
                            OAuthCredential *credential = [MTLJSONAdapter modelOfClass:[OAuthCredential class] fromJSONDictionary:responseObject error:&parseError];
                            
                            if (!parseError) {
                                NSLog(@"User credential: %@", credential);
                                
                                if (success) {
                                    success(credential);
                                }
                            } else {
                                
                                NSLog(@"parse error: %@", parseError);
                                
                                if (failure) {
                                    failure(parseError);
                                }
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            if (failure) {
                                failure(error);
                            }
                        }];
    }
}

+ (void)requestOAUTHUsingNonUserCredentialWithSuccessBlock:(void (^)(OAuthCredential *credential))success
                                                   failure:(void (^)(NSError *error))failure {
    
    OAuthCredential *existingNonOAuthCredential = [[UserService sharedInstance] nonOAuthCredential];
    
    if (existingNonOAuthCredential) {
        if (success) {
            success(existingNonOAuthCredential);
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } else {
        
        NSDictionary *credentialsDTO = @{ @"username" : NO_AUTH_USERNAME,
                                          @"password" : NO_AUTH_PASSWORD,
                                          @"grant_type" : OAuthPasswordCredentialGrantType,
                                          @"scope" : @"read write",
                                          @"client_secret" : OAUTH_CLIENT_SECRET,
                                          @"client_id" : OAUTH_CLIENT_ID };
        
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer new];
        [httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [httpRequestSerializer setAuthorizationHeaderFieldWithUsername:OAUTH_CLIENT_ID password:OAUTH_CLIENT_SECRET];
        
        httpSessionManager.requestSerializer = httpRequestSerializer;
        
        [httpSessionManager POST:@"oauth/token"
                      parameters:credentialsDTO
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSError *parseError = nil;
                            OAuthCredential *credential = [MTLJSONAdapter modelOfClass:[OAuthCredential class] fromJSONDictionary:responseObject error:&parseError];
                            [UserService sharedInstance].nonOAuthCredential = credential;
                            
                            if (!parseError) {
                                NSLog(@"NonUser credential: %@", credential);
                                
                                if (success) {
                                    success(credential);
                                }
                            } else {
                                
                                NSLog(@"parse error: %@", parseError);
                                
                                if (failure) {
                                    failure(parseError);
                                }
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            if (failure) {
                                failure(error);
                            }
                        }];
    }
}

+ (void)requestOAUTHUsingHTTPBasicAuthentication:(BOOL)usesBasicAuthentication
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(OAuthCredential *credential))success
                                         failure:(void (^)(NSError *error))failure {
    
}

@end
