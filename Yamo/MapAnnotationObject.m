//
//  MapAnnotationObject.m
//  mapPlaying
//
//  Created by Dario Langella on 06/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapAnnotationObject.h"
#import "MapAnnotationView.h"

@implementation MapAnnotationObject

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                     pinFrame:(CGRect)pinFrame
                     pinTitle:(NSString *)pinTitle
                     pinColor:(UIColor *)pinColor
                    preferDark:(BOOL)preferDark
                  andLocation:(CLLocationCoordinate2D)location {
    
    self= [super init];
    
    if (self) {
        
        self.titleMapAnnotation = title;
        self.subtitleMapAnnotation = subtitle;
        self.pinTitle = pinTitle;
        self.locationPin = location;
        self.pinColor = pinColor;
        self.preferDark = preferDark;
        self.pinFrame = pinFrame;
    }
    
    return self;
    
}


- (CLLocationCoordinate2D)coordinate {
    
    return self.locationPin;
}

- (NSString *)title {
    
    return self.titleMapAnnotation;
}

- (NSString *)subtitle {
    
    return self.subtitleMapAnnotation;
}


@end
