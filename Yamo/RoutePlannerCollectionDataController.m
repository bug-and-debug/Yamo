//
//  RoutePlannerCollectionDataController.m
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionDataController.h"
#import "RoutePlannerCoordinator.h"
#import "UICollectionView+Draggable.h"
#import "Route.h"
#import "RouteStep.h"
#import "Venue.h"
#import "Place.h"
#import "TempPlace.h"

static NSInteger RoutePlannerStartSection = 0;
static NSInteger RoutePlannerStepsSection = 1;
static NSInteger RoutePlannerReturnSection = 2;

static CGFloat RoutePlannerNewCellHeight = 54.0f;
static CGFloat RoutePlannerNewCellBottomPadding = 16.0f;

@interface RoutePlannerCollectionDataController () <UICollectionViewDelegate, UICollectionViewDataSource_Draggable, UICollectionViewDelegateFlowLayout, RoutePlannerCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *aCollectionView;

// temporaryDataSource is a array with the items in the data source. It is used when the user
// starts dragging cells in the collection view, we need to calculate the expected size of the cell
// but because the items in the array do not change (and should not change until either
// draggableCollectionView:moveItemAtIndexPath:toIndexPath or collectionView:moveItemAtIndexPath:toIndexPath: are called)
@property (nonatomic, strong) NSMutableArray *temporaryDataSource;

//// isCurrentlyDraggingCollectionView is set to true when you try and move an item in the collection view
//// Used to determine which data source to calculate the size of the collection view
//@property (nonatomic) BOOL isCurrentlyDraggingCollectionView;

@property (nonatomic) BOOL didAddReturnAddress;

@property (nonatomic, strong) NSIndexPath *draggingIndexPath;

@end

@implementation RoutePlannerCollectionDataController

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    
    if (self = [super init]) {
        _aCollectionView = collectionView;
        
        [self setupCollectionView];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupCollectionView {
    
    self.aCollectionView.delegate = self;
    self.aCollectionView.dataSource = self;
    self.aCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 9.0) {
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self.aCollectionView addGestureRecognizer:longPressGesture];
    } else {
        self.aCollectionView.draggable = YES;
    }
    self.aCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.aCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(RoutePlannerVenueCollectionViewCell.class) bundle:nil]
           forCellWithReuseIdentifier:NSStringFromClass(RoutePlannerVenueCollectionViewCell.class)];
    
    [self.aCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(RoutePlannerPlaceCollectionViewCell.class) bundle:nil]
           forCellWithReuseIdentifier:NSStringFromClass(RoutePlannerPlaceCollectionViewCell.class)];
    
    [self.aCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(RoutePlannerNewCollectionViewCell.class) bundle:nil]
           forCellWithReuseIdentifier:NSStringFromClass(RoutePlannerNewCollectionViewCell.class)];
}

#pragma mark - Gesture Recognizer

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectedIndexPath = [self.aCollectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.aCollectionView]];
            if (selectedIndexPath) {
                [self.aCollectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            [self.aCollectionView updateInteractiveMovementTargetPosition:CGPointMake(CGRectGetWidth(self.aCollectionView.bounds) / 2, [gestureRecognizer locationInView:self.aCollectionView].y)];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            [self.aCollectionView endInteractiveMovement];
            break;
        }
        default: {
            
            [self.aCollectionView cancelInteractiveMovement];
            break;
        }
    }
}

#pragma mark - Public

- (void)reloadData {
    
    [self.aCollectionView.collectionViewLayout invalidateLayout];
    [self.aCollectionView reloadData];
}

#pragma mark - Data

- (NSArray *)dataSource {
    
    return [self.delegate consultRoutePlanner].route.steps;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    // Section 0: Source Location
    // Section 1: The route steps
    // Section 2: Add new route and Return location
    return 3;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self collectionViewLayout].deleteMode) {
        // if first row and a current source place has yet to be selected.
        if (indexPath.section == RoutePlannerStartSection) {
            
            [self didPressChangeLocationCellIsSource:YES];
        }
        
        if (indexPath.section == RoutePlannerReturnSection) {
            
            if (indexPath.row == 0) {
                
                // Selected add another location
                if ([self.delegate respondsToSelector:@selector(routePlannerControllerDidPressAddNewLocation)]) {
                    [self.delegate routePlannerControllerDidPressAddNewLocation];
                }
            }
            
            if (indexPath.row == 1) {
                //  Select return location
                [self didPressChangeLocationCellIsSource:NO];
            }
        }
    }
}

#pragma mark - Helper

