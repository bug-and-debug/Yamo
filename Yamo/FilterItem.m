//
//  FilterItem.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterItem.h"

@implementation FilterItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.filterName = [aDecoder decodeObjectForKey:@"filterName"];
        self.filterDescription = [aDecoder decodeObjectForKey:@"filterDescription"];
        self.sourceId = [aDecoder decodeObjectForKey:@"sourceId"];
        self.filterOptions = [aDecoder decodeObjectForKey:@"filterOptions"];
        self.filterOptionsDisplayNames = [aDecoder decodeObjectForKey:@"filterOptionsDisplayNames"];
        self.filterSelection = [aDecoder decodeObjectForKey:@"filterSelection"];
        self.multipleSelection = [aDecoder decodeBoolForKey:@"multipleSelection"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.filterName forKey:@"filterName"];
    [aCoder encodeObject:self.filterDescription forKey:@"filterDescription"];
    [aCoder encodeObject:self.sourceId forKey:@"sourceId"];
    [aCoder encodeObject:self.filterOptions forKey:@"filterOptions"];
    [aCoder encodeObject:self.filterOptionsDisplayNames forKey:@"filterOptionsDisplayNames"];
    [aCoder encodeObject:self.filterSelection forKey:@"filterSelection"];
    [aCoder encodeBool:self.multipleSelection forKey:@"multipleSelection"];
}

@end
