//
//  Response.h
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Response : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *readyState;
@property (nonatomic) NSString *responseText;
@property (nonatomic) NSNumber *status;
@property (nonatomic) NSString *statusText;

@end