- (RoutePlannerPlaceCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                          placeCellForRoutePlannerModel:(id<RoutePlannerInterface>)model
                                           forIndexPath:(NSIndexPath *)indexPath {
    
    RoutePlannerPlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RoutePlannerPlaceCollectionViewCell.class) forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self collectionViewLayout].deleteMode) {
        
        [cell updateLayoutForDeleteMode];
    } else {
        NSString *locationName = @"";
        
        if ([model isKindOfClass:[Place class]]) {
            
            Place *place = (Place *)model;
            switch (place.placeType) {
                case PlaceTypeHome: {
                    locationName = NSLocalizedString(@"Your Home", nil);
                    break;
                }
                case PlaceTypeWork: {
                    locationName = NSLocalizedString(@"Your Work", nil);
                    break;
                }
                default:
                    break;
            }
        } else if ([model isKindOfClass:TempPlace.class]) {
            
            locationName = ((TempPlace *)model).locationName;
        }
        
        BOOL isSource = NO;
        if (indexPath.row == 0) {
            isSource = YES;
        }
        
        [cell populateCollectionCellForLocation:locationName isSource:isSource];
        
    }
    return cell;
}

- (RoutePlannerCollectionViewCell *)cellForSourceSectionInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate consultRoutePlanner].currentSourcePlace) {
        
        id currentSourcePlace = [self.delegate consultRoutePlanner].currentSourcePlace;
        return [self collectionView:collectionView placeCellForRoutePlannerModel:currentSourcePlace forIndexPath:indexPath];
    } else {
        
        RoutePlannerNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RoutePlannerNewCollectionViewCell.class) forIndexPath:indexPath];
        [cell updateAppearanceForType:RoutePlannerNewCellTypeAddStart];
        return cell;
    }
}

- (RoutePlannerCollectionViewCell *)cellForReturnSectionInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    
    RoutePlannerNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RoutePlannerNewCollectionViewCell.class) forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        [cell updateAppearanceForType:RoutePlannerNewCellTypeAddNew];
    } else {
        if ([self.delegate consultRoutePlanner].currentReturnPlace) {
            
            id currentReturnPlace = [self.delegate consultRoutePlanner].currentReturnPlace;
            return [self collectionView:collectionView placeCellForRoutePlannerModel:currentReturnPlace forIndexPath:indexPath];
        } else {
            [cell updateAppearanceForType:RoutePlannerNewCellTypeAddReturn];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == RoutePlannerStartSection) {
        return [self cellForSourceSectionInCollectionView:collectionView atIndexPath:indexPath];
    }
    
    if (indexPath.section == RoutePlannerStepsSection) {
        
        id model = [self dataSource][indexPath.row];
        
        if (indexPath.section == self.draggingIndexPath.section &&
            indexPath.row == self.draggingIndexPath.row &&
            [self.delegate consultRoutePlanner].route.steps.count > 1) {
            model = [self dataSource][indexPath.row - 1];
        }
        
        if ([model isKindOfClass:[RouteStep class]]) {
            
            RoutePlannerVenueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RoutePlannerVenueCollectionViewCell.class) forIndexPath:indexPath];
            cell.delegate = self;
            [cell populateCollectionCellForStep:model canDelete:[self collectionViewLayout].deleteMode];
            return cell;
            
        } else {
            return [self collectionView:collectionView placeCellForRoutePlannerModel:model forIndexPath:indexPath];
        }
    }
    
    if (indexPath.section == RoutePlannerReturnSection) {
        return [self cellForReturnSectionInCollectionView:collectionView atIndexPath:indexPath];
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self dataSource].count;
        case 2:
            return [self collectionViewLayout].deleteMode ? 0 : 2;
        default:
            return 0;
    }
}

#pragma mark Move Row

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    
    [self collectionViewSwapItemsAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
//    self.isCurrentlyDraggingCollectionView = NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    self.isCurrentlyDraggingCollectionView = YES;
    self.temporaryDataSource = [self dataSource].mutableCopy;
    return [self collectionViewCanSwapItemsAtIndexPath:indexPath];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    
    if (proposedIndexPath.section == RoutePlannerStartSection) {
        proposedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    if (proposedIndexPath.section == RoutePlannerReturnSection) {
        // Last row in section 1
        NSInteger numberOfRowsInMainSection = [self dataSource].count;
        proposedIndexPath = [NSIndexPath indexPathForRow:numberOfRowsInMainSection - 1
                                               inSection:1];
    }
    
    // Update temporary date source
    id data = self.temporaryDataSource[originalIndexPath.row];
    [self.temporaryDataSource removeObjectAtIndex:originalIndexPath.row];
    [self.temporaryDataSource insertObject:data atIndex:proposedIndexPath.row];
    
    return proposedIndexPath;
}

#pragma mark - UICollectionViewDataSource_Draggable

- (void)draggableCollectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self collectionViewSwapItemsAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    [self reloadData];
}

- (BOOL)draggableCollectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionViewCanSwapItemsAtIndexPath:indexPath];
}

