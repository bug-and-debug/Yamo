//
//  UserSummary.h
//  Yamo
//
//  Created by Dario Langella on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface UserSummary : MTLModel <MTLJSONSerializing>

@property (nonatomic, nonnull) NSString *profileImageUrl;
@property (nonatomic, nonnull) NSString *username;
@property (nonatomic) BOOL facebookUser;
@property (nonatomic, strong)  NSNumber * _Nonnull uuid;
@property (nonatomic) BOOL following;

@end
