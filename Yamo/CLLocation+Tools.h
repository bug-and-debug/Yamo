//
//  CLLocation+Tools.h
//  Annotation
//
//  Created by Administrator on 19/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

@import UIKit;
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Tools)

- (CGFloat)bearingToLocation:(CLLocation *) destinationLocation;

@end
