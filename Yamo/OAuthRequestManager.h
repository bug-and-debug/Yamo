//
//  OAuthRequestManager.h
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthCredential.h"

/*
 *  OAuth requests paramaters are encoded in x-www-form-urlencoded.
 *  Rather than replacing the request serializer in every call,
 *  we can use this class to call OAuth specific calls.
 */

@interface OAuthRequestManager : NSObject

+ (void)requestOAUTHWithEmail:(NSString *)emailAddress
                   facebookId:(NSString *)facebookId
                      success:(void (^)(OAuthCredential *))success
                      failure:(void (^)(NSError *))failure;

+ (void)requestOAUTHWithEmail:(NSString *)emailAddress
                     password:(NSString *)password
                      success:(void (^)(OAuthCredential *credential))success
                      failure:(void (^)(NSError *error))failure;

+ (void)requestOAUTHUsingNonUserCredentialWithSuccessBlock:(void (^)(OAuthCredential *credential))success
                                                   failure:(void (^)(NSError *error))failure;

@end
