//
//  NSDate+LOCRelation.h
//  NSDate-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSDateDifferenceType) {
    NSDateDifferenceTypeJustNow,
    NSDateDifferenceTypeLessThanAnHour,
    NSDateDifferenceTypeLessThanADay,
    NSDateDifferenceTypeLessThan2Days,
    NSDateDifferenceTypeMoreThan2days,
    NSDateDifferenceTypeInTheFuture,
    NSDateDifferenceTypeUnknown
};

@interface NSDate (LOCRelation)

- (NSDateDifferenceType)relativeDateDifference;
- (NSInteger)relateDateComponentDifference;
- (NSString *)timestampForDifferenceType:(NSDateDifferenceType)differenceType;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - misc
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
