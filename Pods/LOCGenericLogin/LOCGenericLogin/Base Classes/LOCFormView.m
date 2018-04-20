//
//  LOCFormView.m
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFormView.h"

NSString * const LOCFormViewEmailKey = @"LOCFormViewEmailKey";
NSString * const LOCFormViewPasswordKey = @"LOCFormViewPasswordKey";
NSString * const LOCFormViewConfirmPasswordKey = @"LOCFormViewConfirmPasswordKey";
NSString * const LOCFormViewUsernameKey = @"LOCFormViewUsernameKey";
NSString * const LOCFormViewFirstNameKey = @"LOCFormViewFirstNameKey";
NSString * const LOCFormViewLastNameKey = @"LOCFormViewLastNameKey";
NSString * const LOCFormViewPhoneNumberKey = @"LOCFormViewPhoneNumberKey";

@implementation LOCFormView

- (NSDictionary *)valuesForForm {
    
    NSMutableDictionary *valueDictionary = [NSMutableDictionary new];
    
    for (UITextField *textField in self.formTextFields) {
        [valueDictionary setObject:textField.text forKey:textField.LOCLoginFormKey];
    }
    
    return valueDictionary;
}

+ (LOCFormValidationState)validateInputString:(NSString *)input forKey:(NSString *)key {
    
    if ([key isEqualToString:LOCFormViewEmailKey]) {
        return [self validateEmail:input];
    } else if ([key isEqualToString:LOCFormViewConfirmPasswordKey] || [key isEqualToString:LOCFormViewPasswordKey]) {
        return [self validatePassword:input];
    } else if ([key isEqualToString:LOCFormViewFirstNameKey] || [key isEqualToString:LOCFormViewLastNameKey]) {
        return [self validateNameInput:input];
    } else if (key.length > 0) {
        return [self validateInput:input];
    }
    
    return LOCFormValidationStateValid;
}

#pragma mark - Validation text for key

+ (LOCFormValidationState)validateEmail:(NSString *)email {
    
    if (![self inputIsValidEmail:email]) {
        return LOCFormValidationStateInvalidEmail;
    }
    
    return LOCFormValidationStateValid;
}

+ (LOCFormValidationState)validatePassword:(NSString *)password {
    
    if ([self inputUnderMinLength:password]) {
        return LOCFormValidationStateStringTooShort;
    }

    return LOCFormValidationStateValid;
}

+ (LOCFormValidationState)validateNameInput:(NSString *)name {
    
    if ([self inputUnderNameMinLength:name]) {
        return LOCFormValidationStateStringTooShort;
    }
    
    if ([self inputExceedsNameMaxLength:name]) {
        return LOCFormValidationStateStringTooLong;
    }
    
    return LOCFormValidationStateValid;
}

+ (LOCFormValidationState)validateInput:(NSString *)input {
    
    if (![self inputHasInput:input]) {
        return LOCFormValidationStateStringMustHaveInput;
    }
    
    return LOCFormValidationStateValid;
}

#pragma mark - Validators

+ (BOOL)inputExceedsMaxLength:(NSString *)input {
    
    return input.length > LOCFormViewDefaultMaxLength;
}

+ (BOOL)inputUnderNameMinLength:(NSString *)input {
    
    return input.length < LOCFormViewDefaultNameMinLength;
}

+ (BOOL)inputExceedsNameMaxLength:(NSString *)input {
    
    return input.length > LOCFormViewDefaultNameMaxLength;
}

+ (BOOL)inputUnderMinLength:(NSString *)input {
    
    return input.length < LOCFormViewDefaultPasswordMinLength;
}

+ (BOOL)inputHasInput:(NSString *)input {
    
    return input.length > 0;
}

+ (BOOL)inputIsValidEmail:(NSString *)input {
    
    if (!(input && input.length > 0))
    {
        return NO;
    }
    
    NSString *emailRegularExpression =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegularExpression];
    return [regExPredicate evaluateWithObject:input.lowercaseString];
}

@end
