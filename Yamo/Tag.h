//
//  Tag.h
//  Yamo
//
//  Created by Hungju Lu on 10/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Tag : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate  * _Nonnull created;
@property (nonatomic, strong)  NSString * _Nullable hexColour;
@property (nonatomic, strong) NSString * _Nullable name;
@property (nonatomic) NSInteger priority;
@property (nonatomic, strong) NSDate * _Nonnull updated;
@property (nonatomic, strong) NSNumber * _Nonnull userUuid;
@property (nonatomic, strong) NSNumber * _Nonnull uuid;

@end
