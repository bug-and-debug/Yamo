//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSString+LOCUtilities.h"
#import "NSString+LOCComparison.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LOCUtilities)

#pragma mark - utilities
- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeAllWhiteSpaces {
    NSArray* words = [self componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [words componentsJoinedByString:@""];
}

- (NSString *) normalizeFunkyCharacters
{
    NSData *temp = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
}

- (NSString *)alphabeticalIndex
{
    if (self.length > 0)
    {
        NSString *index = [[self.normalizeFunkyCharacters substringToIndex:1] uppercaseString];
        if(![index hasOnlyAlphabetical])
        {
            index = @"#";
        }
        return index;
    }
    return nil;
}

- (NSString *)onlyNumbers
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

-(NSString*)asPhoneNumber
{
    NSString *mobileNumber = [self onlyNumbers];
    NSMutableString *convertedNumber = [mobileNumber mutableCopy];
    switch (convertedNumber.length) {
        case 0:
            return @"";
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return convertedNumber;
            break;
        case 5:
        case 6:
        case 7:
            [convertedNumber insertString:@"-" atIndex:convertedNumber.length-4];
            break;
        case 8:
        case 9:
        case 10:
            [convertedNumber insertString:@"-" atIndex:convertedNumber.length-4];
            [convertedNumber insertString:@") " atIndex:convertedNumber.length-8];
            [convertedNumber insertString:@"(" atIndex:0];
            break;
        default:
            [convertedNumber insertString:@"-" atIndex:convertedNumber.length-4];
            [convertedNumber insertString:@") " atIndex:convertedNumber.length-8];
            [convertedNumber insertString:@" (" atIndex:convertedNumber.length-13];
            [convertedNumber insertString:@"+" atIndex:0];
            break;
    }
    return convertedNumber;
}

- (NSString *)md5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*) SHA1String {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

- (NSAttributedString *)attributedString {
    return [[NSAttributedString alloc] initWithString:self];
}

@end
