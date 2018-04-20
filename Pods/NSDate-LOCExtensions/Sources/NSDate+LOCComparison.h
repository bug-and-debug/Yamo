//
//  NSDate+LOCComparison.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LOCComparison)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comparison
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEqualToDateIgnoringTime: (NSDate *)aDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isThisMonth;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isSameDayAsDate:(NSDate *)aDate;
- (BOOL)isSameWeekAsDate: (NSDate *)aDate;
- (BOOL)isSameMonthAsDate: (NSDate *)aDate;
- (BOOL)isSameYearAsDate: (NSDate *)aDate;
- (BOOL)isEarlierThanDate: (NSDate *)aDate;
- (BOOL)isEarlierThanDateIgnoringTime:(NSDate *)aDate;
- (BOOL)isLaterThanDate: (NSDate *)aDate;
- (BOOL)isDateOlderThanMinutes:(NSInteger)minutes;
- (BOOL)isDateOlderThanHours:(NSInteger)hours;
- (BOOL)isDateOlderThanDays:(NSInteger)days;
- (BOOL)isDateOlderThanWeeks:(NSInteger)weeks;
- (BOOL)isInFuture;
- (BOOL)isInPast;
- (BOOL)isWorkday;
- (BOOL)isWeekend;

@end
