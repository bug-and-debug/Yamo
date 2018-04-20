//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSObject+LOCCloning.h"

@implementation NSObject (LOCCloning)

#pragma mark - cloning
- (id)cloneViaArchive {
    if([self conformsToProtocol:@protocol(NSCoding)]) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self];
        return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    }
    
    NSLog(@"%@ does not conform to NSCoding and can't be clones via archive.", NSStringFromClass([self class]));
    return nil;
}

@end
