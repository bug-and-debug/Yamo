//
//  RoutePlanner.m
//  Yamo
//
//  Created by Peter Su on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCoordinator.h"
#import "Route.h"
#import "Place.h"
#import "RouteStep.h"
#import "Venue.h"

NSString * const RoutePlannerInvalidateCacheNotification = @"RoutePlannerInvalidateCacheNotification";

NSInteger const RoutePlannerWalkTransitPrime = 131;
NSInteger const RoutePlannerDriveTransitPrime = 137;

@interface RoutePlannerCache ()

@property (nonatomic, readwrite) double firstTimeTravelled;

@property (nonatomic, readwrite) double timeTravelled;

@property (nonatomic, readwrite) double distanceTravelled;

@property (nonatomic, strong, readwrite) NSMutableArray<MKRoute *> *mapRoutes;

@end

@implementation RoutePlannerCache

- (instancetype)init {
    
    if (self = [super init]) {
        self.mapRoutes = [NSMutableArray new];
    }
    return self;
}

@end

/*
 *  RoutePlannerCoordinator will return the time and distance it takes to traverse all the route steps in a route.
 *  Because MKDirectionsRequest throttles the request, RoutePlannerCoordinator will cache the results. Cache will be invalidated
 *  if the sequence of steps in the Route is changed.
 */
@interface RoutePlannerCoordinator ()

@property (nonatomic) RoutePlannerTransitType currentTransitType;

@property (nonatomic, strong) RoutePlannerCache *cachedRouteForWalking;

@property (nonatomic, strong) RoutePlannerCache *cachedRouteForDriving;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, MKRoute *> *cacheDistanceForRoute;

@end

@implementation RoutePlannerCoordinator

