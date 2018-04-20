//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSObject+LOCClassUtility.h"

@implementation NSObject (LOCClassUtility)

#pragma mark - class utitlity
+ (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
