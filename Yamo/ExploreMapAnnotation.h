//
//  ExploreMapAnnotation.h
//  Yamo
//
//  Created by Mo on 20/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import CoreLocation;

@class ExploreMapAnnotationView;

@protocol ExploreMapAnnotation <NSObject>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) CGFloat mapRelevance;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) CGFloat bearing;
@property (nonatomic) CGFloat distance;
@property (nonatomic) id<ExploreMapAnnotation> parent;
@property (nonatomic, strong) ExploreMapAnnotationView *annotationView;

// TODO: We need to find a way to removing the annotation in the C library instead of update the existing ones here
- (void)updateWithNewerVersionOfAnnotation:(id<ExploreMapAnnotation>)annotation;

@end

