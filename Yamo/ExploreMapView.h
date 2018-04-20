//
//  ExploreMapView.h
//  Annotation
//
//  Created by Administrator on 18/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

@import UIKit;
#import <CoreLocation/CoreLocation.h>
#import "TBQuadTree.h"
#import "ExploreMapUserAnnotationView.h"

@class ExploreMapAnnotationView;
@class LOAnnotationTree;
@class UserLocation;

@class ExploreMapView;

@protocol RoutePlannerInterface;
@protocol LOMapViewDelegate<NSObject>

@required

- (ExploreMapAnnotationView *)mapView:(ExploreMapView *)mapView viewForAnnotation:(id<ExploreMapAnnotation>)annotation;

@optional

- (void)mapView:(ExploreMapView *)mapView didSelectAnnotation:(id<ExploreMapAnnotation>)annotation;
- (void)mapView:(ExploreMapView *)mapView didDeselectAnnotation:(id<ExploreMapAnnotation>)annotation;
- (void)mapViewDidChangeScale:(ExploreMapView *)mapView;
- (void)mapViewDidChangeRotation:(ExploreMapView *)mapView;
- (void)mapViewDidChangeRegion:(ExploreMapView *)mapView;
- (void)mapViewWillChangeRegion:(ExploreMapView *)mapView;
- (void)mapViewDidFinishChangingScale:(ExploreMapView *)mapView;
- (void)mapViewShouldUpdateDataWithLocation:(CLLocationCoordinate2D)coordinate shouldClearCache:(BOOL)shouldClearCache;

@end

@interface ExploreMapView : UIView {
    UIView *markerContainer;
    NSMutableArray *annotations;
    NSMutableArray *currentAnnotations;
    NSMutableArray *reusableAnnotationViews;
    CLLocation *currentLocation;
    CLLocation *panLocation;
    CADisplayLink *displayLink;
    CGFloat snapshotScale;
    CGFloat lastScale;
    CGFloat snapshotAngle;
    NSArray *clusterSort;
    TBBoundingBox world;
    BOOL isPanning;
    BOOL isZooming;
    BOOL isRotating;
    BOOL isSelectedLocation;
}

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) CGFloat scaleMeters;
@property (nonatomic) BOOL isSelectedLocation;
@property (nonatomic, assign) id<LOMapViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat angle;
@property (nonatomic, readonly) UserLocation *userLocation;
@property (nonatomic, readonly) ExploreMapUserAnnotationView *userLocationView;
@property (nonatomic, readonly) CGFloat zoomLevel;

- (ExploreMapAnnotationView *)dequeueReusableAnnotation;
- (void)addAnnotation:(id<ExploreMapAnnotation>)annotation;
- (void)selectAnnotation:(id<ExploreMapAnnotation>)annotation;
- (void)deselectAllAnnotations;
- (void)beginUpdate;
- (void)endUpdate;
- (void)moveToCurrentUserLocationAnimated:(BOOL)animated;
- (void)removeAllAnnotations;

- (void)resetToUsersPhysicalLocation;
- (void)updateMapWithSelectedPlaceCoordinate:(CLLocationCoordinate2D)coordinate;

@end