- (void)dealloc {
    
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithRoute:(Route *)route {
    
    if (self = [super init]) {
        
        _route = route;
        _cacheDistanceForRoute = [NSMutableDictionary new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleReceivedInvalidateCacheNotification)
                                                     name:RoutePlannerInvalidateCacheNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)setCurrentSourcePlace:(id<RoutePlannerInterface>)currentSourcePlace {
    
    _currentSourcePlace = currentSourcePlace;
    
    // Invalidate cache
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
}

- (void)setCurrentReturnPlace:(id<RoutePlannerInterface>)currentReturnPlace {
    
    _currentReturnPlace = currentReturnPlace;
    
    // Invalidate cache
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
}

#pragma mark - Public

- (void)updateSteps:(NSArray *)newSteps shouldInvalidateCache:(BOOL)invalidateCache {
    
    NSMutableArray<RouteStep *> *parseArray = [NSMutableArray new];
    
    // Can't guarantee the steps in new steps is a RouteStep object.
    for (id object in newSteps) {
        if ([object isKindOfClass:RouteStep.class]) {
            [parseArray addObject:object];
        }
    }
    
    // Parse new steps to update the sequence order
    for (NSInteger index = 0; index < parseArray.count; index++) {
        parseArray[index].sequenceOrder = @(index);
    }
    self.route.steps = parseArray;
    
    if (invalidateCache) {
        self.cachedRouteForDriving = nil;
        self.cachedRouteForWalking = nil;
    }
}

- (void)addNewRouteStep:(RouteStep *)routeStep {
    
    NSMutableArray<RouteStep *> *newStepsArray = [NSMutableArray arrayWithArray:self.route.steps];
    [newStepsArray addObject:routeStep];
    
    // Parse new steps to update the sequence order
    for (NSInteger index = 0; index < newStepsArray.count; index++) {
        newStepsArray[index].sequenceOrder = @(index);
    }
    self.route.steps = newStepsArray;
    
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
}

- (void)removeRouteStepAtIndexPath:(NSInteger)routeStepIndex {
    
    NSMutableArray<RouteStep *> *newStepsArray = [NSMutableArray arrayWithArray:self.route.steps];
    [newStepsArray removeObjectAtIndex:routeStepIndex];
    
    // Parse new steps to update the sequence order
    for (NSInteger index = 0; index < newStepsArray.count; index++) {
        newStepsArray[index].sequenceOrder = @(index);
    }
    self.route.steps = newStepsArray;
    
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
}

- (void)checkDirectionsForRouteForTransitType:(RoutePlannerTransitType)transitType {
    
    self.currentTransitType = transitType;
    
    if ([self.delegate respondsToSelector:@selector(routePlannerDidBeginCalculatingDirections)]) {
        [self.delegate routePlannerDidBeginCalculatingDirections];
    }
    
    if (!self.currentSourcePlace) {
        
        if ([self.delegate respondsToSelector:@selector(routePlannerDidFinishCalculatingDirections)]) {
            [self.delegate routePlannerDidFinishCalculatingDirections];
        }
        
        if ([self.delegate respondsToSelector:@selector(routePlannerDidErrorWhenCalculatingRoute:errorButtonTitle:)]) {
            
            NSString *errorMessage = NSLocalizedString(@"Start location was not set", nil);
            NSString *errorButtonTitle = NSLocalizedString(@"Set Start", nil);
            [self.delegate routePlannerDidErrorWhenCalculatingRoute:errorMessage errorButtonTitle:errorButtonTitle];
        }
        
        return;
    }
    
    RoutePlannerCache *cache = [self cachedRouteForTransitType:transitType];
    if (cache) {
        if ([self.delegate respondsToSelector:@selector(routePlannerDidReturnCache:)]) {
            [self.delegate routePlannerDidReturnCache:cache];
        }
    } else {
        
        __block BOOL didErrorWhenCalculatingDirections = NO;
        __block RoutePlannerCache *newCache = [RoutePlannerCache new];
        
        CLLocationCoordinate2D source = kCLLocationCoordinate2DInvalid;
        CLLocationCoordinate2D destination = kCLLocationCoordinate2DInvalid;
        
        // Calculate the time to go to first location separately as we can't guarantee it will be finished before the calculation for the next point is finished
        
        if ([self allLocations].count > 1) {
            
            id<RoutePlannerInterface> firstPlace = [self allLocations][0];
            id<RoutePlannerInterface> secondPlace = [self allLocations][1];
            
            CLLocationCoordinate2D firstLocation = [firstPlace coordinate];
            CLLocationCoordinate2D secondLocation = [secondPlace coordinate];
            
            [self findDirectionsFromFirstLocation:firstLocation
                                   secondLocation:secondLocation
                                      transitType:transitType
                                      updateCache:newCache];
        }
        
        dispatch_group_t group = dispatch_group_create();
        
        for (int i = 0; i< [self allLocations].count; i++ ) {
            
            id<RoutePlannerInterface> place = [self allLocations][i];
            
            CLLocationCoordinate2D coordinate = [place coordinate];
            
            if (i==0)
            {
                source = coordinate;
                
            } else if (i == 1) {
                
                destination = coordinate;
                
            } else {
                
                id<RoutePlannerInterface> prevPlace = [self allLocations][i-1];
                source = [prevPlace coordinate];
                destination = coordinate;
            }
            
            if (i > 0) {
                if (CLLocationCoordinate2DIsValid(source) && CLLocationCoordinate2DIsValid(destination)) {
                    
                    dispatch_group_enter(group);
                    [self findDirectionsFrom:source
                                          to:destination
                              forTransitType:transitType
                             completionBlock:^(MKRoute *route) {
                                 
                                 if (!route) {
                                     didErrorWhenCalculatingDirections = YES;
                                 } else {
                                     
                                     newCache.timeTravelled += route.expectedTravelTime;
                                     newCache.distanceTravelled += route.distance;
                                     
                                     [newCache.mapRoutes addObject:route];
                                     if ([self.delegate respondsToSelector:@selector(routePlannerShouldAddRoute:)]) {
                                         [self.delegate routePlannerShouldAddRoute:route];
                                     }
                                     
                                 }
                                 dispatch_group_leave(group);
                             }];
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self.delegate respondsToSelector:@selector(routePlannerDidUpdateTotalDistance:totalTime:)]) {
                    [self.delegate routePlannerDidUpdateTotalDistance:newCache.distanceTravelled totalTime:newCache.timeTravelled];
                }
                
                if ([self.delegate respondsToSelector:@selector(routePlannerDidFinishCalculatingDirections)]) {
                    [self.delegate routePlannerDidFinishCalculatingDirections];
                }
                
                if ([self.delegate respondsToSelector:@selector(routePlannerDidErrorWhenCalculatingRoute:errorButtonTitle:)]) {
                    
                    NSString *errorMessage = didErrorWhenCalculatingDirections ? NSLocalizedString(@"Could not calculate the route in the meantime", nil) : @"";
                    NSString *errorButtonTitle = NSLocalizedString(@"Try again", nil);
                    [self.delegate routePlannerDidErrorWhenCalculatingRoute:errorMessage errorButtonTitle:errorButtonTitle];
                }
                
                // Only cache the results if no errors occurred when calculating directions.
                if (!didErrorWhenCalculatingDirections) {
                    [self setCacheRoute:newCache forTransitType:transitType];
                }
            });
        });
    }
}

