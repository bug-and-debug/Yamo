//
//  ExploreMapView.m
//  Annotation
//
//  Created by Administrator on 18/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

#import "ExploreMapView.h"
#import "CLLocation+Tools.h"
#import "UserLocation.h"
#import "ExploreMapAnnotationView.h"
#import "UIColor+Yamo.h"
#import "Yamo-Swift.h"
#import "ExploreMapMarkerContainerView.h"

@interface ExploreMapView () <UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic, readwrite) CGFloat angle;
@property (nonatomic, readwrite) ExploreMapUserAnnotationView *userLocationView;
@property (nonatomic, readwrite) UserLocation *userLocation;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableArray <CAShapeLayer *> *distanceMarkerCircles;
@property (nonatomic) NSMutableArray <UILabel *> *distanceMarkerLabels;
@property (nonatomic) TBQuadTreeNode* root;
@property (nonatomic) BOOL isUpdating;
@property (nonatomic) BOOL animateLayout;
@property (nonatomic, readwrite) CGFloat zoomLevel;
@property (nonatomic) BOOL distanceMarkersNeedUpdating;
@property (nonatomic) id <ExploreMapAnnotation> selectedAnnotation;
@property (nonatomic) CLLocationCoordinate2D userPhysicalCoordinate;
@property (nonatomic) BOOL hasFetchedMap;

@end

@implementation ExploreMapView

@synthesize location;
@synthesize scaleMeters;
@synthesize delegate;
@synthesize root;
@synthesize isUpdating;
@synthesize animateLayout;
@synthesize isSelectedLocation;

