//
//  LOCFormInvalidationReason.h
//  GenericLogin
//
//  Created by Peter Su on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

typedef NS_ENUM(NSUInteger, LOCFormValidationState) {
    LOCFormValidationStateValid,
    LOCFormValidationStateInvalid,
    LOCFormValidationStateStringMustHaveInput,
    LOCFormValidationStateStringTooShort,
    LOCFormValidationStateStringTooLong,
    LOCFormValidationStateInvalidCharacters,
    LOCFormValidationStateInvalidEmail
};
