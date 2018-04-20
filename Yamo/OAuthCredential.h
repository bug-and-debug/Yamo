//
//  OAuthCredential.h
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OAuthCredential : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSNumber *expiresIn;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *tokenType;

@end
