//
//  MTLModel+Mock.m
//
//  Created by Peter Su on 17/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MTLModel+LOCMock.h"
@import NSDate_LOCExtensions;

@implementation MTLModel (LOCMock)

#pragma mark - Random Generators

+ (NSNumber *)randomNSNumber {
    return [NSNumber numberWithInt:(arc4random() % 100)];
}

+ (BOOL)randomBOOL {
    return (arc4random() % 2) > 1 ? YES : NO;
}

+ (NSString *)randomStringWithLength:(NSInteger)len {
    NSString const *letters = @" .abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

+ (NSString *)randomName {
    NSArray *locationsArray = @[ @"Adam",
                                 @"Bob",
                                 @"Carla",
                                 @"Donna",
                                 @"Eve" ];
    
    
    return [locationsArray objectAtIndex:(arc4random() % [locationsArray count])];
}

+ (NSString *)randomSurname {
    NSArray *locationsArray = @[ @"Brown",
                                 @"Smith",
                                 @"Johnson",
                                 @"Shedd",
                                 @"Zellers" ];
    
    
    return [locationsArray objectAtIndex:(arc4random() % [locationsArray count])];
}

+ (NSString *)randomLocation {
    NSArray *locationsArray = @[ @"London",
                                 @"Manchester",
                                 @"Liverpool",
                                 @"Bristol",
                                 @"Birmingham" ];
    
    
    return [locationsArray objectAtIndex:(arc4random() % [locationsArray count])];
}

+ (long)randomLatitude {
    CGFloat londonLat = 51.5200;
    
    float random = (float)(arc4random() % 99);
    return (londonLat + (random / 1000));
}

+ (long)randomLongitude {
    
    CGFloat londonLon = -0.11586;
    float random = (float)(arc4random() % 99);
    return (londonLon + (random / 1000));
}

+ (NSString *)randomVideoURL {
    NSArray *videoURLList = @[ @"",
                               @"",
                               @"",
                               @"https://www.youtube.com/watch?v=F_9kWxyv9PY",
                               @"https://www.youtube.com/watch?v=F_9kWxyv9PX"];
    
    return [videoURLList objectAtIndex:(arc4random() % [videoURLList count])];
}

+ (NSString *)randomImageURL {
    NSArray *imageURLList = @[ @"",
                               @"",
                               @"https://i.ytimg.com/vi/yaqe1qesQ8c/maxresdefault.jpg",
                               @"https://www.nerdist.com/wp-content/uploads/2014/02/Beta-Test-NerdMelt-Showroom.jpg"];
    
    return [imageURLList objectAtIndex:(arc4random() % [imageURLList count])];
}

+ (NSDate *)randomDate {
    NSInteger random = arc4random() % 12;
    if (random == 0) {
        return [NSDate dateWithMinutesBeforeNow:0];
    } else if (random == 1) {
        return [NSDate dateWithMinutesBeforeNow:1];
    } else if (random == 2) {
        return [NSDate dateWithMinutesBeforeNow:2];
    } else if (random == 3) {
        return [NSDate dateWithMinutesBeforeNow:59];
    } else if (random == 4) {
        return [NSDate dateWithMinutesBeforeNow:61];
    } else if (random == 5) {
        return [NSDate dateWithMinutesBeforeNow:120];
    } else if (random == 6) {
        return [NSDate dateWithMinutesBeforeNow:(60 * 23) + 59];
    } else if (random == 7) {
        return [NSDate dateWithHoursBeforeNow:24];
    } else if (random == 8) {
        return [NSDate dateWithHoursBeforeNow:30];
    } else if (random == 9) {
        return [NSDate dateWithHoursBeforeNow:48];
    } else if (random == 10) {
        return [NSDate dateWithHoursBeforeNow:72];
    }
    return [NSDate randomDate];
}

@end
