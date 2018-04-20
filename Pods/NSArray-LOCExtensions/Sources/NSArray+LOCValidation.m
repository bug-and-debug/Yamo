//
//  NSArray+LOCValidation.m
//  NSArray-LOCExtensions
//
//  Created by Hungju Lu on 18/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSArray+LOCValidation.h"
@import NSObject_LOCExtensions;

@implementation NSArray (LOCValidation)

#pragma mark - validation
- (BOOL)isValidArray
{
    return (self.isValidObject && self.count > 0);
}

@end
