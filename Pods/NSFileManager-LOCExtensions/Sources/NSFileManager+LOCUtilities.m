//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+LOCUtilities.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (LOCUtilities)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utilities
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) standarizePath: (NSString *)path
{
    return [path stringByStandardizingPath];
}

@end
