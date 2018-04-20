//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCDirectories.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (LOCDirectories)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - directories
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSURL *)cachesUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)applicationSupportUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)documentsUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)libraryUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)cachesDirectory
{
    return [[self cachesUrl] path];
}

+ (NSString *)libraryDirectory
{
    return [[self libraryUrl] path];
}

+ (NSString *)applicationSupportDirectory
{
    return [[self applicationSupportUrl] path];
}

+ (NSString *)documentsDirectory
{
    return [[self documentsUrl] path];
}

+ (NSString *)generateFileName:(NSString *)extension {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(__bridge NSString *)string stringByAppendingPathExtension:extension];
}

@end
