//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

@interface NSString (LOCUtilities)

#pragma mark - utility
- (NSString *)trim;
- (NSString *)removeAllWhiteSpaces;
- (NSString *)normalizeFunkyCharacters;
- (NSString*)asPhoneNumber;
- (NSString *)onlyNumbers;
- (NSString *)alphabeticalIndex;
- (NSString *)md5String;
- (NSString*) SHA1String;
- (NSAttributedString *)attributedString;

@end
