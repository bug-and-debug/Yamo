//
//  NSDate+LOCCreation.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LOCCreation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithYear:(NSInteger)year
                    month:(NSInteger)month
                      day:(NSInteger)day;
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute;
+ (NSDate *)dateFromUtcDateString:(NSString *)utcString;
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithYearsFromNow:(NSInteger)years;
+ (NSDate *)dateWithYearsBeforeNow:(NSInteger)years;
+ (NSDate *)dateWithMonthsFromNow:(NSInteger)months;
+ (NSDate *)dateWithMonthsBeforeNow:(NSInteger)months;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;
+ (NSDate *)randomDate;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date generation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
                           hours:(NSInteger)hours
                            days:(NSInteger)days
                          months:(NSInteger)months
                           years:(NSInteger)years;
- (NSDate *)dateByAddingDays:(NSInteger)days
                       months:(NSInteger)months
                        years:(NSInteger)years;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateBySubtractingYears:(NSInteger)months;
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateAtStartOfDay;
- (NSDate *)monthStartDate;

@end
