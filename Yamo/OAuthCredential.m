//
//  OAuthCredential.m
//  RoundsOnMe
//
//  Created by Peter Su on 30/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "OAuthCredential.h"
@import MTLModel_LOCExtensions;

@implementation OAuthCredential

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{@"accessToken" : @"access_token",
                                                @"refreshToken" : @"refresh_token",
                                                @"expiresIn" : @"expires_in",
                                                @"tokenType" : @"token_type"
                                                }];
}

@end
