//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCFetching.h"
#import "NSFileManager+LOCValidation.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (LOCFetching)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - fetching
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray *)  contentsAtPath: (NSString *)path
{
    if (![self isFolderPath:path])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSArray *contentsAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (error)
    {
        NSLog(@"can't get contents for path -> \"%@\"", path);
        return nil;
    }
    
    return [contentsAtPath sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
}

+ (NSArray *) foldersAtPath: (NSString *)path
          includeSubfolders:  (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path];
    NSMutableArray *folderPaths = [NSMutableArray array];
    for (int i = 0; i < [contentsAtPath count]; i++)
    {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFolderPath:path] && ![path hasPrefix:@"."])
        {
            [folderPaths addObject:path];
            
            if (includeSubfolders)
            {
                NSArray *subFolderFolderPaths = [self foldersAtPath:path
                                                  includeSubfolders:YES];
                [folderPaths addObjectsFromArray:subFolderFolderPaths];
            }
            
        }
    }
    
    if ([folderPaths count] == 0)
    {
        return nil;
    }
    
    return folderPaths;
}

+ (NSArray *)  filesAtPath: (NSString *)path
         includeSubfolders: (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path];
    NSMutableArray *filePaths = [NSMutableArray array];
    
    for (int i = 0; i < [contentsAtPath count]; i++)
    {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFilePath:path])
        {
            [filePaths addObject:path];
        }
        else if (includeSubfolders)
        {
            NSArray *subFolderFilePaths = [self filesAtPath:path
                                          includeSubfolders:YES];
            [filePaths addObjectsFromArray:subFolderFilePaths];
        }
    }
    
    if ([filePaths count] == 0)
    {
        return nil;
    }
    
    return filePaths;
}

+ (NSArray *) contentsAtPath:  (NSString *)path
           includeSubfolders:  (BOOL)includeSubfolders
{
    NSMutableArray *contentsAtPath = [NSMutableArray arrayWithArray:[self contentsAtPath:path]];
    
    if (!includeSubfolders)
    {
        return contentsAtPath;
    }
    
    for (int i = 0; i < [contentsAtPath count]; i++)
    {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFolderPath:path])
        {
            NSArray *subFolderFolderPaths = [self contentsAtPath:path
                                               includeSubfolders:YES];
            [contentsAtPath addObjectsFromArray:subFolderFolderPaths];
        }
    }
    
    if ([contentsAtPath count] == 0)
    {
        return nil;
    }
    
    return contentsAtPath;
    
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) fileName: (NSString *)fileName
     existsAtPath: (NSString *)path
     orSubfolders: (BOOL)includeSubfolders
{
    NSArray *filesAtPath = [self filesAtPath:path
                           includeSubfolders:includeSubfolders];
    for (int i = 0; i < [filesAtPath count]; i++)
    {
        NSString *path = [filesAtPath objectAtIndex:i];
        NSString *subPathFileName = [[path stringByDeletingPathExtension] lastPathComponent];
        if ([subPathFileName isEqualToString:fileName])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) folderName: (NSString *)folderName
       existsAtPath: (NSString *)path
       orSubfolders: (BOOL)includeSubfolders
{
    NSArray *foldersAtPath = [self foldersAtPath:path
                               includeSubfolders:YES];
    for (int i = 0; i < [foldersAtPath count]; i++)
    {
        NSString *path = [foldersAtPath objectAtIndex:i];
        NSString *subPathFolderName = [path lastPathComponent];
        if ([subPathFolderName isEqualToString:folderName])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) itemName: (NSString *)itemName
     existsAtPath: (NSString *)path
     orSubfolders: (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path
                                 includeSubfolders:includeSubfolders];
    for (int i = 0; i < [contentsAtPath count]; i++)
    {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFilePath:path])
        {
            NSString *subPathFileName = [[path stringByDeletingPathExtension] lastPathComponent];
            if ([subPathFileName isEqualToString:itemName])
            {
                return YES;
            }
        }
        else
        {
            NSString *subPathFolderName = [path lastPathComponent];
            if ([subPathFolderName isEqualToString:itemName])
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
