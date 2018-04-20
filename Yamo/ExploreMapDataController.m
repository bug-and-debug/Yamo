//
//  ExploreMapDataController.m
//  Yamo
//
//  Created by Mo Moosa on 24/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ExploreMapDataController.h"
#import "UIColor+Tools.h"
#import "UserService.h"
#import "ExploreMapAnnotationView.h"
#import "ExploreMapView.h"
#import "Venue.h"
#import "GMUMarkerClustering.h"
#import <GoogleMaps/GoogleMaps.h>

#define kPink       [UIColor colorWithHexString:@"e575b4"]
#define kBlue       [UIColor colorWithHexString:@"77b4fe"]
#define kGreen      [UIColor colorWithHexString:@"70d093"]
#define kOrange     [UIColor colorWithHexString:@"f88027"]
#define kYellow     [UIColor colorWithHexString:@"fbd11f"]
#define kDarkBlue   [UIColor colorWithHexString:@"4f57d1"]
#define ARC4RANDOM_MAX      0x100000000

// Point of Interest Item which implements the GMUClusterItem protocol.
@interface POIItem : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) VenueSearchSummary *summary;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position summary:(VenueSearchSummary *)summary;

@end

@implementation POIItem

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position summary:(VenueSearchSummary *)summary {
    if ((self = [super init])) {
        _position = position;
        _summary = [summary copy];
    }
    return self;
}

@end

@interface CustomClusterIconGenerator : GMUDefaultClusterIconGenerator

@end

@implementation CustomClusterIconGenerator

- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)iconForSize:(NSUInteger)size {
    VenueSearchSummary *summary = [[VenueSearchSummary alloc] init];
    
    id<ExploreMapAnnotation>anAnnotation = summary;
   
    ExploreMapAnnotationView *annotationView = [[ExploreMapAnnotationView alloc] initWithAnnotation:anAnnotation shouldResizeBasedOnRelevance:false];
    [annotationView setColours:[NSArray arrayWithObjects:kDarkBlue, nil]];
    [annotationView setCount:size];
    
    return [self imageFromView:annotationView];
}

@end

@interface CustomClusterRenderer : GMUDefaultClusterRenderer

@property(nonatomic) GMSMapView *mapView;
@property(nonatomic) NSMutableDictionary *mapIconsArray;

@end

@implementation CustomClusterRenderer

- (UIImage *)getCustomIconItem:(id)userData {
    POIItem *item = (POIItem*)userData;
    UIImage *iconImage = [self.mapIconsArray objectForKey:[item.summary.uuid stringValue]];
    
    return iconImage;
}

- (GMSMarker *)markerWithPosition:(CLLocationCoordinate2D)position
                             from:(CLLocationCoordinate2D)from
                         userData:(id)userData
                      clusterIcon:(UIImage *)clusterIcon
                         animated:(BOOL)animated {
    
    CLLocationCoordinate2D initialPosition = animated ? from : position;
    GMSMarker *marker = [GMSMarker markerWithPosition:initialPosition];
    marker.userData = userData;
    if (clusterIcon != nil) {
        marker.icon = clusterIcon;
    } else {
        marker.icon = [self getCustomIconItem:userData];
    }
    marker.groundAnchor = CGPointMake(0.5, 0.5);
    marker.map = self.mapView;
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.5];
        marker.layer.latitude = position.latitude;
        marker.layer.longitude = position.longitude;
        [CATransaction commit];
    }
    return marker;
}

@end

@interface ExploreMapDataController () <LOMapViewDelegate, GMUClusterManagerDelegate, GMSMapViewDelegate>

@property (nonatomic, weak) ExploreMapView *mapView;
@property (nonatomic, weak) GMSMapView *googleMapView;
@property (nonatomic, weak) GMSMarker  *selMarker;
@property (nonatomic) NSMutableArray<VenueSearchSummary *> *exhibitionData;
@property (nonatomic) CustomClusterRenderer *customClusterRenderer;

@end

@implementation ExploreMapDataController

GMUClusterManager *_clusterManager;

- (instancetype)initWithMapViews:(ExploreMapView *)mapView GooleMap:(GMSMapView *)gMapView {
    
    self = [super init];
    
    if (self) {

        [self setupMapViews:mapView GoogleMap:gMapView];
    }
    
    return self;
}

- (void)setupMapViews:(ExploreMapView *)mapView GoogleMap:(GMSMapView *)gMapView {
    
    self.mapView = mapView;
    self.mapView.delegate = self;
    
    self.googleMapView = gMapView;
    self.googleMapView.delegate = self;
    
    self.selMarker = NULL;
    
    // Set up the cluster manager with default icon generator and renderer.
    id<GMUClusterAlgorithm> algorithm = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id<GMUClusterIconGenerator> iconGenerator = [[CustomClusterIconGenerator alloc] init];
    self.customClusterRenderer = [[CustomClusterRenderer alloc] initWithMapView:self.googleMapView
                                  clusterIconGenerator:iconGenerator];
    self.customClusterRenderer.mapView = self.googleMapView;
    self.customClusterRenderer.mapIconsArray = [[NSMutableDictionary alloc] init];
    
    _clusterManager = [[GMUClusterManager alloc] initWithMap:self.googleMapView algorithm:algorithm renderer:self.customClusterRenderer];
    
    // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
    [_clusterManager setDelegate:self mapDelegate:self];
}


