//
//  CardReplyDTO.m
//  Yamo
//
//  Created by Vlad Buhaescu on 20/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "CardReplyDTO.h"
@import MTLModel_LOCExtensions;

@implementation CardReplyDTO

- (instancetype)initWithArtWorkID:(NSInteger)artWorkId
                           rating:(NSInteger)rating {

    if (self = [super init]) {
        _artWorkId = artWorkId;
        _rating = rating;
    }
    return self;
    
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{}];
}

@end
