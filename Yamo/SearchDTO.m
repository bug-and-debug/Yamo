//
//  SearchDTO.m
//  Yamo
//
//  Created by Peter Su on 09/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SearchDTO.h"
@import MTLModel_LOCExtensions;

@implementation SearchDTO

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude
                        distance:(double)distanceMiles
                    searchString:(NSString *)searchString {
    
    if (self = [super init]) {
        
        _latitude = latitude;
        _longitude = longitude;
        _search = searchString;
        _miles = distanceMiles;
    }
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{ @"latitude": @"lat",
                                                 @"longitude" : @"lon" }];
}

@end