#define kMinScaleMeters         50.0
#define kMaxScaleMeters         100000.0
#define kDefaultScaleMeters     500
#define kAngleOffset            1.5708
#define kCollisionPadding       3
#define kClusterRunThreshold    3
#define kEarthMeters            6378137
#define kDistanceBetweenMarker  75
#define kUpdatingDistanceMeters 10.0

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.userPhysicalCoordinate = CLLocationCoordinate2DMake(UserServiceDefaultLocationLatitude, UserServiceDefaultLocationLongitude);
    
    self.distanceMarkersNeedUpdating = YES;
    
    self.backgroundColor = [UIColor yamoLightGray];
    
    // Location
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    if ([PermissionRequestLocation sharedInstance].currentStatus == PermissionRequestStatusSystemPromptAllowed) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    
    self.isSelectedLocation = NO;
    self.angle =  kAngleOffset;
    
    annotations = [NSMutableArray array];
    reusableAnnotationViews = [NSMutableArray array];
    currentAnnotations = [NSMutableArray array];
    
    self.scaleMeters = kDefaultScaleMeters;
    
    self.userLocationView = [[ExploreMapUserAnnotationView alloc] initWithSize:30.0f];
    self.userLocationView.layer.cornerRadius = self.userLocationView.frame.size.height * 0.5f;
    (self.userLocationView).backgroundColor = [UIColor colorWithRed:0.09 green:0.57 blue:0.64 alpha:1.00];
    self.userLocationView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userLocationView.layer.borderWidth = 2.0f;
    
    self.userLocationView.center = self.center;
    
    [self setupDistanceMarkers];
    
    markerContainer = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:markerContainer];
    [markerContainer addSubview:self.userLocationView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [markerContainer addGestureRecognizer:pinchGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [markerContainer addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [markerContainer addGestureRecognizer:panGesture];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    rotationGestureRecognizer.delegate = self;
    rotationGestureRecognizer.rotation = self.angle;
//    [markerContainer addGestureRecognizer:rotationGestureRecognizer];
    
    NSSortDescriptor *relevanceSort = [NSSortDescriptor sortDescriptorWithKey:@"mapRelevance" ascending:TRUE];
    NSSortDescriptor *identSort = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:TRUE];
    
    clusterSort = @[relevanceSort, identSort];
    
    world = TBBoundingBoxMake(-90, -180, 90, 180);
    root = TBQuadTreeNodeMake(world, 4);
    
    [self.userLocationView.userView addTarget:self action:@selector(handleLocationButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setDelegate:(id<LOMapViewDelegate>)aDelegate {
    delegate = aDelegate;
    
    if ([delegate respondsToSelector:@selector(mapViewDidChangeScale:)]) {
        
        [delegate mapViewDidChangeScale:self];
    }
}

#pragma - Actions

- (void)handleLocationButtonTap:(id)sender {
    
    if (self.userLocationView.selected) {
        
        if ([self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotation:)]) {
            
            [self.delegate mapView:self didDeselectAnnotation:self.userLocation];
        }
        
    }
    else {
        
        
        if ([self.delegate respondsToSelector:@selector(mapView:didSelectAnnotation:)]) {
            
            [self.delegate mapView:self didSelectAnnotation:self.userLocation];
        }
    }
    
    self.userLocationView.selected = !self.userLocationView.selected;
}

#pragma mark - Annotation Methods

- (void)beginUpdate {
    isUpdating = TRUE;
}

- (void)endUpdate {
    isUpdating = FALSE;
    [self setNeedsLayout];
}

- (void)addAnnotation:(id<ExploreMapAnnotation>)annotation {
    if ([[annotations valueForKey:@"identifier"] containsObject:[annotation identifier]]) {
        NSInteger index = [[annotations valueForKey:@"identifier"] indexOfObject:annotation.identifier];
        id<ExploreMapAnnotation> existingAnnotation = [annotations objectAtIndex:index];
        [existingAnnotation updateWithNewerVersionOfAnnotation:annotation];
        [self updateBearing:annotation];
        
        if(!isUpdating) {
            [self setNeedsLayout];
        }
        return;
    }
    
    TBQuadTreeNodeData data = TBQuadTreeNodeDataMake(annotation.location.latitude, annotation.location.longitude, annotation);
    TBQuadTreeNodeInsertData(root, data);
    [annotations addObject:annotation];
    [self updateBearing:annotation];
    
    if(!isUpdating) {
        [self setNeedsLayout];
    }
}

- (void)selectAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    self.selectedAnnotation = annotation;
    
    // move to the annotation
    if ([self.delegate respondsToSelector:@selector(mapViewWillChangeRegion:)]) {
        [self.delegate mapViewWillChangeRegion:self];
    }
   
    self.location = annotation.location;
    self.scaleMeters = kDefaultScaleMeters;
    self.isSelectedLocation = YES;
    
    if ([self.delegate respondsToSelector:@selector(mapViewDidChangeRegion:)]) {
        [self.delegate mapViewDidChangeRegion:self];
    }
    
    [self setNeedsLayout];
    
    // select the annotation
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for(ExploreMapAnnotationView *annotationView in markerContainer.subviews) {
            
            if ([annotationView.annotation.identifier isEqualToString:annotation.identifier]) {
                annotationView.selected = YES;
            } else {
                annotationView.selected = NO;
            }
        }
        
        if([delegate respondsToSelector:@selector(mapView:didSelectAnnotation:)]) {
            [delegate mapView:self didSelectAnnotation:annotation];
        }
    });
}

- (void)deselectAllAnnotations {
    
    for(ExploreMapAnnotationView *annotationView in markerContainer.subviews) {
        
        annotationView.selected = NO;
    }
}

- (void)removeAllAnnotations {
    root = TBQuadTreeNodeMake(world, 4);
    [annotations removeAllObjects];
    
    for(id<ExploreMapAnnotation> annotation in annotations) {
        if(annotation.annotationView != nil) {
            [reusableAnnotationViews addObject:annotation.annotationView];
        }
    }
    
    [currentAnnotations removeAllObjects];
    
    for (UIView *subview in markerContainer.subviews) {
        if (subview != self.userLocationView) {
            [subview removeFromSuperview];
        }
    }
}

- (void)addAnnotations:(NSArray<id<ExploreMapAnnotation>> *)someAnnotations {
    for (id <ExploreMapAnnotation> annotation in someAnnotations) {
        [self addAnnotation:annotation];
    }
}

