//
//  MediumObject.h
//  Yamo
//
//  Created by Dario Langella on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Medium : MTLModel <MTLJSONSerializing>

@property (nonatomic, nonnull) NSString *imageUrl;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nonnull) NSDate *created;
@property (nonatomic, nonnull) NSDate *updated;
@property (nonatomic, strong)  NSNumber * _Nonnull uuid;

@end
