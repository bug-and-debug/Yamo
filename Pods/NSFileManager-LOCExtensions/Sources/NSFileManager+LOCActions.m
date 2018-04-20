//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCActions.h"
#import "NSFileManager+LOCValidation.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) createPath: (NSString *)path
{
    if ([self pathIsValid:path])
    {
        return YES;
    }
    
    if ([self isFilePath:path])
    {
        path = [path stringByDeletingLastPathComponent];
    }
    
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    
    if (error)
    {
        NSLog(@"can't create path -> \"%@\"", path);
        NSAssert(false, [error localizedDescription]);
        return NO;
    }
    
    return result;
}

+ (BOOL) removeItemAtPath: (NSString *)path
{
    if ([self pathIsValid:path] && [self itemExistsAtPath:path])
    {
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path
                                                                 error:&error];
        
        if (error)
        {
            NSLog(@"can't remove item at path -> \"%@\"", path);
            NSAssert(false, [error localizedDescription]);
            return NO;
        }
        
        return result;
    }
    
    return NO;
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) renameItemAtPath: (NSString *)path
                   toName: (NSString *)newName
{
    if ([self itemExistsAtPath:path])
    {
        
        NSString *extension = [path pathExtension];
        NSString *directoryPath = [path stringByDeletingLastPathComponent];
        NSString *newPath = [directoryPath stringByAppendingPathComponent:newName];
        
        if (extension)
        {
            newPath = [newPath stringByAppendingFormat:@".%@", extension];
        }
        
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] moveItemAtPath:path
                                                              toPath:newPath
                                                               error:&error];
        
        if (error)
        {
            NSLog(@"can't rename item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", path, newPath);
            NSAssert(false, [error localizedDescription]);
            return NO;
        }
        
        return result;
    }
    
    NSLog(@"can't rename item at path-> \"%@\"\n", path);
    return NO;
}


+ (BOOL) copyItemFromPath: (NSString *)fromPath
                   toPath: (NSString *)toPath
{
    if ([self itemExistsAtPath:fromPath])
    {
        
        if ([self pathIsValid:toPath])
        {
            NSError *error = nil;
            BOOL result = [[NSFileManager defaultManager] copyItemAtPath:fromPath
                                                                  toPath:toPath
                                                                   error:&error];
            
            if (error)
            {
                NSLog(@"can't copy item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", fromPath, toPath);
                NSAssert(false, [error localizedDescription]);
                return NO;
            }
            
            return result;
        }
        
        NSLog(@"destination path is not valid -> \"%@\"", toPath);
        return NO;
    }
    
    NSLog(@"origin path is not valid -> \"%@\"", fromPath);
    return NO;
}


+ (BOOL) moveItemFromPath: (NSString *)fromPath
                   toPath: (NSString *)toPath
{
    if ([self itemExistsAtPath:fromPath])
    {
        
        if ([self pathIsValid:toPath])
        {
            NSError *error = nil;
            BOOL result = [[NSFileManager defaultManager] moveItemAtPath:fromPath
                                                                  toPath:toPath
                                                                   error:&error];
            
            if (error)
            {
                NSLog(@"can't move item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", fromPath, toPath);
                NSAssert(false, [error localizedDescription]);
                return NO;
            }
            
            return result;
        }
        
        NSLog(@"destination path is not valid -> \"%@\"", toPath);
        return NO;
    }
    
    NSLog(@"origin path is not valid -> \"%@\"", fromPath);
    return NO;
}

@end
