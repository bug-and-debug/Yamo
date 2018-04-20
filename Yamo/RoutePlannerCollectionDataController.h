//
//  RoutePlannerCollectionDataController.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutePlannerVenueCollectionViewCell.h"
#import "RoutePlannerPlaceCollectionViewCell.h"
#import "RoutePlannerNewCollectionViewCell.h"
#import "RoutePlannerCollectionViewLayout.h"

@class RoutePlannerCoordinator;

@protocol RoutePlannerCollectionViewDataControllerDelegate;

@interface RoutePlannerCollectionDataController : NSObject

@property (nonatomic, weak) id<RoutePlannerCollectionViewDataControllerDelegate> delegate;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

- (void)reloadData;

@end

@protocol RoutePlannerCollectionViewDataControllerDelegate <NSObject>

- (RoutePlannerCoordinator *)consultRoutePlanner;

- (void)routePlannerControllerIsDeletingSteps:(BOOL)deletingStep;

- (void)routePlannerControllerDidChangeStepsSequence:(BOOL)didChangeSequence;

- (void)routePlannerControllerDidPressUpdateLocationForSource:(BOOL)isSource;

- (void)routePlannerControllerDidPressAddNewLocation;

@end

