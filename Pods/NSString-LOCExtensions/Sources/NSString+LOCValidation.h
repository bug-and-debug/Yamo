//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import  Foundation;

@interface NSString (LOCValidation)

#pragma mark - validation
- (BOOL)isValidEmailAddress;
- (BOOL)isValidWebAddress;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidString;
- (NSString *)encodedURLParameterString;

@end
