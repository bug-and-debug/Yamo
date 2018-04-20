//
//  RouteObject.h
//  Yamo
//
//  Created by Dario Langella on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface RouteSummary : MTLModel <MTLJSONSerializing>

@property (nonatomic, nonnull) NSString *name;
@property (nonatomic) BOOL popularRoute;
@property (nonatomic, nonnull) NSDate *created;
@property (nonatomic, strong)  NSNumber * _Nonnull uuid;

@end
