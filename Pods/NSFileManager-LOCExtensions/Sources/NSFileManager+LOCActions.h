//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import Foundation;

@interface NSFileManager (LOCActions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) createPath:(NSString *)path;
+ (BOOL) removeItemAtPath:(NSString *)path;

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) renameItemAtPath:(NSString *)path
                   toName:(NSString *)newName;
+ (BOOL) copyItemFromPath:(NSString *)fromPath
                   toPath:(NSString *)toPath;
+ (BOOL) moveItemFromPath:(NSString *)fromPath
                   toPath:(NSString *)toPath;

/*-----------------------------------------------------------------------------------------------------*/

// TODO
// rename enumerate by (different types)
// rename random

@end
