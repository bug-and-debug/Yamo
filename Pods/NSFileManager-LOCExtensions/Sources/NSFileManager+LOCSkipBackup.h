//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import Foundation;

@interface NSFileManager (LOCSkipBackup)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - skip backup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path;

@end
