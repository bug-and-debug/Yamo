//
//  FilterSearchDTO.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterSearchDTO.h"
@import MTLModel_LOCExtensions;

@implementation FilterSearchDTO

- (instancetype)init {
    
    if (self = [super init]) {
        _priceFilter = 1;
    }
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{ @"latitude": @"lat",
                                                 @"longitude" : @"lon" }];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.mostPopular = [aDecoder decodeBoolForKey:@"mostPopular"];
        self.priceFilter = [aDecoder decodeIntegerForKey:@"priceFilter"];
        self.tagIds = [aDecoder decodeObjectForKey:@"tagIds"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeBool:self.mostPopular forKey:@"mostPopular"];
    [aCoder encodeInteger:self.priceFilter forKey:@"priceFilter"];
    [aCoder encodeObject:self.tagIds forKey:@"tagIds"];
    
}

@end
