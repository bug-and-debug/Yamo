//
//  LOCSessionManager.h
//  LOCManagers
//
//  Created by Peter Su on 11/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LOCApiBlockDefinitions.h"

typedef NS_ENUM(NSInteger, LOCNetworkRequestType) {
    LOCNetworkRequestTypeGet,
    LOCNetworkRequestTypePost,
    LOCNetworkRequestTypeDelete,
    LOCNetworkRequestTypePut,
    LOCNetworkRequestTypePatch
};

@interface LOCSessionManager : AFHTTPSessionManager

@property (nonatomic, copy, nullable) void (^beforeRetry)(LOCApiClientSessionManagerBlock completion, LOCApiClientErrorWithContextBlockType failureBlock);

- (void)requestWithType:(LOCNetworkRequestType)requestType
                   path:(NSString * _Nullable)path
             parameters:(NSDictionary * _Nullable)parameters
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)requestWithType:(LOCNetworkRequestType)requestType
                   path:(NSString * _Nullable)path
             parameters:(NSDictionary * _Nullable)parameters
             beforeLoad:(LOCApiClientBeforeLoadBlockType _Nullable)beforeLoad
              afterLoad:(LOCApiClientAfterLoadBlockType _Nullable)afterLoad
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end
