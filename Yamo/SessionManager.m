//
//  SessionManager.m
//  Yamo
//
//  Created by Mo Moosa on 11/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

- (void)requestWithType:(SessionManagerRequestType)type 
                   path:(NSString *)path 
             parameters:(NSDictionary *)parameters 
                success:(_Nullable SessionManagerCompletionBlock)success
                failure:(_Nullable SessionManagerCompletionBlock)failure {
    
    SessionManagerCompletionBlock successBlock = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {

        if (success)
            success(task, response);
    };
    
    SessionManagerCompletionBlock failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure)
            failure(task, error);
    };
    
    switch (type) {
            
        case SessionManagerRequestTypeGet:
            [self GET:path parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;

        case SessionManagerRequestTypePost:
            [self POST:path parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
            
        case SessionManagerRequestTypeDelete:
            [self DELETE:path parameters:parameters success:successBlock failure:failureBlock];
            break;
            
        case SessionManagerRequestTypePut:
            [self PUT:path parameters:parameters success:successBlock failure:failureBlock];
            break;
        
        case SessionManagerRequestTypePatch:
            
            [self PATCH:path parameters:parameters success:successBlock failure:failureBlock];
            break;

        default:
            break;
    }
}

@end
