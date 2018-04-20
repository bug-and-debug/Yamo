//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCSkipBackup.h"
#import <sys/xattr.h>

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (LOCSkipBackup)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - skip backup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path
{
    u_int8_t attrValue = 1;
    int result = setxattr( [path fileSystemRepresentation], "com.apple.MobileBackup", &attrValue, 1, 0, 0);
    return result == 0;
}

@end