- (void)setupData:(NSArray <VenueSearchSummary *> *)data {
    
    BOOL isDataUpdated = NO;
    if (self.exhibitionData == nil || ![self.exhibitionData isEqualToArray:data]) {
        isDataUpdated = YES;
    }
    self.exhibitionData = [data mutableCopy];
    
    if (isDataUpdated) {
        
        NSLog(@"latitude = %f, longitude = %f", self.mapView.location.latitude, self.mapView.location.longitude);
        
        [self.customClusterRenderer.mapIconsArray removeAllObjects];
        
        for (VenueSearchSummary *summary in self.exhibitionData) {
            
            ExploreMapAnnotationView *annotationView = [self getAnnotationView:summary];
            UIImage *iconImage = [self imageFromView:annotationView];
            if (iconImage != nil) {
                [self.customClusterRenderer.mapIconsArray setObject:iconImage forKey:[summary.uuid stringValue]];
            }
        }
    }
    
    [self.googleMapView clear];
    
    GMSMarker *currentPosMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.mapView.location.latitude, self.mapView.location.longitude)];
    currentPosMarker.icon = [UIImage imageNamed:@"location"];
    currentPosMarker.map = self.googleMapView;
    currentPosMarker.userData = nil;
    
    NSDate *currentDate = nil;
    if ([self.delegate respondsToSelector:@selector(getCurrentDateFromCalendar:)]) {
        currentDate = [self.delegate getCurrentDateFromCalendar:self];
    }
    
    [_clusterManager clearItems];

    for (VenueSearchSummary *summary in self.exhibitionData) {
        
        BOOL isRemovedVenue = NO;
        if (currentDate != nil) {
            if (summary.exhibitionInfoData != nil && summary.exhibitionInfoData.endDate != nil) {
                if ([currentDate compare:summary.exhibitionInfoData.endDate] == NSOrderedDescending) {
                    isRemovedVenue = YES;
                }
            }
        }

        if (!isRemovedVenue) {
            id<GMUClusterItem> item =
            [[POIItem alloc] initWithPosition:CLLocationCoordinate2DMake(summary.latitude, summary.longitude) summary:summary];
            [_clusterManager addItem:item];
        }
    }
    
    [_clusterManager cluster];
}

- (ExploreMapAnnotationView *)getAnnotationView:(id<ExploreMapAnnotation>)annotation {
    
    UserRoleType type = [[[UserService sharedInstance] loggedInUser] userType];
    BOOL shouldResizeBasedOnRelevance = NO;
    
    if (type == UserRoleTypeStandard || type == UserRoleTypeAdmin) {
        
        shouldResizeBasedOnRelevance = YES;
    }
    
    ExploreMapAnnotationView *annotationView = [[ExploreMapAnnotationView alloc] initWithAnnotation:annotation shouldResizeBasedOnRelevance:shouldResizeBasedOnRelevance];
    
    return annotationView;
}

- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) deselectMapMarker {
    if (self.selMarker != NULL) {
        POIItem *item = (POIItem*)self.selMarker.userData;
        VenueSearchSummary *summary = item.summary;
        ExploreMapAnnotationView *annotationView = [self getAnnotationView:summary];
        annotationView.selected = NO;
        self.selMarker.icon = [self imageFromView:annotationView];
        self.selMarker = NULL;
    }
}

#pragma mark GMUClusterManagerDelegate

- (void)clusterManager:(GMUClusterManager *)clusterManager didTapCluster:(id<GMUCluster>)cluster {
    GMSCameraPosition *newCamera =
    [GMSCameraPosition cameraWithTarget:cluster.position zoom:self.googleMapView.camera.zoom + 1];
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    [self.googleMapView moveCamera:update];
}

#pragma mark GMSMapView Delegate Methods

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    [self deselectMapMarker];
    
    if (marker.userData != nil) {
        POIItem *item = (POIItem*)marker.userData;
        VenueSearchSummary *summary = item.summary;
        self.selMarker = marker;
        
        ExploreMapAnnotationView *annotationView = [self getAnnotationView:summary];
        annotationView.selected = YES;
        marker.icon = [self imageFromView:annotationView];
        
        
        if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didSelectVenue:)]) {
            
            [self.delegate exploreMapDataController:self didSelectVenue:summary];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserServiceHideShareButtonNotification object:nil userInfo:nil];
        }
    }
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.selMarker == NULL) {
        return;
    }
    
    POIItem *item = (POIItem*)self.selMarker.userData;
    
    VenueSearchSummary *summary = item.summary;
    [self deselectMapMarker];
    
    if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didDeselectVenue:)]) {
        
        [self.delegate exploreMapDataController:self didDeselectVenue:summary];
    }
}

#pragma mark Map View Delegate Methods

