//
//  NSDate+LOCStringRepresentation.m
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSDate+LOCStringRepresentation.h"

@implementation NSDate (LOCStringRepresentation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - string representation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)shortDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)shortTimedDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd/MM/yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)hourMinutesString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:self];
}

-(NSString *)utcDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

- (NSString *)summaryStringWithDateAndTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *suppliedDate = [calendar dateFromComponents:comps];
    
    for (int i = -1; i < 7; i++) {
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        
        NSDate *referenceDate = [calendar dateFromComponents:comps];
        
        NSInteger weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
            [formatter setDateFormat:@"HH:mm"];
            NSString *summary = [NSString stringWithFormat:@"Tomorrow, %@", [formatter stringFromDate:self]];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)	{
            [formatter setDateFormat:@"HH:mm"];
            NSString *summary = [NSString stringWithFormat:@"Today, %@", [formatter stringFromDate:self]];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            [formatter setDateFormat:@"HH:mm"];
            NSString *summary = [NSString stringWithFormat:@"Yesterday, %@", [formatter stringFromDate:self]];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            [formatter setDateFormat:@"HH:mm"];
            NSString *day = [[formatter weekdaySymbols] objectAtIndex:weekday];
            NSString *summary = [NSString stringWithFormat:@"%@, %@", day, [formatter stringFromDate:self]];
            return summary;
        }
    }
    
    [formatter setDateFormat:@"d MMM yyyy, HH:mm"];
    NSString *summary = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self]];
    
    return summary;
}

- (NSString *)summaryStringWithDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *suppliedDate = [calendar dateFromComponents:comps];
    
    for (int i = -1; i < 7; i++) {
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        [comps setDay:[comps day] - i];
        
        NSDate *referenceDate = [calendar dateFromComponents:comps];
        
        NSInteger weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
        
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
            NSString *summary = [NSString stringWithFormat:@"Tomorrow"];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0)	{
            NSString *summary = [NSString stringWithFormat:@"Today"];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            NSString *summary = [NSString stringWithFormat:@"Yesterday"];
            return summary;
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            NSString *day = [[formatter weekdaySymbols] objectAtIndex:weekday];
            NSString *summary = [NSString stringWithFormat:@"%@", day];
            return summary;
        }
    }
    
    [formatter setDateFormat:@"d MMM yyyy"];
    NSString *summary = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self]];
    
    return summary;
}

- (NSString *)shortDayString
{
    return [self dateStringWithFormat :@"EEE"];
}

- (NSString *)localisedDateAndTimeLongString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateAndTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateMediumString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)localisedDateShortString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateFormat = [formatter.dateFormat copy];
    
    if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"d"]) {
        formatter.dateFormat = @"dd-MM-YY";
    } else if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"m"]) {
        formatter.dateFormat = @"MM-dd-YY";
    }else if([[[dateFormat substringToIndex:1] lowercaseString]isEqualToString:@"y"]) {
        formatter.dateFormat = @"YY-MM-dd";
    }
    
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSString *)dateStringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSString *)relativeDateString
{
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [self timeIntervalSinceDate:now] * -1.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:units fromDate:self toDate:now options:0];
    
    NSString *relativeString;
    
    if (delta < 0) {
        relativeString = @"!n the future!";
    } else if (delta < 1 * MINUTE) {
        relativeString = (components.second == 1) ? @"One second ago" : [NSString stringWithFormat:@"%ld seconds ago",(long)components.second];
    } else if (delta < 2 * MINUTE) {
        relativeString =  @"a minute ago";
    } else if (delta < 45 * MINUTE) {
        relativeString = [NSString stringWithFormat:@"%ld minutes ago",(long)components.minute];
    } else if (delta < 90 * MINUTE) {
        relativeString = @"an hour ago";
    } else if (delta < 24 * HOUR) {
        relativeString = [NSString stringWithFormat:@"%ld hours ago",(long)components.hour];
    } else if (delta < 48 * HOUR) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"HH:mma"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        relativeString = [NSString stringWithFormat:@"yesterday at %@", [formatter stringFromDate:self]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateFormat:@"d MMM yyyy"];
        relativeString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self]];
    }
    
    return relativeString;
}

- (NSString *)relativeDateStringSkippingYesterdayCase
{
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [self timeIntervalSinceDate:now] * -1.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    NSDateComponents *components = [calendar components:units fromDate:self toDate:now options:0];
    
    NSString *relativeString;
    
    if (delta < 0) {
        relativeString = @"!n the future!";
    } else if (delta < 1 * MINUTE) {
        relativeString = (components.second == 1) ? @"One second ago" : [NSString stringWithFormat:@"%ld seconds ago",(long)components.second];
    } else if (delta < 2 * MINUTE) {
        relativeString =  @"a minute ago";
    } else if (delta < 45 * MINUTE) {
        relativeString = [NSString stringWithFormat:@"%ld minutes ago",(long)components.minute];
    } else if (delta < 90 * MINUTE) {
        relativeString = @"an hour ago";
    } else if (delta < 24 * HOUR) {
        relativeString = [NSString stringWithFormat:@"%ld hours ago",(long)components.hour];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateFormat:@"d MMM yyyy"];
        relativeString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self]];
    }
    
    return relativeString;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - names
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)nameOfMonth:(int)monthIndex;
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df monthSymbols] objectAtIndex:(monthIndex-1)];
}

+ (NSString *)nameOfDay:(int)dayIndex;
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df weekdaySymbols] objectAtIndex:(dayIndex-1)];
}

@end
