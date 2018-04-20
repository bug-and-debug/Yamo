//
//  MapAnnotationObject.h
//  mapPlaying
//
//  Created by Dario Langella on 06/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapAnnotationObject : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D locationPin;
@property (copy, nonatomic) NSString *titleMapAnnotation;
@property (copy, nonatomic) NSString *subtitleMapAnnotation;
@property (copy, nonatomic) NSString *pinTitle;
@property (copy, nonatomic) UIColor *pinColor;
@property (nonatomic) BOOL preferDark;
@property (nonatomic) CGRect pinFrame;
@property (retain, nonatomic) UIImageView *imagePin;
@property (retain, nonatomic) UIView *viewForPin;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                     pinFrame:(CGRect)pinFrame
                     pinTitle:(NSString *)pinTitle
                     pinColor:(UIColor *)pinColor
                   preferDark:(BOOL)preferDark
                  andLocation:(CLLocationCoordinate2D)location;

@end
