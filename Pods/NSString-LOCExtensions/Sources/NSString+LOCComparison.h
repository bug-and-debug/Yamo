//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

@interface NSString (LOCComparison)

#pragma mark - comparison
- (BOOL)containsString:(NSString *)string;
- (BOOL)hasOnlyCharactersInString:(NSString *)string;
- (BOOL)hasNoCharactersInString:(NSString *)string;
- (BOOL)hasOnlyAlphabetical;
- (BOOL)hasOnlyNumbers;

@end
