//
//  NSDate+LOCComparison.m
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSDate+LOCComparison.h"
#import "NSDate+LOCCreation.h"
#import "NSDate+LOCTimespan.h"
#import "Definitions.h"

@implementation NSDate (LOCComparison)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comparison
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEqualToDateIgnoringTime: (NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isEarlierThanDateIgnoringTime:(NSDate *)aDate
{
    return (abs((int)[NSDate daysBetweenDate:self andDate:aDate]) > 0);
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameDayAsDate:(NSDate *)aDate
{
    NSDateComponents *components = [CURRENT_CALENDAR components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
    NSDate *compareDate = [CURRENT_CALENDAR dateFromComponents:components];
    components = [CURRENT_CALENDAR components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *currentDate = [CURRENT_CALENDAR dateFromComponents:components];
    
    return [compareDate isEqualToDate:currentDate];
}

- (BOOL)isSameWeekAsDate: (NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    return (fabs([self timeIntervalSinceDate:aDate]) < Date_secondsInOneWeek);
}

- (BOOL)isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_secondsInOneWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_secondsInOneWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate: (NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate: (NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isThisYear
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate: (NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate: (NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isDateOlderThanMinutes:(NSInteger)minutes
{
    return (fabs([self timeIntervalSinceNow]) > Date_secondsInOneMinute*minutes);
}

- (BOOL)isDateOlderThanHours:(NSInteger)hours
{
    return (fabs([self timeIntervalSinceNow]) > Date_secondsInOneHour*hours);
}

- (BOOL)isDateOlderThanDays:(NSInteger)days
{
    return (fabs([self timeIntervalSinceNow]) > Date_secondsInOneDay*days);
}

- (BOOL)isDateOlderThanWeeks:(NSInteger)weeks
{
    return (fabs([self timeIntervalSinceNow]) > Date_secondsInOneWeek*weeks);
}

- (BOOL)isInFuture
{
    return [self isLaterThanDate:[NSDate date]];
}

- (BOOL)isInPast
{
    return [self isEarlierThanDate:[NSDate date]];
}

- (BOOL)isWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isWorkday
{
    return ![self isWeekend];
}

@end
