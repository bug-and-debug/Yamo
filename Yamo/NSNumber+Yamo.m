//
//  NSNumber+ROM.m
//  RoundsOnMe
//
//  Created by Hungju Lu on 12/04/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "NSNumber+Yamo.h"

@implementation NSNumber (Yamo)

+ (NSNumber *)kernValueWithStyle:(KernValueStyle)style fontSize:(CGFloat)fontSize {
    return @(fontSize * style / 1000);
}

@end