- (ExploreMapAnnotationView *)dequeueReusableAnnotation {
    ExploreMapAnnotationView *view = [reusableAnnotationViews lastObject];
    
    if(view != nil) {
        [reusableAnnotationViews removeObject:view];
    }
    
    return view;
}

#pragma mark - Distance Markers

- (void)setupDistanceMarkers {
    
    // Get the maximum distance markers we should add
    CGFloat maximumDistance = MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    
    NSMutableArray *distanceMarkers = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    
    for (NSUInteger index = 0; index <= maximumDistance ; index += kDistanceBetweenMarker) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        [distanceMarkers addObject:layer];
        [self.layer addSublayer:layer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor yamoGray];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f];
        [labels addObject:label];
        [self addSubview:label];
    }
    
    self.distanceMarkerCircles = distanceMarkers;
    self.distanceMarkerLabels = labels;
}

#pragma mark - Location and Scale Methods

- (void)setLocation:(CLLocationCoordinate2D)aLocation {
    [self setLocation:aLocation animated:FALSE];
}

- (void)setLocation:(CLLocationCoordinate2D)aLocation animated:(BOOL)animated {
    location = aLocation;
    currentLocation = [[CLLocation alloc] initWithLatitude:aLocation.latitude longitude:aLocation.longitude];
    
    [self updateBearings];
    
    animateLayout = animated;
    [self setNeedsLayout];
}


- (void)moveToCurrentUserLocationAnimated:(BOOL)animated {
    [self setLocation:self.userLocation.coordinate animated:animated];
}

- (void)setScaleMeters:(CGFloat)aValue {
    scaleMeters = MIN(MAX(aValue, kMinScaleMeters), kMaxScaleMeters);
    self.zoomLevel = scaleMeters / 1000;
    
    if([delegate respondsToSelector:@selector(mapViewDidChangeScale:)]) {
        [delegate mapViewDidChangeScale:self];
    }
}

#pragma mark - Layout Methods

- (void)updateBearings {
    for(id<ExploreMapAnnotation> annotation in annotations) {
        [self updateBearing:annotation];
    }
    
    self.userLocation.distance = [self.userLocation distanceFromLocation:currentLocation];
    self.userLocation.bearing = [currentLocation bearingToLocation:self.userLocation];
}

- (void)updateBearing:(id<ExploreMapAnnotation>)anAnnotation {
    CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:anAnnotation.location.latitude longitude:anAnnotation.location.longitude];
    anAnnotation.distance = [annotationLocation distanceFromLocation:currentLocation];
    anAnnotation.bearing = [currentLocation bearingToLocation:annotationLocation];
}

- (void)update {
    if(lastScale != scaleMeters) {
        lastScale = scaleMeters;
        [self setNeedsLayout];
    }
}

- (CLLocationCoordinate2D)offsetLocation:(CGSize)aSize {
    CGFloat latitudeMeters = (aSize.height / self.frame.size.height) * self.scaleMeters;
    CGFloat longitudeMeters = (aSize.width / self.frame.size.width) * (self.scaleMeters * (self.frame.size.width / self.frame.size.height));
    
    return [self locationMovingLocation:currentLocation.coordinate byLatitudeMeters:latitudeMeters longitudeMeters:longitudeMeters];
}

- (CGFloat)scaleMetersContainingLocation:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation {
    CGFloat latitudeDifference = toLocation.latitude - fromLocation.latitude;
    CGFloat longitudeDifference = toLocation.longitude - fromLocation.longitude;
    
    CGFloat latitudeMeters = latitudeDifference * 110574;
    CGFloat longitudeMeters = longitudeDifference * (cos(fromLocation.latitude + (latitudeDifference * 0.5)) * 111320);
    
    return self.scaleMeters - MAX(latitudeMeters, longitudeMeters);
}

