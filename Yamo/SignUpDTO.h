//
//  SignUpDTO.h
//  RoundsOnMe
//
//  Created by Peter Su on 31/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
@import MTLModel_LOCExtensions;

@interface SignUpDTO : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *imageContent;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                         password:(NSString *)password
                     imageContent:(NSString *)imageContent;

@end
