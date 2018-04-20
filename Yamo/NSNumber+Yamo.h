//
//  NSNumber+ROM.h
//  RoundsOnMe
//
//  Created by Hungju Lu on 12/04/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KernValueStyle) {
    KernValueStyleRegular = 50
};

@interface NSNumber (Yamo)

+ (NSNumber *)kernValueWithStyle:(KernValueStyle)style fontSize:(CGFloat)fontSize;

@end
