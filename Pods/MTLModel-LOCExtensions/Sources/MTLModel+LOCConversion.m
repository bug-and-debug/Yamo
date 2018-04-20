//
//  MTLModel+Extensions.m
//
//  Created by Peter Su on 08/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MTLModel+LOCConversion.h"

@interface MTLModel ()

@end

@implementation MTLModel (LOCConversion)

+ (NSDictionary *)dictionaryMapping:(NSDictionary *)dictionaryMapping {
    return [self dictionaryIgnoringParameters:@[] dictionary:dictionaryMapping];
}

+ (NSDictionary *)dictionaryIgnoringParameters:(NSArray<NSString *> *)parameterNames dictionary:(NSDictionary *)dictionaryMapping {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    
    for (NSString *parameterName in parameterNames) {
        [dict removeObjectForKey:parameterName];
    }
    
    if (dictionaryMapping) {
        [dict addEntriesFromDictionary:dictionaryMapping];
    }
    
    return dict;
}

#pragma mark - Transformers

+ (MTLValueTransformer *)timestampToDateTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id date, BOOL *success, NSError *__autoreleasing *error) {
        if ([date isKindOfClass:NSNumber.class]) {
            NSNumber *dateNumber = (NSNumber *)date;
            return [NSDate dateWithTimeIntervalSince1970:([dateNumber doubleValue] / 1000)];
        }
        
        return [NSDate date];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000];
    }];
}

+ (MTLValueTransformer *)iso8601ToDateTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id date, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([date isKindOfClass:[NSString class]]) {
            NSDate *UTCDate = [[self sharedDateFormatter] dateFromString:date];
            
            return UTCDate; //[self currentDateToLocalTime:UTCDate];
        }
        
        return [NSDate date];
        
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        
        return [self getUTCFormateDate:date];
    }];
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *sharedDateFormatter = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDateFormatter = [NSDateFormatter new] ;
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [sharedDateFormatter setLocale:enUSPOSIXLocale];
        [sharedDateFormatter setTimeZone:timeZone];
        sharedDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    });
    
    return sharedDateFormatter ;
}

+ (NSString *)getUTCFormateDate:(NSDate *)localDate {
    NSString *dateString = [[self currentTimezoneDateFormatter] stringFromDate:localDate];
    return dateString;
}

+ (NSDateFormatter *)currentTimezoneDateFormatter
{
    static NSDateFormatter *currentTimezoneDateFormatter = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTimezoneDateFormatter = [NSDateFormatter new];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [currentTimezoneDateFormatter setLocale:enUSPOSIXLocale];
        [currentTimezoneDateFormatter setTimeZone:timeZone];
        [currentTimezoneDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    });
    
    return currentTimezoneDateFormatter ;
}

@end
