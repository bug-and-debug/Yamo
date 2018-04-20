//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSString+LOCSearch.h"

@implementation NSString (LOCSearch)

#pragma mark - search
- (BOOL)isIn:(NSString *)firstArg, ... {
    NSMutableSet *items = [[NSMutableSet alloc] init];
    
    va_list args;
    va_start(args, firstArg);
    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString*))
    {
        [items addObject:arg];
    }
    va_end(args);
    
    return [items containsObject:self];
}

@end