- (CLLocationCoordinate2D)locationMovingLocation:(CLLocationCoordinate2D)aLocation byLatitudeMeters:(CGFloat)latitudeMeters longitudeMeters:(CGFloat)longitudeMeters {
    CGFloat latitudeDelta = latitudeMeters / kEarthMeters;
    CGFloat longitudeDelta = longitudeMeters / (kEarthMeters * cos(M_PI * aLocation.latitude / 180.0));
    
    CLLocationDegrees newLatitude  = aLocation.latitude  + (latitudeDelta * (180.0 / M_PI));
    CLLocationDegrees newLongitude = aLocation.longitude + (longitudeDelta * (180.0 / M_PI));
    
    return CLLocationCoordinate2DMake(newLatitude, newLongitude);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isChangingLayout = isRotating || isPanning || isZooming;
    
    if(animateLayout) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(isChangingLayout) {
                [self layoutAnnotations];
            } else {
                [self calculateAnnotations];
            }
            
        } completion:nil];
        
    } else {
        if(isChangingLayout) {
            [self layoutAnnotations];
        } else {
            [self calculateAnnotations];
        }
    }
    
    [self layoutMarkersAnimated:animateLayout];
    
    animateLayout = FALSE;
}

- (void)layoutMarkersAnimated:(BOOL)animated {
    
    CGFloat scaleDistance = (self.userLocation.distance / scaleMeters) * self.bounds.size.height;
    CGFloat x = self.center.x + (scaleDistance * cos(self.userLocation.bearing - self.angle));
    CGFloat y = self.center.y + (scaleDistance * sin(self.userLocation.bearing - self.angle));
    
    // Layout user location indicator
    
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.userLocationView.center = CGPointMake(x, y);
        } completion:nil];
    } else {
        self.userLocationView.center = CGPointMake(x, y);
    }
    
    // Layout distance markers
    
    CGPoint circleCenter = CGPointMake(x, y);

    CGFloat radius;
    
    if (CGRectContainsPoint(self.bounds, circleCenter)) {
        radius = 0;
    }
    else {
        radius = kDistanceBetweenMarker * (round(scaleDistance / kDistanceBetweenMarker) - self.distanceMarkerCircles.count * 0.5 - 1);
    }
    
    for (NSInteger i = 0; i < self.distanceMarkerCircles.count && i < self.distanceMarkerLabels.count; i++) {
        
        radius += kDistanceBetweenMarker;
        
        CAShapeLayer *layer = self.distanceMarkerCircles[i];
        UILabel *label = self.distanceMarkerLabels[i];
        
        [self layoutMarkerLayer:layer
                          label:label
                   circleCenter:circleCenter
                         radius:MAX(radius, 0)
                       animated:animated];
    }
}

- (void)layoutMarkerLayer:(CAShapeLayer *)layer label:(UILabel *)label circleCenter:(CGPoint)circleCenter radius:(CGFloat)radius animated:(BOOL)animated {
    
    // Setup distance markers circle frame

    CGRect markerFrame = CGRectMake(circleCenter.x - radius, circleCenter.y - radius, radius * 2, radius * 2);

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:markerFrame];
    
    if (animated) {
        
        [CATransaction begin];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        pathAnimation.duration = 0.42;
        pathAnimation.fromValue = (id)layer.path;
        pathAnimation.toValue = (id)path.CGPath;
        [layer addAnimation:pathAnimation forKey:@"path"];
        [CATransaction setCompletionBlock:^{
            layer.path = path.CGPath;
            layer.strokeColor = [UIColor yamoGray].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
        }];
        [CATransaction commit];
    }
    else {
        
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor yamoGray].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
    }
    
    
    // Calculate meters and the display text

    CGFloat meters = ((markerFrame.size.height) / self.bounds.size.height) * self.scaleMeters;
    
    CGFloat radiusInMeters = meters * 0.5f;
    
    CGFloat convertedMeters = 0.0f;
    
    convertedMeters = radiusInMeters;
    
    NSString *unit = @"m";
    NSString *text;
    
    if (radiusInMeters > 1000) {
        
        unit = @"km";
        convertedMeters = radiusInMeters / 1000;
        text = [NSString stringWithFormat:@"%.1f%@", convertedMeters, unit];
    }
    else {
        
        text = [NSString stringWithFormat:@"%.0f%@", convertedMeters, unit];
    }
    
    NSString *finalText = (radius <= 0) ? @"" : text;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:finalText attributes:attributes];
    
    label.attributedText = attributedString;
    label.textAlignment = NSTextAlignmentCenter;

    // Setup distance labels frame

    CGRect textFrame = [text boundingRectWithSize:CGSizeMake(DBL_MAX, 25.0)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                                     NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f]}
                                          context:nil];
    
    CGRect labelFrame = CGRectMake(markerFrame.origin.x + (markerFrame.size.width / 2 - textFrame.size.width / 2),
                                   markerFrame.origin.y + markerFrame.size.height,
                                   textFrame.size.width, 25.0);
    
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.frame = labelFrame;
        } completion:nil];
    }
    else {
        label.frame = labelFrame;
    }
}

