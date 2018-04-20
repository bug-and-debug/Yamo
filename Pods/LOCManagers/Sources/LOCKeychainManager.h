//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

@interface LOCKeychainManager : NSObject

+ (NSString *)passwordForKey:(NSString *)user;
+ (BOOL)setPassword:(NSString *)password forKey:(NSString *)user;
+ (BOOL)removePasswordForKey:(NSString *)user;

@end
