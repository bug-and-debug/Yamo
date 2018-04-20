//
//  MTLModel+Extensions.h
//
//  Created by Peter Su on 08/01/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import Mantle;

@interface MTLModel (LOCConversion)

+ (NSDictionary *)dictionaryMapping:(NSDictionary *)dictionaryMapping;
+ (NSDictionary *)dictionaryIgnoringParameters:(NSArray<NSString *> *)parameterNames dictionary:(NSDictionary *)dictionaryMapping;

#pragma mark - Transformers

+ (MTLValueTransformer *)timestampToDateTransformer;

+ (MTLValueTransformer *)iso8601ToDateTransformer;

+ (NSString *)getUTCFormateDate:(NSDate *)localDate;

@end
