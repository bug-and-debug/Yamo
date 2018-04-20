//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import Foundation;

@interface NSFileManager (LOCDirectories)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - directories
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSURL *)cachesUrl;
+ (NSURL *)libraryUrl;
+ (NSURL *)applicationSupportUrl;
+ (NSURL *)documentsUrl;

+ (NSString *)cachesDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)applicationSupportDirectory;
+ (NSString *)documentsDirectory;
+ (NSString *)generateFileName:(NSString *)extension;

@end
