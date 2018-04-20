//
//  MapPlaceAnnotationObject.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapPlaceAnnotationObject.h"

@implementation MapPlaceAnnotationObject

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location
                        isSource:(BOOL)isSource {
    
    if (self = [super init]) {
     
        _annotationCoordinate = location;
        _isSource = isSource;
    }
    
    return self;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return self.annotationCoordinate;
}

- (NSString *)title {
    
    return @"";
}

- (NSString *)subtitle {
    
    return @"";
}

@end
