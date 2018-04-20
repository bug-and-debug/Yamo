//
//  RouteDTO.h
//  Yamo
//
//  Created by Peter Su on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@class RouteStepDTO;
@class Route;

@interface RouteDTO : MTLModel <MTLJSONSerializing>

- (instancetype)initWithRouteName:(NSString *)routeName route:(Route *)route;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<RouteStepDTO *> *steps;

@end
