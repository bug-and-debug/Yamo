//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "LOCKeychainManager.h"
@import SFHFKeychainUtils;

#define kCMKeychainManager_defaultGroup @"passwords"

@implementation LOCKeychainManager

+ (NSString *)passwordForKey:(NSString *)user {
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:user
                                                    andServiceName:kCMKeychainManager_defaultGroup
                                                             error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return password;
}

+ (BOOL)setPassword:(NSString *)password forKey:(NSString *)user {
    NSError *error = nil;
    if (![SFHFKeychainUtils storeUsername:user
                              andPassword:password
                           forServiceName:kCMKeychainManager_defaultGroup
                           updateExisting:YES
                                    error:&error]) {
        if (error) {
            NSLog(@"%@", error);
        }
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)removePasswordForKey:(NSString *)user
{
    NSError *error = nil;
    if (![SFHFKeychainUtils deleteItemForUsername:user
                                   andServiceName:kCMKeychainManager_defaultGroup
                                            error:&error]) {
        if (error) {
            NSLog(@"%@", error);
        }
        
        return NO;
    }
    
    return YES;
}

@end
