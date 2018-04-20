//
//  NSDate+LOCStringRepresentation.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LOCStringRepresentation)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - string representation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)shortDateString;
- (NSString *)shortTimedDateString;
- (NSString *)hourMinutesString;
- (NSString *)utcDateString;
- (NSString *)shortDayString;
- (NSString *)summaryStringWithDateAndTime;
- (NSString *)summaryStringWithDate;
- (NSString *)localisedDateAndTimeLongString;
- (NSString *)localisedDateAndTimeString;
- (NSString *)localisedDateMediumString;
- (NSString *)localisedDateShortString;
- (NSString *)timeString;
- (NSString *)dateStringWithFormat:(NSString *)format;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
- (NSString *)relativeDateString;
- (NSString *)relativeDateStringSkippingYesterdayCase;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - data
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)nameOfMonth:(int)monthIndex;
+ (NSString *)nameOfDay:(int)dayIndex;

@end