#pragma mark - Gesture Methods

- (void)pinchDetected:(UIPinchGestureRecognizer *)aRecogniser {
    if(aRecogniser.state == UIGestureRecognizerStateBegan) {
        isZooming = TRUE;
        snapshotScale = scaleMeters;
    } else if(aRecogniser.state == UIGestureRecognizerStateEnded) {
        isZooming = FALSE;
    } else {
        self.scaleMeters = snapshotScale / aRecogniser.scale;
    }
    
    [self setNeedsLayout];
}

- (void)tapDetected:(UITapGestureRecognizer *)aRecogniser {
    if(aRecogniser.state == UIGestureRecognizerStateRecognized) {
        CGPoint touchPoint = [aRecogniser locationInView:self];
        UIView *tappedView = [markerContainer hitTest:touchPoint withEvent:nil];
        
        if([tappedView isKindOfClass:[ExploreMapAnnotationView class]]) {
            for(id<ExploreMapAnnotation> annotation in currentAnnotations) {
                if([annotation.annotationView isEqual:tappedView]) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent == %@", annotation];
                    NSArray *children = [currentAnnotations filteredArrayUsingPredicate:predicate];
                    
                    if(children.count > 0) {
                        for(ExploreMapAnnotationView *view in markerContainer.subviews) {
                            [view setSelected:FALSE];
                        }
                        
                        CGFloat minLatitude = annotation.location.latitude;
                        CGFloat maxLatitude = annotation.location.latitude;
                        CGFloat minLongitude = annotation.location.longitude;
                        CGFloat maxLongitude = annotation.location.longitude;
                        
                        for(id<ExploreMapAnnotation> child in children) {
                            minLatitude = MIN(minLatitude, child.location.latitude);
                            minLongitude = MIN(minLongitude, child.location.longitude);
                            maxLatitude = MAX(maxLatitude, child.location.latitude);
                            maxLongitude = MAX(maxLongitude, child.location.longitude);
                        }
                        
                        CGFloat latitude = minLatitude + ((maxLatitude - minLatitude) * 0.5);
                        CGFloat longitude = minLongitude + ((maxLongitude - minLongitude) * 0.5);
                        CGFloat newScaleMeters = self.scaleMeters;
                        newScaleMeters = [self scaleMetersContainingLocation:CLLocationCoordinate2DMake(minLatitude, minLongitude)
                                                                  toLocation:CLLocationCoordinate2DMake(maxLatitude, maxLongitude)];
                        newScaleMeters *= 0.5;
                        
                        self.scaleMeters = newScaleMeters;
                        
                        [self setLocation:CLLocationCoordinate2DMake(latitude, longitude) animated:TRUE];
                        return;
                    }
                    
                    self.selectedAnnotation = ((ExploreMapAnnotationView *)tappedView).annotation;
                    
                    if([delegate respondsToSelector:@selector(mapView:didSelectAnnotation:)]) {
                        [delegate mapView:self didSelectAnnotation:((ExploreMapAnnotationView *)tappedView).annotation];
                    }
                }
            }
        } else {
            self.selectedAnnotation.annotationView.selected = NO;
            
            if([delegate respondsToSelector:@selector(mapView:didDeselectAnnotation:)]) {
                [delegate mapView:self didDeselectAnnotation:self.selectedAnnotation];
            }
            
        }
        
        for(ExploreMapAnnotationView *annotationView in markerContainer.subviews) {
            annotationView.selected = [tappedView isEqual:annotationView];
        }
    }
}

