//
//  RoutePlanner.h
//  Yamo
//
//  Created by Peter Su on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutePlannerInterface.h"

@class Route;
@class RouteStep;
@class Venue;
@class Place;
@import MapKit;

@protocol RoutePlannerCoordinatorDelegate;

typedef NS_ENUM(NSInteger, RoutePlannerTransitType) {
    RoutePlannerTransitTypeWalk,
    RoutePlannerTransitTypeDrive
};

extern NSString * const RoutePlannerInvalidateCacheNotification;

@interface RoutePlannerCache : NSObject

@property (nonatomic, readonly) double firstTimeTravelled;

@property (nonatomic, readonly) double timeTravelled;

@property (nonatomic, readonly) double distanceTravelled;

@property (nonatomic, strong, readonly) NSMutableArray<MKRoute *> *mapRoutes;

@end

@interface RoutePlannerCoordinator : NSObject

@property (nonatomic, strong, readonly) Route *route;

@property (nonatomic, strong) id<RoutePlannerInterface> currentSourcePlace;

@property (nonatomic, strong) id<RoutePlannerInterface> currentReturnPlace;

@property (nonatomic, weak) id<RoutePlannerCoordinatorDelegate> delegate;

- (instancetype)initWithRoute:(Route *)route;

- (void)updateSteps:(NSArray *)newSteps shouldInvalidateCache:(BOOL)invalidateCache;

- (void)addNewRouteStep:(RouteStep *)routeStep;

- (void)removeRouteStepAtIndexPath:(NSInteger)routeStepIndex;

- (void)checkDirectionsForRouteForTransitType:(RoutePlannerTransitType)transitType;

- (BOOL)hasExistingPlace:(id<RoutePlannerInterface>)place;

@end

@protocol RoutePlannerCoordinatorDelegate <NSObject>

- (void)routePlannerDidBeginCalculatingDirections;

- (void)routePlannerDidFinishCalculatingDirections;

- (void)routePlannerDidUpdateTimeForFirstVenue:(double)nextTime;

- (void)routePlannerDidUpdateTotalDistance:(double)totalDistance totalTime:(double)totalTime;

- (void)routePlannerShouldAddRoute:(MKRoute *)route;

- (void)routePlannerDidErrorWhenCalculatingRoute:(NSString *)errorMessage errorButtonTitle:(NSString *)buttonTitle;

- (void)routePlannerDidReturnCache:(RoutePlannerCache *)cache;

@end
