//
//  TimeToDisplayString.m
//  Yamo
//
//  Created by Peter Su on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "TimeToDisplayString.h"
#import "LOCMacros.h"

@implementation TimeToDisplayString

#pragma mark - Time helpers

+ (NSString *)convertMinutesToDisplayTime:(double)totalTimeInSeconds {
    
    NSMutableString *displayText = [NSMutableString new];
    
    int days = floor(totalTimeInSeconds / (60 * 60 * 24));
    totalTimeInSeconds -= days * (60 * 60 * 24);
    if (days > 0) {
        [displayText appendString:[NSString stringWithFormat:NSLocalizedString(@"%@ days", nil), @(days)]];
    }
    
    int hours = floor(totalTimeInSeconds / (60 * 60));
    totalTimeInSeconds -= hours * (60 * 60);
    if (hours > 0) {
        if (displayText.length > 0) {
            [displayText appendString:@", "];
        }
        [displayText appendString:[NSString stringWithFormat:NSLocalizedString(@"%@ hours", nil), @(hours)]];
    }
    
    int minutes = floor(totalTimeInSeconds / 60);
    totalTimeInSeconds -= minutes * 60;
    if (minutes > 0) {
        if (displayText.length > 0) {
            [displayText appendString:@", "];
        }
        [displayText appendString:[NSString stringWithFormat:NSLocalizedString(@"%@ minutes", nil), @(minutes)]];
    }
    
    if (totalTimeInSeconds > 0 && displayText.length == 0) {
        
        [displayText appendString:NSLocalizedString(@"Less than a minute", nil)];
    }
    
    if ((IS_IPHONE_4_OR_LESS || IS_IPHONE_5) &&
        ([displayText containsString:@"hours"] && [displayText containsString:@"minutes"])) {
        
        [displayText replaceOccurrencesOfString:@"hours" withString:@"hrs" options:0 range:NSMakeRange(0, displayText.length)];
        [displayText replaceOccurrencesOfString:@"minutes" withString:@"mins" options:0 range:NSMakeRange(0, displayText.length)];
    }
    
    return displayText;
}

@end
