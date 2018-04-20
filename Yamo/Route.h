//
//  Route.h
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@class RouteStep;

@interface Route : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *counter;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<RouteStep *> *steps;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *uuid;

@property (nonatomic, readonly) BOOL didAddReturnAddress;

@end