- (BOOL)draggableCollectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Can only swap if there is more than 1 step or if it's not delete mode
    if ([self dataSource].count <= 1 || [self collectionViewLayout].deleteMode) {
        return NO;
    }
    
    if (toIndexPath.section == RoutePlannerStartSection) {
        return NO;
    }
    
    if (toIndexPath.section == RoutePlannerReturnSection) {
        return NO;
    }
    
    // Update temporary date source but has to reset it with the original data source
    self.temporaryDataSource = [self dataSource].mutableCopy;
    id data = self.temporaryDataSource[indexPath.row];
    [self.temporaryDataSource removeObjectAtIndex:indexPath.row];
    [self.temporaryDataSource insertObject:data atIndex:toIndexPath.row];
    
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == RoutePlannerStartSection) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), RoutePlannerNewCellHeight);
    }
    
    if (indexPath.section == RoutePlannerStepsSection) {
        
        if ([self dataSource].count > indexPath.row) {
            id model = [self dataSource][indexPath.row];
            
            if ([model isKindOfClass:[RouteStep class]]) {
                RouteStep *step;
                
                // Use temporary array when dragging
                if (collectionView.isDragging || self.draggingIndexPath) {
                    step = self.temporaryDataSource[indexPath.row];
                } else {
                    step = [self dataSource][indexPath.row];
                }
                
                if (step) {
                    return CGSizeMake(CGRectGetWidth(collectionView.bounds), [RoutePlannerVenueCollectionViewCell calculateCellHeightForStep:step]);
                }
            } else if ([model conformsToProtocol:@protocol(RoutePlannerInterface)]) {
                
                return CGSizeMake(CGRectGetWidth(collectionView.bounds), [RoutePlannerPlaceCollectionViewCell calculateCellHeightForLocation:@"Your Location"]);
            }
        }
    }
    
    if (indexPath.section == RoutePlannerReturnSection) {
        
        if (indexPath.row == 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), RoutePlannerNewCellHeight);
            
        } else if (indexPath.row == 1) {
            
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), RoutePlannerNewCellHeight + RoutePlannerNewCellBottomPadding);
        }
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - Common Swap Logic

- (BOOL)collectionViewCanSwapItemsAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == RoutePlannerStartSection) {
        return NO;
    }
    
    if (indexPath.section == RoutePlannerReturnSection) {
        return NO;
    }
    
    // Can only swap if there is more than 1 step.
    if ([self dataSource].count <= 1 || [self collectionViewLayout].deleteMode) {
        return NO;
    }
    
    self.draggingIndexPath = indexPath;
    self.temporaryDataSource = [self dataSource].mutableCopy;
    
    return YES;
}

- (void)collectionViewSwapItemsAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (destinationIndexPath.section == RoutePlannerStartSection) {
        self.draggingIndexPath = nil;
        return;
    }
    if (destinationIndexPath.section == RoutePlannerReturnSection) {
        self.draggingIndexPath = nil;
        return;
    }
    
    [self.aCollectionView performBatchUpdates:^{
        
        // Update steps in data source
        RouteStep *updatedStep = [self dataSource][sourceIndexPath.row];
        NSMutableArray *updatedArray = [self dataSource].mutableCopy;
        [updatedArray removeObjectAtIndex:sourceIndexPath.row];
        [updatedArray insertObject:updatedStep atIndex:destinationIndexPath.row];
        
        [[self.delegate consultRoutePlanner] updateSteps:updatedArray shouldInvalidateCache:YES];
    } completion:^(BOOL finished) {
        
        self.draggingIndexPath = nil;
        [self reloadData];
        
        if ([self.delegate respondsToSelector:@selector(routePlannerControllerDidChangeStepsSequence:)]) {
            [self.delegate routePlannerControllerDidChangeStepsSequence:YES];
        }
        
        [self.aCollectionView reloadSections:[NSIndexSet indexSetWithIndex:RoutePlannerStepsSection]];
    }];
}

#pragma mark - RoutePlannerCollectionViewCellDelegate

- (void)routePlannerCollectionViewCellDidPressAnnotationForCell:(RoutePlannerCollectionViewCell *)cell {
    
    if ([self collectionViewLayout].deleteMode) {
        
        NSIndexPath *indexPathForCell = [self.aCollectionView indexPathForCell:cell];
        [[self.delegate consultRoutePlanner] removeRouteStepAtIndexPath:indexPathForCell.row];
        [self.aCollectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(routePlannerControllerDidChangeStepsSequence:)]) {
            [self.delegate routePlannerControllerDidChangeStepsSequence:YES];
        }
    }
}

- (void)routePlannerCollectionViewCellDidPressChangeLocation:(RoutePlannerCollectionViewCell *)cell isSource:(BOOL)isSource {
    
    [self collectionViewLayout].deleteMode = ![self collectionViewLayout].deleteMode;
    
    if ([self.delegate respondsToSelector:@selector(routePlannerControllerIsDeletingSteps:)]) {
        [self.delegate routePlannerControllerIsDeletingSteps:[self collectionViewLayout].deleteMode];
    }
    
    [self reloadData];
}

#pragma mark - Helper

- (void)didPressChangeLocationCellIsSource:(BOOL)isSource {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerControllerDidPressUpdateLocationForSource:)]) {
        [self.delegate routePlannerControllerDidPressUpdateLocationForSource:isSource];
    }
}

- (RoutePlannerCollectionViewLayout *)collectionViewLayout {
    
    return (RoutePlannerCollectionViewLayout *)self.aCollectionView.collectionViewLayout;
}

@end
