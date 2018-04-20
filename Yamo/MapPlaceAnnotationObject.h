//
//  MapPlaceAnnotationObject.h
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapPlaceAnnotationObject : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D annotationCoordinate;
@property (nonatomic) BOOL isSource;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location
                        isSource:(BOOL)isSource;

@end
