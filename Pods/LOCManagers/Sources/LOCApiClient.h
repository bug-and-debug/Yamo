//
//  ApiClient.h
//
//  Created by Peter Su on 08/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOCSessionManager.h"
#import "LOCApiBlockDefinitions.h"

@protocol LOCApiClientProtocol <NSObject>

/*
 *  Provide default BASE URL
 */
- (NSURL * _Nonnull)baseURL;

@end

@interface LOCApiClient : NSObject <LOCApiClientProtocol>

+ (instancetype _Nonnull)sharedInstance;

#pragma mark - Request serializers

- (AFHTTPRequestSerializer * _Nonnull)requestSerializerWithAuthorizationHeaderFieldsWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password;

- (AFHTTPRequestSerializer * _Nonnull)requestSerializerWithAuthorizationHeaderFieldsForAccessToken:(NSString * _Nonnull)accessToken;

- (AFHTTPRequestSerializer * _Nonnull)defaultRequestSerializerContentType;

#pragma mark - Common Response Parser

+ (void)parseErrorWithContextResponse:(NSError * _Nonnull)error
                         failureBlock:(LOCApiClientErrorWithContextBlockType _Nullable)failureBlock;

@end
