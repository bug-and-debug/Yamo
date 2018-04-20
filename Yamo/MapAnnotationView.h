//
//  MapAnnotationView.h
//  mapPlaying
//
//  Created by Dario Langella on 06/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <MapKit/MapKit.h>
@class MapAnnotationObject;

@interface MapAnnotationView : MKAnnotationView

- (instancetype)initWithAnnotation:(MapAnnotationObject *)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
