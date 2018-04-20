//
//  PasswordValidator.h
//  Yamo
//
//  Created by Hungju Lu on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import LOCGenericLogin;

@interface PasswordValidator : NSObject

+ (LOCFormValidationState)validatePassword:(NSString *)password;

@end
