//
//  NSDate+LOCTimespan.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LOCTimespan)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - timespan
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)minutesBetweenDate:(NSDate*)fromDateTime
                        andDate:(NSDate*)toDateTime;
+ (NSInteger)hoursBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime
                     andDate:(NSDate*)toDateTime;
+ (NSInteger)weeksBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
+ (NSInteger)monthsBetweenDate:(NSDate*)fromDateTime
                       andDate:(NSDate*)toDateTime;
+ (NSInteger)yearsBetweenDate:(NSDate*)fromDateTime
                      andDate:(NSDate*)toDateTime;
- (long long)timestampMiliseconds;

@end
