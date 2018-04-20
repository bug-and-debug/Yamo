//
//  ValidateFormView.m
//  RoundsOnMe
//
//  Created by Peter Su on 18/04/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "ValidateFormView.h"

@implementation ValidateFormView

+ (LOCFormValidationState)validateInputString:(NSString *)input forKey:(NSString *)key {
    
    // Custom validation rules for Rounds on me passwords
    if ([key isEqualToString:LOCFormViewConfirmPasswordKey] || [key isEqualToString:LOCFormViewPasswordKey]) {
        
        return [self roundsOnMeValidatePassword:input];
    } else {
    
        return [super validateInputString:input forKey:key];
    }
}

#pragma mark - Local validation rules

+ (LOCFormValidationState)roundsOnMeValidatePassword:(NSString *)password {
    
    if ([self inputUnderMinLength:password]) {
        return LOCFormValidationStateStringTooShort;
    }
    
    return LOCFormValidationStateValid;
}

+ (BOOL)inputUnderMinLength:(NSString *)input {
    
    return input.length < 6;
}

@end
