//
//  NSDate+LOCDateData.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LOCDateData)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)minutesSinceMidnight;
- (NSUInteger)numberOfDaysInMonth;
- (NSUInteger)weekday;
- (NSUInteger)nearestHour;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)seconds;
- (NSUInteger)day;         // e.g. monday = 1
- (NSUInteger)month;       // e.g. January = 1
- (NSUInteger)week;
- (NSUInteger)nthWeekday;  // e.g. 2nd Tuesday of the month == 2
- (NSUInteger)year;
- (NSInteger)minutesAfterDate: (NSDate *)aDate;
- (NSInteger)minutesBeforeDate: (NSDate *)aDate;
- (NSInteger)hoursAfterDate: (NSDate *)aDate;
- (NSInteger)hoursBeforeDate: (NSDate *)aDate;
- (NSInteger)daysAfterDate: (NSDate *)aDate;
- (NSInteger)daysBeforeDate: (NSDate *)aDate;
- (NSInteger)weeksAfterDate: (NSDate *)aDate;
- (NSInteger)weeksBeforeDate: (NSDate *)aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

@end
