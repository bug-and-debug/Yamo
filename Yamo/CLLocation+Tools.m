//
//  CLLocation+Tools.m
//  Annotation
//
//  Created by Administrator on 19/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

#import "CLLocation+Tools.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

@implementation CLLocation (Tools)

- (CGFloat)bearingToLocation:(CLLocation *) destinationLocation {
    
    CGFloat lat1 = DegreesToRadians(self.coordinate.latitude);
    CGFloat lon1 = DegreesToRadians(self.coordinate.longitude);
    
    CGFloat lat2 = DegreesToRadians(destinationLocation.coordinate.latitude);
    CGFloat lon2 = DegreesToRadians(destinationLocation.coordinate.longitude);

    CGFloat radiansBearing = atan2(sin(lon2 - lon1) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1));
    return radiansBearing;
}

@end
