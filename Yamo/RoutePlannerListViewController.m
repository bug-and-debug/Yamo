//
//  RoutePlannerListViewController.m
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerListViewController.h"
#import "RoutePlannerCollectionDataController.h"
@import UIView_LOCExtensions;

@interface RoutePlannerListViewController () <RoutePlannerCollectionViewDataControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) RoutePlannerCollectionDataController *dataController;

@end

@implementation RoutePlannerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.needsUpdateContentsLayout = YES;
    
    RoutePlannerCollectionViewLayout *flowLayout = [RoutePlannerCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    [self.view pinView:self.collectionView];
    
    self.dataController = [[RoutePlannerCollectionDataController alloc] initWithCollectionView:self.collectionView];
    self.dataController.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.needsUpdateContentsLayout) {
        [self.dataController reloadData];
        self.needsUpdateContentsLayout = NO;
    }
}

- (void)forceReloadData {
    
    [self.dataController reloadData];
}

#pragma mark - RoutePlannerCollectionViewDataControllerDelegate

- (RoutePlannerCoordinator *)consultRoutePlanner {
    return [self.delegate consultParentRoutePlanner];
}

- (void)routePlannerControllerIsDeletingSteps:(BOOL)deletingStep {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerListViewControllerIsDeletingSteps:)]) {
        [self.delegate routePlannerListViewControllerIsDeletingSteps:deletingStep];
    }
}

- (void)routePlannerControllerDidChangeStepsSequence:(BOOL)didChangeSequence {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerListViewControllerDidChangeSequence:)]) {
        [self.delegate routePlannerListViewControllerDidChangeSequence:didChangeSequence];
    }
}

- (void)routePlannerControllerDidPressUpdateLocationForSource:(BOOL)isSource {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerListViewControllerDidPressUpdateLocationForSource:)]) {
        [self.delegate routePlannerListViewControllerDidPressUpdateLocationForSource:isSource];
    }
}

- (void)routePlannerControllerDidPressAddNewLocation {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerListViewControllerDidPressAddNewLocation)]) {
        [self.delegate routePlannerListViewControllerDidPressAddNewLocation];
    }
}

@end