- (BOOL)hasExistingPlace:(id<RoutePlannerInterface>)place {
    
    CLLocationCoordinate2D locationToCompare = [place coordinate];
    
    for (RouteStep *step in self.route.steps) {
        
        CLLocationCoordinate2D stepLocation = [step coordinate];
        if (stepLocation.latitude == locationToCompare.latitude &&
            stepLocation.longitude == locationToCompare.longitude) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Cache

- (void)handleReceivedInvalidateCacheNotification {
    
    self.cachedRouteForDriving = nil;
    self.cachedRouteForWalking = nil;
}

- (RoutePlannerCache *)cachedRouteForTransitType:(RoutePlannerTransitType)transitType {
    
    switch (transitType) {
        case RoutePlannerTransitTypeWalk:
            return self.cachedRouteForWalking;
        case RoutePlannerTransitTypeDrive:
            return self.cachedRouteForDriving;
        default:
            return nil;
    }
}

- (void)setCacheRoute:(RoutePlannerCache *)cacheRoute forTransitType:(RoutePlannerTransitType)transitType {
    
    switch (transitType) {
        case RoutePlannerTransitTypeWalk:
            self.cachedRouteForWalking = cacheRoute;
            break;
        case RoutePlannerTransitTypeDrive:
            self.cachedRouteForDriving = cacheRoute;
            break;
        default:
            break;
    }
}

#pragma mark - Helpers

- (void)findDirectionsFromFirstLocation:(CLLocationCoordinate2D)firstLocation
                         secondLocation:(CLLocationCoordinate2D)secondLocation
                            transitType:(RoutePlannerTransitType)transitType
                            updateCache:(RoutePlannerCache *)cache {
    
    [self findDirectionsFrom:firstLocation
                          to:secondLocation
              forTransitType:transitType
             completionBlock:^(MKRoute *route) {
                 
                 if (route) {
                     [cache.mapRoutes addObject:route];
                     cache.firstTimeTravelled = route.expectedTravelTime;
                     
                     if ([self.delegate respondsToSelector:@selector(routePlannerDidUpdateTimeForFirstVenue:)]) {
                         [self.delegate routePlannerDidUpdateTimeForFirstVenue:route.expectedTravelTime];
                     }
                     
                     if ([self.delegate respondsToSelector:@selector(routePlannerShouldAddRoute:)]) {
                         [self.delegate routePlannerShouldAddRoute:route];
                     }
                 }
             }];
    
}

- (void)findDirectionsFrom:(CLLocationCoordinate2D)sourceCoords
                        to:(CLLocationCoordinate2D)destinationCoords
            forTransitType:(RoutePlannerTransitType)transitType
           completionBlock:(void (^)(MKRoute *route))completionBlock {
    
    NSNumber *hashKey = [self hashKeyForSourceCoordinate:sourceCoords
                                   destinationCoordinate:destinationCoords
                                             transitType:transitType];
    
    if (self.cacheDistanceForRoute[hashKey]) {
        
        if (completionBlock) {
            completionBlock(self.cacheDistanceForRoute[hashKey]);
        }
    } else {
        
        MKPlacemark *sourcePlacemaker = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
        MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemaker];
        
        MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        request.source = source;
        
        switch (transitType) {
            case RoutePlannerTransitTypeWalk: {
                request.transportType = MKDirectionsTransportTypeWalking;
                break;
            }
            case RoutePlannerTransitTypeDrive: {
                request.transportType = MKDirectionsTransportTypeAutomobile;
                break;
            }
            default:
                break;
        }
        
        request.destination = destination;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                completionBlock(nil);
            } else {
                
                MKRoute *route = [response.routes firstObject];
                
                // Store calculated route in dictionary
                CLLocationCoordinate2D resultSourceCoordinate = response.source.placemark.coordinate;
                CLLocationCoordinate2D resultDestinationCoordinate = response.destination.placemark.coordinate;
                
                NSNumber *newHashKey = [self hashKeyForSourceCoordinate:resultSourceCoordinate
                                                  destinationCoordinate:resultDestinationCoordinate
                                                          transportType:route.transportType];
                self.cacheDistanceForRoute[newHashKey] = route;
                
                if (completionBlock) {
                    completionBlock(route);
                }
            }
        }];
    }
}