- (ExploreMapAnnotationView *)mapView:(ExploreMapView *)mapView viewForAnnotation:(id<ExploreMapAnnotation>)annotation {
    //    LOVenue *venue = (LOVenue *)annotation;
    
    NSArray *colors = nil;
    
    if ([annotation isKindOfClass:[VenueSearchSummary class]]) {
        
        VenueSearchSummary *searchSummary = (VenueSearchSummary *)annotation;
        
        colors = (searchSummary.colors.count) ? searchSummary.colors : @[[UIColor colorWithWhite:0.4 alpha:1.0]];
    }
    
    
    ExploreMapAnnotationView *annotationView = [mapView dequeueReusableAnnotation];
    
    UserRoleType type = [[[UserService sharedInstance] loggedInUser] userType];
    BOOL shouldResizeBasedOnRelevance = NO;
    
    if (type == UserRoleTypeStandard || type == UserRoleTypeAdmin) {
        
        shouldResizeBasedOnRelevance = YES;
    }

    if (annotationView == nil) {
        
        annotationView = [[ExploreMapAnnotationView alloc] initWithAnnotation:annotation shouldResizeBasedOnRelevance:shouldResizeBasedOnRelevance];
    }
    else {
        annotationView.shouldBaseSizeOnRelevance = shouldResizeBasedOnRelevance;
        [annotationView setAnnotation:annotation];
    }
    
    return annotationView;
}



- (void)mapViewDidFinishChangingScale:(ExploreMapView *)mapView {
    
    if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didUpdateLocation:zoomLevel:shouldClearCache:)]) {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.location.latitude longitude:mapView.location.longitude];
        
        [self.delegate exploreMapDataController:self didUpdateLocation:location zoomLevel:mapView.zoomLevel shouldClearCache:NO];
    }
}

- (CGSize)mapView:(ExploreMapView *)mapView sizeForAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    CGFloat dimension = 100.0f;
    
    UserRoleType type = [UserService sharedInstance].loggedInUser.userType;
    
    if (type == UserRoleTypeAdmin || type == UserRoleTypeStandard) {
        
        if ([annotation isKindOfClass:[VenueSearchSummary class]]) {
            
            double relevance = (double)arc4random_uniform(100);
            
            dimension = dimension + (relevance * 0.2);
        }
    }
    
    return CGSizeMake(dimension, dimension);
}

- (void)mapViewDidChangeRotation:(ExploreMapView *)mapView {
    
}

- (void)mapViewDidChangeRegion:(ExploreMapView *)mapView {
    
    if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didUpdateLocation:zoomLevel:shouldClearCache:)]) {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.location.latitude longitude:mapView.location.longitude];
        
        [self.delegate exploreMapDataController:self didUpdateLocation:location zoomLevel:mapView.zoomLevel shouldClearCache:NO];
    }
}

- (void)mapView:(ExploreMapView *)mapView didSelectAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    if ((UserLocation *)annotation == mapView.userLocation) {
        
        if ([self.delegate respondsToSelector:@selector(exploreMapDataControllerDidSelectUserLocation:)]) {
            
            [self.delegate exploreMapDataControllerDidSelectUserLocation:self];
        }
    }
    else if ([annotation isKindOfClass:[VenueSearchSummary class]]) {
        if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didSelectVenue:)]) {
            
            [self.delegate exploreMapDataController:self didSelectVenue:(VenueSearchSummary *)annotation];
        }
    }
}


- (void)mapView:(ExploreMapView *)mapView didDeselectAnnotation:(id<ExploreMapAnnotation>)annotation {
    
    if ((UserLocation *)annotation == mapView.userLocation) {
        
        if ([self.delegate respondsToSelector:@selector(exploreMapDataControllerDidDeselectUserLocation:)]) {
            
            [self.delegate exploreMapDataControllerDidDeselectUserLocation:self];
        }
    }
    else {
        
        if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didDeselectVenue:)]) {
            
            [self.delegate exploreMapDataController:self didDeselectVenue:(VenueSearchSummary *)annotation];
        }
    }
}

- (void)mapViewShouldUpdateDataWithLocation:(CLLocationCoordinate2D)coordinate shouldClearCache:(BOOL)shouldClearCache {
    
    if ([self.delegate respondsToSelector:@selector(exploreMapDataController:didUpdateLocation:zoomLevel:shouldClearCache:)]) {
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.delegate exploreMapDataController:self didUpdateLocation:newLocation zoomLevel:self.mapView.zoomLevel shouldClearCache:shouldClearCache];
    }
}

- (NSArray *)colours {
    NSArray *colours = @[kPink, kGreen, kBlue, kOrange, kYellow, kDarkBlue];
    NSMutableArray* pickedColours = [NSMutableArray new];
    
    NSUInteger remaining = (arc4random() % colours.count) + 1;
    
    if (colours.count >= remaining) {
        while (remaining > 0) {
            id colour = colours[arc4random_uniform((int)colours.count)];
            
            if (![pickedColours containsObject:colour]) {
                [pickedColours addObject:colour];
                remaining--;
            }
        }
    }
    
    return pickedColours;
}

@end
