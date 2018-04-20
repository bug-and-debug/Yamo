//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import UIKit;

@interface NSFileManager (LOCSaving)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)savePngImage:(UIImage *)image
              toPath:(NSString *)path;
+ (BOOL)saveJpegImage:(UIImage *)image
          withQuality:(float)quality
               toPath:(NSString *)path;

// TODO
// save data to path
// save string to path

@end
