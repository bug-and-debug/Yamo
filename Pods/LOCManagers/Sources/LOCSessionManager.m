//
//  LOCSessionManager.m
//  LOCManagers
//
//  Created by Peter Su on 11/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSessionManager.h"

static NSInteger const StatusCodeUnauthorized = 401;
static NSInteger const DefaultStatusCode = -1;

@implementation LOCSessionManager

#pragma mark - Public

- (void)requestWithType:(LOCNetworkRequestType)requestType
                   path:(NSString * _Nullable)path
             parameters:(NSDictionary * _Nullable)parameters
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    [self requestWithType:requestType path:path
               parameters:parameters
               beforeLoad:nil
                afterLoad:nil
                  success:success
              beforeRetry:self.beforeRetry
                  failure:failure];
}

- (void)requestWithType:(LOCNetworkRequestType)requestType
                   path:(NSString * _Nullable)path
             parameters:(NSDictionary * _Nullable)parameters
             beforeLoad:(LOCApiClientBeforeLoadBlockType _Nullable)beforeLoad
              afterLoad:(LOCApiClientAfterLoadBlockType _Nullable)afterLoad
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    [self requestWithType:requestType
                     path:path
               parameters:parameters
               beforeLoad:beforeLoad
                afterLoad:afterLoad
                  success:success
              beforeRetry:self.beforeRetry
                  failure:failure];
}

#pragma mark - Private

/*
 *  Handles retry logic so it only retries if we hit a status code 401 and we only retry once.
 */
- (void)requestWithType:(LOCNetworkRequestType)requestType
                   path:(NSString * _Nullable)path
             parameters:(NSDictionary * _Nullable)parameters
             beforeLoad:(LOCApiClientBeforeLoadBlockType _Nullable)beforeLoad
              afterLoad:(LOCApiClientAfterLoadBlockType _Nullable)afterLoad
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
            beforeRetry:(void (^ _Nullable)(LOCApiClientSessionManagerBlock completion, LOCApiClientErrorWithContextBlockType failureBlock))beforeRetry
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    
    if (beforeLoad) beforeLoad();
    
    success = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        
        if (success)
            success(task, response);
        
        if (afterLoad)
            afterLoad();
    };
    
    failure = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger statusCode = [self statusCodeForError:error];
        
        if (beforeRetry && statusCode == StatusCodeUnauthorized) {
            
            beforeRetry(^(LOCSessionManager * _Nonnull sessionManager){
                
                [sessionManager requestWithType:requestType
                                           path:path
                                     parameters:parameters
                                     beforeLoad:beforeLoad
                                      afterLoad:afterLoad
                                        success:success
                                    beforeRetry:nil
                                        failure:failure];
            }, ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                if (failure)
                    failure(task, error);
                
                if (afterLoad)
                    afterLoad();
            });
        } else {
            
            if (failure)
                failure(task, error);
            
            if (afterLoad)
                afterLoad();
        }
    };
    
    switch (requestType) {
        case LOCNetworkRequestTypeGet:
            [self GET:path parameters:parameters progress:nil success:success failure:failure];
            break;
            
        case LOCNetworkRequestTypePost:
            [self POST:path parameters:parameters progress:nil success:success failure:failure];
            break;
            
        case LOCNetworkRequestTypeDelete:
            [self DELETE:path parameters:parameters success:success failure:failure];
            break;
            
        case LOCNetworkRequestTypePut:
            [self PUT:path parameters:parameters success:success failure:failure];
            break;
            
        case LOCNetworkRequestTypePatch:
            [self PATCH:path parameters:parameters success:success failure:failure];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private helpers

- (NSInteger)statusCodeForError:(NSError *)error {
    
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    if (response) {
        // Normally this is sufficient to get the status code
        return response.statusCode;
    } else {
        // Other look in the json body to see if the status code is defined there
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        
        if (errorData) {
            NSError* parseError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:errorData
                                                                 options:kNilOptions
                                                                   error:&parseError];
            
            if (parseError) {
                return DefaultStatusCode;
            } else {
                if (json[@"status"]) {
                    
                    return [json[@"status"] integerValue];
                }
                return DefaultStatusCode;
            }
        }
        
        return DefaultStatusCode;
    }
}

@end
