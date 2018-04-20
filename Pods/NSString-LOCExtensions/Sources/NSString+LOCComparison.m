//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSString+LOCComparison.h"

@implementation NSString (LOCComparison)

#pragma mark - comparison
- (BOOL)containsString:(NSString *)string
{
    return [self rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound;
}

- (BOOL)hasOnlyCharactersInString:(NSString *)string
{
    return [self rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:string] invertedSet]].location == NSNotFound;
}

- (BOOL)hasNoCharactersInString:(NSString *)string {
    return [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:string]].location == NSNotFound;
}

- (BOOL)hasOnlyAlphabetical
{
    return [self hasOnlyCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
}

- (BOOL)hasOnlyNumbers
{
    return [self hasOnlyCharactersInString:@"0123456789"];
}

@end
