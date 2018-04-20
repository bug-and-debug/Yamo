//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSObject+LOCBlocks.h"

@implementation NSObject (LOCBlocks)

#pragma mark - blocks
- (void)runBlock:(void(^)())block {
    if (block) {
        block();
    }
}

@end
