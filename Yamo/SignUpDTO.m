//
//  SignUpDTO.m
//  RoundsOnMe
//
//  Created by Peter Su on 31/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "SignUpDTO.h"

@implementation SignUpDTO

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                         password:(NSString *)password
                     imageContent:(NSString *)imageContent {
    
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
        _email = email;
        _password = password;
        _imageContent = imageContent;
    }
    
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{}];
}

@end
