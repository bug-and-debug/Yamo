//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSString+LOCValidation.h"
#import "NSString+LOCUtilities.h"
@import NSObject_LOCExtensions;

@implementation NSString (LOCValidation)

#pragma mark - validation
- (BOOL)isValidEmailAddress
{
    if (![self isValidString])
    {
        return NO;
    }
    
    NSString *emailRegularExpression =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegularExpression];
    return [regExPredicate evaluateWithObject:self.lowercaseString];
}

- (BOOL)isValidWebAddress
{
    if (![self isValidString])
    {
        return NO;
    }
    
    NSURL *candidateURL = [NSURL URLWithString:self];
    if (candidateURL && candidateURL.scheme && candidateURL.host)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPhoneNumber
{
    if (![self isValidString])
    {
        return NO;
    }
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890-()+ *#;,"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isValidString
{
    return ([self isValidObject] && self.trim.length != 0);
}

- (NSString *)encodedURLParameterString {
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (CFStringRef)self,
                                                                 NULL,
                                                                 CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                 kCFStringEncodingUTF8);
    
    NSString *result = [(__bridge NSString *)string copy];
    CFRelease(string);
    return result;
}

@end
