//
//  EditProfileDTO.h
//  Yamo
//
//  Created by Vlad Buhaescu on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface EditProfileDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) BOOL nickNameEnabled;
@property (nonatomic, strong) NSString *profileImageContent;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) BOOL visible;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            nickname:(NSString *)nickname
                  nickNameEnabled:(BOOL)nickNameEnabled
                             city:(NSString *)city
                     imageContent:(NSString *)profileImageContent
                          visible:(BOOL)visible;

@end
