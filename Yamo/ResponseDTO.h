//
//  ResponseDTO.h
//  Yamo
//
//  Created by Vlad Buhaescu on 15/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ResponseDTO : MTLModel  <MTLJSONSerializing>

@property  NSUInteger readyState;
@property (nonatomic, strong) NSString *responseText;
@property  NSUInteger status;
@property (nonatomic, strong) NSString *statusText;

- (instancetype)initWithReadyState:(NSUInteger)readyState
                      responseText:(NSString*)responseText
                            status:(NSUInteger)status
                        statusText:(NSString*)statusText;

@end
