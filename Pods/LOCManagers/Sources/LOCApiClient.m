//
//  ApiClient.m
//
//  Created by Peter Su on 08/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCApiClient.h"
@import AFNetworking;

@implementation LOCApiClient

+ (instancetype)sharedInstance {
    static LOCApiClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return self;
}

#pragma mark - Custom

- (AFHTTPRequestSerializer * _Nonnull)requestSerializerWithAuthorizationHeaderFieldsWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password {
    
    AFHTTPRequestSerializer *requestSerializer = [self defaultRequestSerializerContentType];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    return requestSerializer;
}

- (AFHTTPRequestSerializer * _Nonnull)requestSerializerWithAuthorizationHeaderFieldsForAccessToken:(NSString * _Nonnull)accessToken {
    
    AFHTTPRequestSerializer *requestSerializer = [self defaultRequestSerializerContentType];
    NSString *authStr = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [requestSerializer setValue:authStr forHTTPHeaderField:@"Authorization"];
    
    return requestSerializer;
}

- (AFHTTPRequestSerializer * _Nonnull)defaultRequestSerializerContentType {
    
    AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return requestSerializer;
}

#pragma mark - Common Response Parsers

+ (void)parseErrorWithContextResponse:(NSError *)error
                         failureBlock:(LOCApiClientErrorWithContextBlockType)failureBlock {
    
    NSInteger statusCode = 0;
    NSString *context = nil;
    
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    statusCode = response.statusCode;
    
    if (errorData) {
        NSError* parseError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:errorData
                                                             options:kNilOptions
                                                               error:&parseError];
        
        if (parseError) {
            NSString *errorBody = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"errorBody: %@", errorBody);
        } else {
            if (statusCode == 0) {
                statusCode = [json[@"status"] integerValue];
            }
            context = json[@"error"];
        }
    }
    
    if ([context isEqualToString:@"invalid_token"] || statusCode == 401) {
        
        if (failureBlock) {
            failureBlock(error, statusCode, context);
        }
    } else {
        
        if (failureBlock) {
            failureBlock(error, statusCode, context);
        }
    }
}

#pragma mark - LOCApiClientProtocol

- (NSURL *)baseURL {
    NSAssert(NO, @"Subclass and override this to set a BASE URL");
    return [NSURL URLWithString:@""];
}

@end
