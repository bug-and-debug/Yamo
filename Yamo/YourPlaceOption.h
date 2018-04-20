//
//  YourPlaceOption.h
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YourPlaceOptionType) {
    YourPlaceOptionTypeHome,
    YourPlaceOptionTypeWork
};

@interface YourPlaceOption : NSObject

@property (nonatomic, readonly) YourPlaceOptionType type;

- (instancetype)initWithType:(YourPlaceOptionType)type;

#pragma mark - Helper

+ (NSString *)stringForOptionType:(YourPlaceOptionType)type;

@end
