//
//  UserLocation.m
//  Yamo
//
//  Created by Mo Moosa on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation

@synthesize identifier;
@synthesize location;
@synthesize distance;
@synthesize bearing;

@synthesize colors;
@synthesize mapRelevance;
@synthesize parent;
@synthesize annotationView;


#pragma mark - ExploreMapAnnotation

- (void)updateWithNewerVersionOfAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[UserLocation class]]) {
        
        UserLocation *userLocation = (UserLocation *)annotation;
        
        self.mapRelevance = userLocation.mapRelevance;
    }
    
    self.location = annotation.location;
}

@end
