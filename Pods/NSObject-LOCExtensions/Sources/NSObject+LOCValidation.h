//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

@interface NSObject (LOCValidation)

#pragma mark - validation
+ (BOOL)object:(NSObject *)object1 isEqual:(NSObject *)object2;
- (BOOL)isValidObject;
- (BOOL)isValidString;
- (BOOL)isValidDictionary;
- (BOOL)isValidArray;

@end
