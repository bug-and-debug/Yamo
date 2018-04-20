//
//  NSDate+LOCCreation.m
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSDate+LOCCreation.h"
#import "Definitions.h"

@implementation NSDate (LOCCreation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateFromUtcDateString:(NSString *)utcString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [formatter dateFromString:utcString];
}

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithYearsFromNow:(NSInteger)years
{
    return [[NSDate date] dateByAddingYears:years];
}

+ (NSDate *)dateWithYearsBeforeNow:(NSInteger)years
{
    return [[NSDate date] dateBySubtractingYears:years];
}

+ (NSDate *)dateWithMonthsFromNow:(NSInteger)months
{
    return [[NSDate date] dateByAddingMonths:months];
}

+ (NSDate *)dateWithMonthsBeforeNow:(NSInteger)months
{
    return [[NSDate date] dateBySubtractingMonths:months];
}

+ (NSDate *)dateWithDaysFromNow: (NSInteger) days
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_secondsInOneDay * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithDaysBeforeNow: (NSInteger) days
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_secondsInOneDay * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_secondsInOneHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_secondsInOneHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + Date_secondsInOneMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - Date_secondsInOneMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)randomDate {
    NSTimeInterval period = (NSTimeInterval)arc4random_uniform(500000) - 250000;
    return [NSDate dateWithTimeIntervalSinceNow:period];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - date generation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
                           hours:(NSInteger)hours
                            days:(NSInteger)days
                          months:(NSInteger)months
                           years:(NSInteger)years
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    dateComponents.month = months;
    dateComponents.year = years;
    dateComponents.minute = minutes;
    dateComponents.hour = hours;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
                       months:(NSInteger)months
                        years:(NSInteger)years
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    dateComponents.month = months;
    dateComponents.year = years;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                         toDate:self
                                                        options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger) months
{
    return [self dateByAddingDays:0 months:months years:0];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)months
{
    return [self dateByAddingDays:0 months:-months years:0];
}

- (NSDate *)dateByAddingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:years];
}

- (NSDate *)dateBySubtractingYears:(NSInteger) years
{
    return [self dateByAddingDays:0 months:0 years:-years];
}

- (NSDate *)dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + Date_secondsInOneDay * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *)dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + Date_secondsInOneHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *)dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + Date_secondsInOneMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *)monthStartDate
{
    NSDate *monthStartDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                    startDate:&monthStartDate
                                     interval:NULL
                                      forDate:self];
    return monthStartDate;
}

- (NSDate *)dateAtStartOfDay
{
    NSDate *midnightDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                    startDate:&midnightDate
                                     interval:NULL
                                      forDate:self];
    return midnightDate;
}

@end
