//
//  SessionManager.h
//  Yamo
//
//  Created by Mo Moosa on 11/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, SessionManagerRequestType) {
    
    SessionManagerRequestTypeGet,
    SessionManagerRequestTypePost,
    SessionManagerRequestTypePut,
    SessionManagerRequestTypeDelete,
    SessionManagerRequestTypePatch
};
typedef void(^SessionManagerCompletionBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);

@interface SessionManager : AFHTTPSessionManager

- (void)requestWithType:(SessionManagerRequestType)type 
                   path:(NSString * _Nonnull)path 
             parameters:(NSDictionary * _Nullable)parameters 
                success:(_Nullable SessionManagerCompletionBlock)success
                failure:(_Nullable SessionManagerCompletionBlock)failure;


@end
