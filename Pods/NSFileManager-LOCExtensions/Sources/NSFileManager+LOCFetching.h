//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import Foundation;

@interface NSFileManager (LOCFetching)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - fetching
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray *) contentsAtPath:(NSString *)path;
+ (NSArray *) foldersAtPath:(NSString *)path
          includeSubfolders:(BOOL)includeSubfolders;
+ (NSArray *) filesAtPath:(NSString *)path
        includeSubfolders:(BOOL)includeSubfolders;
+ (NSArray *) contentsAtPath:(NSString *)path
           includeSubfolders:(BOOL)includeSubfolders;

/*-----------------------------------------------------------------------------------------------------*/

//  These are suppose to be in the validation, but due to the circular dependency we will encounter we
//  moved them to here.

+ (BOOL) fileName:(NSString *)fileName
     existsAtPath:(NSString *)path
     orSubfolders:(BOOL)includeSubfolders;
+ (BOOL) folderName:(NSString *)folderName
       existsAtPath:(NSString *)path
       orSubfolders:(BOOL)includeSubfolders;
+ (BOOL) itemName:(NSString *)itemName
     existsAtPath:(NSString *)path
     orSubfolders:(BOOL)includeSubfolders;

@end
