//
//  RoutePlannerDecorationView.m
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 27/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerDecorationView.h"
#import "UIColor+Yamo.h"

@implementation RoutePlannerDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yamoDimGray];
    }
    
    return self;
}

@end
