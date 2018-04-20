//
//  Route.m
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "Route.h"
@import MTLModel_LOCExtensions;
#import "RouteStep.h"
#import "Venue.h"

@implementation Route

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [self dictionaryIgnoringParameters:@[ @"didAddReturnAddress" ] dictionary:@{}];
}

+ (NSValueTransformer *)stepsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:RouteStep.class];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [self timestampToDateTransformer];
}

+ (NSValueTransformer *)updatedJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - Getter

- (BOOL)didAddReturnAddress {
    
    if (self.steps.count <= 1) {
        return NO;
    } else {
        
        return [self.steps.firstObject.venue.uuid isEqualToNumber:self.steps.lastObject.venue.uuid];
    }
}

@end
