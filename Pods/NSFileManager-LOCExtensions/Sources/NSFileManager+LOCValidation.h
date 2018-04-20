//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import Foundation;

@interface NSFileManager (LOCValidation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - check
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) pathIsValid: (NSString *)path;
+ (BOOL) pathExists: (NSString *)path;
+ (BOOL) itemExistsAtPath:(NSString *)path;

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) isFolderPath:(NSString *)folderPath;
+ (BOOL) isFilePath:(NSString *)filePath;


@end
