//
//  EditProfileDTO.m
//  Yamo
//
//  Created by Vlad Buhaescu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "EditProfileDTO.h"
@import MTLModel_LOCExtensions;

@implementation EditProfileDTO

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            nickname:(NSString *)nickname
                  nickNameEnabled:(BOOL)nickNameEnabled
                             city:(NSString *)city
                     imageContent:(NSString *)profileImageContent
                          visible:(BOOL)visible {
    
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
        _nickname = nickname;
        _nickNameEnabled = nickNameEnabled;
        _city = city;
        _profileImageContent = profileImageContent;
        _visible = visible;
    }
    
    return self;
    
}
#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{}];
}

//+ (NSDictionary *)dictionaryIgnoringParameters:(NSArray<NSString *> *)parameterNames dictionary:(NSDictionary *)dictionaryMapping {
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
//    
//    for (NSString *parameterName in parameterNames) {
//        [dict removeObjectForKey:parameterName];
//    }
//    
//    if (dictionaryMapping) {
//        [dict addEntriesFromDictionary:dictionaryMapping];
//    }
//    
//    return dict;
//}


@end
