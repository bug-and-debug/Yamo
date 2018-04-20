//
//  RoutePlannerListViewController.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoutePlannerCoordinator;

@protocol RoutePlannerListViewControllerDelegate;

@interface RoutePlannerListViewController : UIViewController

@property (nonatomic) BOOL needsUpdateContentsLayout;

@property (nonatomic) BOOL didChangeSequenceOfSteps;

@property (nonatomic, weak) id<RoutePlannerListViewControllerDelegate> delegate;

- (void)forceReloadData;

@end

@protocol RoutePlannerListViewControllerDelegate <NSObject>

- (RoutePlannerCoordinator *)consultParentRoutePlanner;

- (void)routePlannerListViewControllerIsDeletingSteps:(BOOL)deletingSteps;

- (void)routePlannerListViewControllerDidChangeSequence:(BOOL)didChangeSequence;

- (void)routePlannerListViewControllerDidPressUpdateLocationForSource:(BOOL)source;

- (void)routePlannerListViewControllerDidPressAddNewLocation;

@end
