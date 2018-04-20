//
//  PremiumModel.m
//  Locassa
//
//  Abstract:
//  Model class to represent a product/purchase.
//
//  Created by Boris Yurkevich on 09/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PremiumModel.h"

@implementation PremiumModel

-(PremiumModel *)init {
    self = [self initWithName:nil elements:@[]];
    return self;
}

-(PremiumModel *)initWithName:(NSString *)name
                     elements:(NSArray *)elements {
    self = [super init];
    if(self != nil) {
        _categoryName = name;
        _elements = elements;
    }
    return self;
}

@end
