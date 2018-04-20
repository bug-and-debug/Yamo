//
//  FilterHelper.m
//  Yamo
//
//  Created by Peter Su on 27/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterHelper.h"

@implementation FilterHelper

#pragma mark - Persisting

+ (void)cacheFilterSearchDTO:(FilterSearchDTO *)dto {
    
    NSString *path = [FilterHelper pathForCacheFile];
    
    if (![NSKeyedArchiver archiveRootObject:dto toFile:path]) {
        NSLog(@"Cache file failed");
    }
}

+ (FilterSearchDTO *)cachedFilterSearchDTO {
    
    NSString *path = [self pathForCacheFile];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

#pragma mark - Helpers

+ (NSString *)pathForCacheFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *path = [applicationSupportDirectory stringByAppendingPathComponent:(NSString *)FilterSearchCacheFileName];
    return path;
}


@end