#pragma mark - Helper

//- (NSArray<id<RoutePlannerInterface> *)routePoints {
//    return @[];
//}

- (NSArray<id<RoutePlannerInterface>> *)allLocations {
    
    NSMutableArray<id<RoutePlannerInterface>> *allLocations = [NSMutableArray new];
    
    if (self.currentSourcePlace) {
        [allLocations addObject:self.currentSourcePlace];
    }
    
    [allLocations addObjectsFromArray:self.route.steps];
    
    if (self.currentReturnPlace) {
        [allLocations addObject:self.currentReturnPlace];
    }
    
    return allLocations;
}

- (NSNumber *)hashKeyForSourceCoordinate:(CLLocationCoordinate2D)sourceCoordinate
                   destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate
                             transitType:(RoutePlannerTransitType)transitType {
    NSInteger prime = 1;
    switch (transitType) {
        case RoutePlannerTransitTypeWalk:
            prime = RoutePlannerWalkTransitPrime;
            break;
        case RoutePlannerTransitTypeDrive:
            prime = RoutePlannerDriveTransitPrime;
        default:
            break;
    }
    
    NSString *combineString = [NSString stringWithFormat:@"%ld%f%f%f%f", (long)prime, sourceCoordinate.latitude, sourceCoordinate.longitude, destinationCoordinate.latitude, destinationCoordinate.longitude];
    
    return @([combineString hash]);
}

- (NSNumber *)hashKeyForSourceCoordinate:(CLLocationCoordinate2D)sourceCoordinate
                   destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate
                           transportType:(MKDirectionsTransportType)transportType {
    
    NSInteger prime = 1;
    switch (transportType) {
        case MKDirectionsTransportTypeWalking:
            prime = RoutePlannerWalkTransitPrime;
            break;
        case MKDirectionsTransportTypeAutomobile:
            prime = RoutePlannerDriveTransitPrime;
        default:
            break;
    }
    
    NSString *combineString = [NSString stringWithFormat:@"%ld%f%f%f%f", (long)prime, sourceCoordinate.latitude, sourceCoordinate.longitude, destinationCoordinate.latitude, destinationCoordinate.longitude];
    
    return @([combineString hash]);
}

@end
