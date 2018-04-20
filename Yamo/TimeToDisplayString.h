//
//  TimeToDisplayString.h
//  Yamo
//
//  Created by Peter Su on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeToDisplayString : NSObject

+ (NSString *)convertMinutesToDisplayTime:(double)totalTimeInSeconds;

@end
