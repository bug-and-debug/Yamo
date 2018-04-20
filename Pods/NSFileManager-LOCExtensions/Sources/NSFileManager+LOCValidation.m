//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCValidation.h"
@import NSString_LOCExtensions;

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (LOCValidation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) pathIsValid: (NSString *)path
{
    if ([self itemExistsAtPath:path] || [self pathExists:path])
    {
        return YES;
    }
    return NO;
}

+ (BOOL) pathExists: (NSString *)path
{
    if (![[path pathExtension] isEqualToString:@""])
    {
        path = [path stringByDeletingLastPathComponent];
    }
    return [self itemExistsAtPath:path];
}

+ (BOOL) itemExistsAtPath: (NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) isFolderPath: (NSString *)folderPath
{
    return ![folderPath pathExtension].isValidString;
}

+ (BOOL) isFilePath: (NSString *)filePath
{
    return [filePath pathExtension].isValidString;
}


@end
