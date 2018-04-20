//
//  TagGroup.h
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Tag.h"

@interface TagGroup : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <Tag *> *tags;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *uuid;

@end
