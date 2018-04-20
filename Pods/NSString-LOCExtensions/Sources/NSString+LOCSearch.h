//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

@interface NSString (LOCSearch)

#pragma mark - search
- (BOOL)isIn:(NSString *)stringsToCompare, ...;

@end
