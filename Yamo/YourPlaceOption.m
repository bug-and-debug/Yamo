//
//  YourPlaceOption.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceOption.h"

@implementation YourPlaceOption

- (instancetype)initWithType:(YourPlaceOptionType)type {
    
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

#pragma mark - Public Helper

+ (NSString *)stringForOptionType:(YourPlaceOptionType)type {
    
    switch (type) {
        case YourPlaceOptionTypeHome:
            return NSLocalizedString(@"Home", @"Your place option type Home");
        case YourPlaceOptionTypeWork:
            return NSLocalizedString(@"Work", @"Your place option type Home");
        default:
            return @"";
    }
}

@end
