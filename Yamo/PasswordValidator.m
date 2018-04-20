//
//  PasswordValidator.m
//  Yamo
//
//  Created by Hungju Lu on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PasswordValidator.h"

static NSInteger const PasswordMinLength = 7;

@implementation PasswordValidator

+ (LOCFormValidationState)validatePassword:(NSString *)password {
    
    if (password.length < PasswordMinLength) {
        return LOCFormValidationStateStringTooShort;
    }
    
    return LOCFormValidationStateValid;
}

@end
