//
//  APIClient+Authentication.m
//  Yamo
//
//  Created by Mo Moosa on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "APIClient+Authentication.h"
#import "SignUpDTO.h"
#import "UserService.h"
#import "LOCAppDefinitions.h"

static NSString * const AuthenticationPathOAuth = @"oauth/token";
static NSString * const AuthenticationPathConnectWithFacebook = @"authentication/connect/facebook";
static NSString * const AuthenticationPathRecoverPassword = @"authentication/password/recover";
static NSString * const AuthenticationPathResetPassword = @"authentication/password/reset";
static NSString * const AuthenticationPathCheckCode = @"authentication/code/check";
static NSString * const AuthenticationPathSignin = @"authentication/sign-in";
static NSString * const AuthenticationPathSignout = @"authentication/sign-out";
static NSString * const AuthenticationPathSignup = @"authentication/sign-up";
static NSString * const AuthenticationPathVerify = @"authentication/verify";
static NSString * const AuthenticationPathVerifyResend = @"authentication/verify/re-send";
static NSString * const AuthenticationPathVerifyCode = @"authentication/verify/%@";
static NSString * const AuthenticationPathGuestUser = @"authentication/guest";

@implementation APIClient (Authentication)

- (void)authenticationCreateGuestUserBeforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                      afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                   successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                   failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:AuthenticationPathGuestUser
                             parameters:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    NSString *email = [response objectForKey:@"email"];
                                    NSString *password = [NSString stringWithFormat:@"%@%@", email, kGuestUserSharedSecret];
                                    
                                    [self setupAuthenticatedForEmailAddress:email
                                                                   password:password
                                                        sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                                                            
                                                            [APIClient parseOwnUserResponse:response successBlock:successBlock failureBlock:failureBlock];
                                                            
                                                        } failureBlock:failureBlock];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
          successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
          failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    

    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *loginDTO = @{@"email": email, @"password": password};
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:AuthenticationPathSignin
                             parameters:loginDTO
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [self setupAuthenticatedForEmailAddress:email
                                                                   password:password
                                                        sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                                        
                                        if (successBlock) {
                                            successBlock(response);
                                        }
                                    } failureBlock:failureBlock];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)logoutWithSuccessBlock:(LOCApiClientSuccessEmptyBlockType)successBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSString *token = [[UserService sharedInstance] refreshToken];
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        if (token) {
            parameter[@"value"] = token;
        }
        
        [sessionManager requestWithType:LOCNetworkRequestTypePut
                                   path:AuthenticationPathSignout
                             parameters:parameter
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    [APIClient parseStandardResponse:response successBlock:successBlock failureBlock:failureBlock];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
}

- (void)authenticateToGetUserWithSuccessBlock:(LOCApiClientSuccessSingleBlockType)successBlock failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    [self userSessionManagerForAuthenticatedUser:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypeGet
                                   path:@"user/profile"
                             parameters:nil
                             beforeLoad:nil
                              afterLoad:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    
                                    if (successBlock) {
                                        
                                        successBlock(response);
                                    }
                                } 
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [LOCApiClient parseErrorWithContextResponse:error failureBlock:failureBlock];
                                }];
        
    } failureBlock:failureBlock];
    
}

- (void)authenticationConnectWithFacebookWithFacebookToken:(NSString *)facebookToken
                                                facebookId:(NSString *)facebookId
                                                     email:(NSString *)email
                                                beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                                 afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                              successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                                              failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {

    [self loginWithFacebookToken:facebookToken
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
                                                
                                            } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                                NSLog(@"signup error : %@ ( %@ )", error.localizedDescription,error);
                                            }];
                        
                    } failureBlock:failureBlock];
}

- (void)loginWithFacebookToken:(NSString *)facebookToken
                  emailAddress:(NSString *)emailAddress
                    beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                     afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                  successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                  failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    

    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        NSDictionary *stringDTO = @{ @"value" : facebookToken };
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:AuthenticationPathConnectWithFacebook
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

- (void)authenticationSignupWithFirstName:(NSString *)firstName
                                 lastName:(NSString *)lastName
                                    email:(NSString *)emailAddress
                                 password:(NSString *)password
                             imageContent:(NSString *)imageContent
                               beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                             successBlock:(LOCApiClientSuccessSingleBlockType)successBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    
    
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        SignUpDTO *signupDTO = [[SignUpDTO alloc] initWithFirstName:firstName
                                                           lastName:lastName
                                                              email:emailAddress
                                                           password:password
                                                       imageContent:imageContent];
        
        NSDictionary *signupDTOMantle = [MTLJSONAdapter JSONDictionaryFromModel:signupDTO error:nil];
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost
                                   path:AuthenticationPathSignup
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


- (void)authenticationRecoverPasswordForEmail:(NSString *)email
                               beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                             successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {

    NSDictionary *stringDTO = @{@"value" : email};
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost path:AuthenticationPathRecoverPassword parameters:stringDTO beforeLoad:beforeLoad afterLoad:afterLoad success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
            
            [APIClient parseStandardResponse:response successBlock:successBlock failureBlock:failureBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            [APIClient parseErrorWithMessageResponse:error failureBlock:failureBlock];
        }];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
    }];
}

- (void)authenticationValidateRecoverPasswordCodeForEmail:(NSString *)email
                                               secretCode:(NSString *)secretCode
                                               beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                                afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                                             successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                                             failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {

    NSDictionary *stringDTO = @{@"email" : email,
                                @"secretCode": secretCode};
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost path:AuthenticationPathCheckCode parameters:stringDTO beforeLoad:beforeLoad afterLoad:afterLoad success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
            
            [APIClient parseBoolValueResponse:response successBlock:^(id  _Nullable element) {
                
                BOOL validated = ((NSNumber *)element).boolValue;
                if (validated && successBlock) {
                    
                    successBlock();
                    
                }
                else if (!validated && failureBlock) {
                    
                    NSError *notOKError = [NSError errorWithDomain:API_ERROR_DOMAIN code:0 userInfo:@{}];
                    failureBlock(notOKError, -2, @"Not Validated");
                }
                
            } failureBlock:failureBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
        }];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
    }];
}

- (void)authenticationResetPasswordForEmail:(NSString *)email
                                newPassword:(NSString *)password
                                 secretCode:(NSString *)secretCode
                                 beforeLoad:(LOCApiClientBeforeLoadBlockType)beforeLoad
                                  afterLoad:(LOCApiClientAfterLoadBlockType)afterLoad
                               successBlock:(LOCApiClientSuccessEmptyBlockType)successBlock
                               failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSDictionary *stringDTO = @{@"email" : email,
                                @"password" : password,
                                @"secretCode" : secretCode};
    
    [self nonOAuthUserSessionManagerWithBlock:^(LOCSessionManager * _Nonnull sessionManager) {
        
        [sessionManager requestWithType:LOCNetworkRequestTypePost path:AuthenticationPathResetPassword parameters:stringDTO beforeLoad:beforeLoad afterLoad:afterLoad success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
            [APIClient parseOwnUserResponse:response successBlock:^(id  _Nullable element) {
                
                [self setupAuthenticatedForEmailAddress:email password:password sessionManagerBlock:^(LOCSessionManager * _Nonnull sessionManager) {
                    
                    if (successBlock) {
                        successBlock();
                    }
                    
                } failureBlock:failureBlock];
                
            } failureBlock:failureBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
        }];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        [APIClient parseErrorWithContextResponse:error failureBlock:failureBlock];
    }];
}

@end