- (void)panDetected:(UIPanGestureRecognizer *)aRecogniser {
    if(aRecogniser.state == UIGestureRecognizerStateBegan) {
        isPanning = TRUE;
        panLocation = currentLocation;
        
        if ([self.delegate respondsToSelector:@selector(mapViewWillChangeRegion:)]) {
            [self.delegate mapViewWillChangeRegion:self];
        }
        
    } else if(aRecogniser.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = CGPointApplyAffineTransform([aRecogniser translationInView:self], CGAffineTransformMakeRotation(self.angle - kAngleOffset));
        translation.x *= -1;
        
        CGFloat latitudeMeters = (translation.y / self.frame.size.height) * self.scaleMeters;
        CGFloat longitudeMeters = (translation.x / self.frame.size.width) * (self.scaleMeters * (self.frame.size.width / self.frame.size.height));
        
        self.location = [self locationMovingLocation:panLocation.coordinate byLatitudeMeters:latitudeMeters longitudeMeters:longitudeMeters];
        
        self.isSelectedLocation = YES;
        
    } else if (aRecogniser.state == UIGestureRecognizerStateEnded) {
        isPanning = FALSE;
        
        if ([self.delegate respondsToSelector:@selector(mapViewDidChangeRegion:)]) {
            [self.delegate mapViewDidChangeRegion:self];
        }
    }
    
    [self setNeedsLayout];
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        isRotating = TRUE;
        snapshotAngle = self.angle;
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        isRotating = FALSE;
    }
    
    self.angle = snapshotAngle - gestureRecognizer.rotation;
    [delegate mapViewDidChangeRotation:self];
    [self setNeedsLayout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if ([PermissionRequestLocation sharedInstance].currentStatus == PermissionRequestStatusSystemPromptAllowed) {
        
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            self.hasFetchedMap = NO;
            [_locationManager startUpdatingLocation];
        }
        else {
            
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    else {
        
        // Use default location
        
        location = CLLocationCoordinate2DMake(UserServiceDefaultLocationLatitude, UserServiceDefaultLocationLongitude);
        
        self.userLocation = [[UserLocation alloc] initWithLatitude:UserServiceDefaultLocationLatitude longitude:UserServiceDefaultLocationLongitude];
        
        self.userLocation.distance = [self.userLocation distanceFromLocation:currentLocation];
        self.userLocation.bearing = [currentLocation bearingToLocation:self.userLocation];
        
        [self moveToCurrentUserLocationAnimated:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (locations.firstObject) {
        CLLocation *newLocation = locations.firstObject;
        CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
        self.userPhysicalCoordinate = newCoordinate;
        
        location = newCoordinate;
        
        self.userLocation = [[UserLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
        self.userLocation.distance = [self.userLocation distanceFromLocation:currentLocation];
        self.userLocation.bearing = [currentLocation bearingToLocation:self.userLocation];
        
        [manager stopUpdatingLocation];
        
        if (!self.isSelectedLocation && (!self.hasFetchedMap || self.userLocation.distance > kUpdatingDistanceMeters)) {
            self.hasFetchedMap = YES;
            [self resetToUsersPhysicalLocation];
        }
    }
}

#pragma mark - Layout / Clustering Methods

- (void)layoutAnnotations {
    for(id<ExploreMapAnnotation> annotation in currentAnnotations) {
        CGFloat scaleDistance = (annotation.distance / scaleMeters) * self.frame.size.height;
        CGFloat x = self.center.x + (scaleDistance * cos(annotation.bearing - self.angle));
        CGFloat y = self.center.y + (scaleDistance * sin(annotation.bearing - self.angle));
        annotation.annotationView.center = CGPointMake(x, y);
    }
}

- (void)calculateAnnotations {
    CGFloat widthSize = self.frame.size.height * 0.75;
    CGFloat heightSize = self.frame.size.height * 0.75;
    
    CLLocationCoordinate2D northWest = [self offsetLocation:CGSizeMake(-widthSize, -heightSize)];
    CLLocationCoordinate2D southEast = [self offsetLocation:CGSizeMake(widthSize, heightSize)];
    
    NSMutableArray *boundedAnnotations = [NSMutableArray array];
    TBBoundingBox boundingBox = TBBoundingBoxMake(northWest.latitude, northWest.longitude, southEast.latitude, southEast.longitude);
    
    TBQuadTreeGatherDataInRange(self.root, boundingBox, ^(TBQuadTreeNodeData data) {
        [boundedAnnotations addObject:(id<ExploreMapAnnotation>)data.data];
    });
    
    NSMutableSet *before = [NSMutableSet setWithArray:currentAnnotations];
    NSMutableSet *after = [NSMutableSet setWithArray:boundedAnnotations];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:before];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    for(id<ExploreMapAnnotation> annotation in toAdd) {
        ExploreMapAnnotationView *annotationView = annotation.annotationView;
        
        if(annotationView == nil) {
            annotationView = [delegate mapView:self viewForAnnotation:annotation];
            annotation.annotationView = annotationView;
        }
        
        [markerContainer addSubview:annotationView];
    }
    
    [currentAnnotations addObjectsFromArray:toAdd.allObjects];
    [currentAnnotations sortUsingDescriptors:clusterSort];
    
    [self layoutAnnotations];
    
    BOOL didChangeCluster = FALSE;
    NSUInteger clusterRun = 0;
    
    do {
        clusterRun++;
        
        for(NSUInteger outerIndex = 0; outerIndex < currentAnnotations.count; outerIndex++) {
            id<ExploreMapAnnotation> outerAnnotation = currentAnnotations[outerIndex];
            [outerAnnotation setParent:nil];
            
            for(NSUInteger innerIndex = outerIndex + 1; innerIndex < currentAnnotations.count; innerIndex++) {
                id<ExploreMapAnnotation> innerAnnotation = currentAnnotations[innerIndex];
                
                if(innerAnnotation.annotationView.clustered) {
                    continue;
                }
                
                if(CGRectIntersectsRect(CGRectInset(innerAnnotation.annotationView.frame, kCollisionPadding, kCollisionPadding),
                                        CGRectInset(outerAnnotation.annotationView.frame, kCollisionPadding, kCollisionPadding))) {
                    [outerAnnotation setParent:innerAnnotation];
                    break;
                }
            }
        }
        
        for(id<ExploreMapAnnotation> annotation in toRemove) {
            if(annotation.annotationView != nil) {
                [reusableAnnotationViews addObject:annotation.annotationView];
                [annotation.annotationView repareForReuse];
                annotation.annotationView = nil;
            }
        }
        
        [currentAnnotations removeObjectsInArray:toRemove.allObjects];
        
        for(id<ExploreMapAnnotation> annotation in currentAnnotations) {
            if((annotation.parent != nil) && (!annotation.annotationView.clustered)) {
                
                [self deselectAnnotation:annotation];
                [markerContainer sendSubviewToBack:annotation.annotationView];
                id<ExploreMapAnnotation> parent = annotation.parent;
                [self deselectAnnotation:parent];
                
                while(parent.parent != nil) {
                    parent = parent.parent;
                    [self deselectAnnotation:parent];
                }
                
                [annotation.annotationView clusterWithAnnotationView:parent.annotationView animated:![toAdd containsObject:annotation]];
                didChangeCluster = TRUE;
            } else if((annotation.parent == nil) && (annotation.annotationView.clustered)) {
                [markerContainer sendSubviewToBack:annotation.annotationView];
                [annotation.annotationView unClusterAnimated:![toAdd containsObject:annotation]];
                didChangeCluster = TRUE;
            }
        }
    } while(didChangeCluster && clusterRun < kClusterRunThreshold);
    
    for(id<ExploreMapAnnotation> annotation in currentAnnotations) {
        NSMutableArray *children = [NSMutableArray array];
        [children addObjectsFromArray:[self childrenOfAnnotation:annotation]];
        NSMutableSet *colours = [NSMutableSet setWithArray:annotation.colors];
        
        for(id<ExploreMapAnnotation> child in children) {
            [colours addObjectsFromArray:child.colors];
            
            
        }
        
        annotation.annotationView.count = children.count + 1;
        
        annotation.annotationView.colours = [[colours allObjects] sortedArrayUsingComparator:^NSComparisonResult(UIColor * _Nonnull obj1, UIColor *  _Nonnull obj2) {
            
            // Only comparing hue.
            
            CGFloat firstHue = 0.0f;
            CGFloat firstSaturation = 0.0f;
            CGFloat firstBrightness = 0.0f;
            CGFloat firstAlpha = 0.0f;
            
            [obj1 getHue:&firstHue saturation:&firstSaturation brightness:&firstBrightness alpha:&firstAlpha];
            
            CGFloat secondHue = 0.0f;
            
            // Reusing firstSaturation, firstBrightness & firstAlpha because we're only interested in hue.
            
            [obj2 getHue:&secondHue saturation:&firstSaturation brightness:&firstBrightness alpha:&firstAlpha];

            if (firstHue > secondHue) {
                
                return NSOrderedDescending;
            }
            else {
                
                return NSOrderedAscending;
            }
        }];
    }
    
    [markerContainer sendSubviewToBack:self.userLocationView];
}

- (void)deselectAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    if ([annotation annotationView].selected) {
        [[annotation annotationView] setSelected:NO];
        if ([self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotation:)]) {
            [self.delegate mapView:self didDeselectAnnotation:annotation];
        }
    }
}

- (NSArray *)childrenOfAnnotation:(id<ExploreMapAnnotation>)annotation {
    NSMutableSet *allChildren = [NSMutableSet set];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent == %@", annotation];
    NSArray *children = [currentAnnotations filteredArrayUsingPredicate:predicate];
    [allChildren addObjectsFromArray:children];
    
    for(id<ExploreMapAnnotation> child in children) {
        [allChildren addObjectsFromArray:[self childrenOfAnnotation:child]];
    }
    
    return allChildren.allObjects;
}

#pragma mark - Helpers

- (void)resetToUsersPhysicalLocation {
    
    self.angle = kAngleOffset;
    [self updateMapWithSelectedPlaceCoordinate:self.userPhysicalCoordinate];
}

- (void)updateMapWithSelectedPlaceCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self.scaleMeters = kDefaultScaleMeters;
    
    if (self.selectedAnnotation) {
        self.selectedAnnotation.annotationView.selected = NO;
        if([delegate respondsToSelector:@selector(mapView:didDeselectAnnotation:)]) {
            [delegate mapView:self didDeselectAnnotation:self.selectedAnnotation];
        }
    }
    
    location = coordinate;
    currentLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    self.userLocation = [[UserLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    self.userLocation.distance = [self.userLocation distanceFromLocation:currentLocation];
    self.userLocation.bearing = [currentLocation bearingToLocation:self.userLocation];
    
    [self moveToCurrentUserLocationAnimated:NO];
    [self removeAllAnnotations];
    
    self.userLocationView.center = self.center;
    [self layoutMarkersAnimated:NO];
    
    if ([self.delegate respondsToSelector:@selector(mapViewShouldUpdateDataWithLocation:shouldClearCache:)]) {
        [self.delegate mapViewShouldUpdateDataWithLocation:coordinate shouldClearCache:YES];
    }
}

@end
