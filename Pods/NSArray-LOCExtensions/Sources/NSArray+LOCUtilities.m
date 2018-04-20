//
//  NSArray+LOCUtilities.m
//  NSArray-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSArray+LOCUtilities.h"

@implementation NSArray (LOCUtilities)

#pragma mark - utility

- (id)randomObject {
    if(self.count == 0) {
        return nil;
    }
    
    return [self objectAtIndex:arc4random() % self.count];
}

- (NSArray *)cleanup
{
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        if (![object isEqual:[NSNull null]])
        {
            if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]])
            {
                [array addObject:[object cleanup]];
            }
            else
            {
                [array addObject:object];
            }
        }
    }
    return array;
}

- (NSArray *)arrayFromObjectsCollectedWithBlock:(id(^)(id object))block
{
    __block NSMutableArray *collection = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [collection addObject:block(obj)];
    }];
    
    return collection;
}

@end
