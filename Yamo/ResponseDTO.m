//
//  ResponseDTO.m
//  Yamo
//
//  Created by Vlad Buhaescu on 15/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ResponseDTO.h"
@import MTLModel_LOCExtensions;

@implementation ResponseDTO

- (instancetype)initWithReadyState:(NSUInteger)readyState
                      responseText:(NSString*)responseText
                            status:(NSUInteger)status
                        statusText:(NSString*)statusText {

    if (self = [super init]) {
        _readyState = readyState;
        _responseText = responseText;
        _status = status;
        _statusText = statusText;
    }
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[]
                                   dictionary:@{}];
}

@end
