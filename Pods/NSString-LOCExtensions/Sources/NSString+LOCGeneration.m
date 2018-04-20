//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "NSString+LOCGeneration.h"

@implementation NSString (LOCGeneration)

#pragma mark - generation
+ (NSString *)UUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return newUUID;
}

@end
