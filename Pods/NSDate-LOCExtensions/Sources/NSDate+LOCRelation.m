//
//  NSDate+LOCRelation.m
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSDate+LOCRelation.h"

@implementation NSDate (LOCRelation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - misc
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (NSDateDifferenceType)relativeDateDifference {
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [self timeIntervalSinceDate:now] * -1.0;
    
    if (delta < 0) {
        return NSDateDifferenceTypeInTheFuture;
    } else if (delta < 1 * MINUTE) {
        return NSDateDifferenceTypeJustNow;
    } else if (delta < 1 * HOUR) {
        return NSDateDifferenceTypeLessThanAnHour;
    } else if (delta < 24 * HOUR) {
        return NSDateDifferenceTypeLessThanADay;
    } else if (delta < 48 * HOUR) {
        return NSDateDifferenceTypeLessThan2Days;
    } else {
        return NSDateDifferenceTypeMoreThan2days;
    }
    
    return NSDateDifferenceTypeUnknown;
}

- (NSInteger)relateDateComponentDifference {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:units fromDate:self toDate:now options:0];
    
    switch ([self relativeDateDifference]) {
        case NSDateDifferenceTypeLessThanAnHour: {
            return components.minute;
        }
        case NSDateDifferenceTypeLessThanADay: {
            return components.hour;
        }
        case NSDateDifferenceTypeLessThan2Days: {
            return components.day;
        }
            // TODO: Do other cases
        default: {
            return 0;
        }
    }
}

- (NSString *)timestampForDifferenceType:(NSDateDifferenceType)differenceType  {
    switch (differenceType) {
        case NSDateDifferenceTypeJustNow: {
            return NSLocalizedString(@"Just Now", nil);
        }
        case NSDateDifferenceTypeLessThanAnHour: {
            NSInteger difference = [self relateDateComponentDifference];
            if (difference > 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%ld mins ago", nil), difference];
            } else {
                return NSLocalizedString(@"1 min ago", nil);
            }
        }
        case NSDateDifferenceTypeLessThanADay: {
            NSInteger difference = [self relateDateComponentDifference];
            if (difference > 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%ld hours ago", nil), difference];
            } else {
                return NSLocalizedString(@"1 hour ago", nil);
            }
        }
        case NSDateDifferenceTypeLessThan2Days: {
            NSInteger difference = [self relateDateComponentDifference];
            if (difference > 1) {
                NSDateFormatter *dateFormatter = [self dateFormatter];
                dateFormatter.dateFormat = @"dd MMM 'at' HH:mm";
                return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
            } else {
                NSDateFormatter *dateFormatter = [self dateFormatter];
                dateFormatter.dateFormat = @"HH:mm";
                return [NSString stringWithFormat:NSLocalizedString(@"Yesterday at %@", nil), [dateFormatter stringFromDate:self] ];
            }
        }
        case NSDateDifferenceTypeMoreThan2days: {
            NSDateFormatter *dateFormatter = [self dateFormatter];
            dateFormatter.dateFormat = @"dd MMM 'at' HH:mm";
            return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
        }
        default: {
            return @"Just Now";
        }
    }
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormat = nil;
    if (nil == dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    return dateFormat;
}

@end
