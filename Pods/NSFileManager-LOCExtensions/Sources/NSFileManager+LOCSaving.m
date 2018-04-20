//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCSaving.h"
#import "NSFileManager+LOCActions.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)savePngImage:(UIImage *)image
              toPath:(NSString *)path
{
    if ([self createPath:path])
    {
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:path
               atomically:YES];
        return YES;
    }
    
    return NO;
}

+ (BOOL)saveJpegImage:(UIImage *)image
          withQuality:(float)quality
               toPath:(NSString *)path
{
    if (quality < 0.0)
    {
        NSLog(@"quality cannot be less than 0.0, setting to minimum");
        quality = 0.0;
    }
    else if (quality > 1.0)
    {
        NSLog(@"quality cannot be more than 1.0, setting to maximum");
        quality = 1.0;
    }
    
    if ([self createPath:path])
    {
        NSData *data = UIImageJPEGRepresentation(image, quality);
        [data writeToFile:path
               atomically:YES];
        return YES;
    }
    
    return NO;
}

@end
