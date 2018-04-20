//
//  ExploreMapViewController.m
//  Yamo
//
//  Created by Mo Moosa on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ExploreMapViewController.h"
#import "Yamo-Swift.h"
#import "UIColor+Tools.h"
#import "ExploreMapDataController.h"
#import "MapPlacesViewController.h"
#import "PlacesDataController.h"
#import "ExploreMapView.h"
#import <GoogleMaps/GoogleMaps.h>

@import UIView_LOCExtensions;

CGFloat const ExhibitionInfoCellHeight = 115.0f;

@interface ExploreMapViewController () <UIGestureRecognizerDelegate, ExploreMapDataControllerDelegate, ExhibitionInfoViewControllerDelegate, MapPlacesViewControllerDelegate>

@property (nonatomic) IBOutlet ExploreMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *locationButtonBottomConstraint;
@property (nonatomic, weak) IBOutlet UIButton *listButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *listButtonBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *locationButtonBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *childContainerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *childViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UIButton *changeLocationButton;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIView *bannerView;
@property (nonatomic, weak) IBOutlet GMSMapView *googleMapView;
@property (nonatomic) CGFloat currentSummaryHeight;

@property (nonatomic) ExhibitionInfoViewController *exhibitionViewController;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) BOOL viewDidAppear;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) NSMutableArray *testLocations;
@property (nonatomic) ExploreMapDataController *dataController;
@property (nonatomic) BOOL isMovingToUserLocation;
@property (nonatomic) UIView *fakeMapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerTopConstraint;

@property (nonatomic) BOOL needsScaleToClosestVenue;

@end

@implementation ExploreMapViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Flurry logEvent:@"Browse-Exhibition"];
    
    self.dataController = [[ExploreMapDataController alloc] initWithMapViews:self.mapView GooleMap:self.googleMapView];
    self.dataController.delegate = self;
    
    self.needsScaleToClosestVenue = YES;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.childContainerView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    self.panGestureRecognizer.delegate = self;
    
    [self.childContainerView addGestureRecognizer:self.panGestureRecognizer];
    
    [self addExhibitionInfoChildViewController];
    
    [self.exhibitionViewController exhibitionShouldEnableScroll:NO];
    [self.exhibitionViewController showTopbar:NO animated:NO];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
    [self.exhibitionViewController.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self setupSwitchButton];
    
    if (!self.viewDidAppear) {
        
        self.mapViewState = ExploreMapViewStateHidden;
    }

    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoGray],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Change", nil) attributes:attributes];
    [self.changeLocationButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    self.locationLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f];
    self.bannerView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bannerView.layer.shadowOpacity = 0.5f;
    
    [self requestInitialLocationName:^(NSString *name, NSError *error) {
       
        if (error) {
            
            NSLog(@"Error trying to fetch location in Map View: %@", error);
        }
        else {
            
            self.locationLabel.text = name;
        }
    }];
    
    self.currentSummaryHeight = 0.0;
    
}

- (void) closeFullExhibition
{
    [self.delegate exploreMapViewControllerDidHideFullExhibition:self];
    
    [self.view layoutIfNeeded];
    
    self.childViewBottomConstraint.constant = -(CGRectGetHeight(self.childContainerView.bounds));
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
    [self didUpdateChildViewBottomConstraint];
}

- (void)updateMapLocation:(BOOL)isUpdatedLocation {
    
    if (self.mapView.location.latitude != 0 || self.mapView.location.longitude != 0) {
        if (isUpdatedLocation) {
            self.googleMapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.location.latitude longitude:self.mapView.location.longitude zoom:13];
        }
        
        [self.dataController setupData:[self.delegate exploreMapViewControllerConsultParentForData:self]];
    }
}

- (void)requestInitialLocationName:(void (^ __nullable)(NSString *name, NSError *error))completion {
 
    CLGeocoder *geocoder = [CLGeocoder new];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mapView.location.latitude longitude:self.mapView.location.longitude];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *name = [PlacesDataController nameForPlacemark:placemarks.firstObject];
        
        if (error) {
            
        }
        if (completion) {
            
            completion(name, error);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    self.bannerTopConstraint.constant = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldShowImageForMap) {
        
        self.fakeMapView = [self.view
                            snapshotViewAfterScreenUpdates:YES];
        [self.view addSubview:self.fakeMapView];
        [self.view pinView:self.fakeMapView];
        self.mapView.hidden = YES;
        
    }

    if (self.mapViewState == ExploreMapViewStateHidden) {
        self.mapViewState = ExploreMapViewStateHidden;
    }
    
    self.viewDidAppear = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.mapViewState == ExploreMapViewStateHidden) {
        self.childViewBottomConstraint.constant = -CGRectGetHeight(self.childContainerView.bounds);
        [self didUpdateChildViewBottomConstraint];
    }
    
    self.locationButtonBackgroundView.layer.cornerRadius = self.locationButtonBackgroundView.frame.size.height * 0.5f;
}

- (void)selectVenue:(VenueSearchSummary *)venue {
    
    [self.mapView selectAnnotation:venue];
}

#pragma mark - Setters

- (void)setShouldShowImageForMap:(BOOL)shouldShowImageForMap {
    
    _shouldShowImageForMap = shouldShowImageForMap;
    
    if (!_shouldShowImageForMap) {
        
        [self.mapView moveToCurrentUserLocationAnimated:NO];
        
        self.mapView.hidden = NO;

        [self.fakeMapView removeFromSuperview];
        self.fakeMapView = nil;
        
    }
}

#pragma mark - Setup

- (void)setupSwitchButton {
    
    self.listButton.backgroundColor = [UIColor whiteColor];
    self.listButton.layer.cornerRadius = CGRectGetWidth(self.listButton.frame) / 2;
}

#pragma mark - Actions

- (IBAction)handleDidPressShareButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(exploreMapViewControllerDidPressShareButton:)]) {
        
        [self.delegate exploreMapViewControllerDidPressShareButton:self];
    }
}

- (IBAction)handleDidPressListButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(exploreMapViewControllerDidPressListButton:)]) {
        
        [self.delegate exploreMapViewControllerDidPressListButton:self];
    }
}

- (IBAction)handleDidPressLocationButton:(id)sender {
    
    self.isMovingToUserLocation = YES;
    
    self.needsScaleToClosestVenue = YES;
    
    [self.locationButton setImage:[UIImage imageNamed:@"Icondarklocationactive 1"] forState:UIControlStateNormal];

    self.mapView.isSelectedLocation = NO;
    [self.mapView resetToUsersPhysicalLocation];
}

- (IBAction)handleChangeLocationButton:(id)sender {
    
    MapPlacesViewController *placesViewController = [MapPlacesViewController new];
    
    placesViewController.delegate = self;
    
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:placesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if (self.mapViewState == ExploreMapViewStateFull) {
        
        [self.exhibitionViewController exhibitionShouldEnableScroll:YES];
        return;
    }
    
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    location.y = location.y - 64;
    
    if (location.y > 0 && location.y < CGRectGetHeight(self.childContainerView.frame)) {
        
        self.childViewBottomConstraint.constant = - location.y;
        [self didUpdateChildViewBottomConstraint];
    }
    
    if (self.mapViewState != ExploreMapViewStateTransition) {
        
        self.mapViewState = ExploreMapViewStateTransition;
    }
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        
        CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
        
        CGFloat velocityOffset = 100;
        
        if (velocity.y < - velocityOffset) {
            
            self.mapViewState = ExploreMapViewStateFull;
        }
        else if (velocity.y > velocityOffset) {
            
            if (self.childViewBottomConstraint.constant > -(ExhibitionInfoCellHeight)) {
                self.mapViewState = ExploreMapViewStatePeek;
            } else {
                self.mapViewState = ExploreMapViewStateHidden;
            }
        }
        else {
            
            if (location.y > CGRectGetHeight(self.childContainerView.frame) / 2) {
                
                if (location.y > CGRectGetHeight(self.childContainerView.frame) - ExhibitionInfoCellHeight) {
                    self.mapViewState = ExploreMapViewStateHidden;
                }
                else {
                    self.mapViewState = ExploreMapViewStatePeek;
                }
                
            }
            else {
                
                self.mapViewState = ExploreMapViewStateFull;
            }
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    self.mapViewState = ExploreMapViewStateFull;
}

- (void)didUpdateChildViewBottomConstraint {
    
    CGFloat expectedBottomConstraint = self.childViewBottomConstraint.constant + CGRectGetHeight(self.view.bounds);
    
    if (((NSInteger)expectedBottomConstraint) <= ((NSInteger)self.currentSummaryHeight)) {
        
        CGFloat defaultBottomPadding = 8;
        
        self.listButtonBottomConstraint.constant = expectedBottomConstraint + defaultBottomPadding;
        self.locationButtonBottomConstraint.constant = expectedBottomConstraint + defaultBottomPadding;
    }
}


#pragma mark - Map State

- (void)setMapViewState:(ExploreMapViewState)mapViewState {
    _mapViewState = mapViewState;
    [self updateLayoutForStateWithAnimationDuration:self.animationDuration];

}

- (void)updateLayoutForStateWithAnimationDuration:(NSTimeInterval)duration {

    CGFloat existingConstraintConstant = self.childViewBottomConstraint.constant;
    
    switch (self.mapViewState) {
        case ExploreMapViewStateHidden: {
            
            self.currentSummaryHeight = 0.0;
            self.childViewBottomConstraint.constant = -CGRectGetHeight(self.childContainerView.bounds);
            [self.exhibitionViewController exhibitionShouldEnableScroll:NO];
            self.tapGestureRecognizer.enabled = NO;
            
            if ([self.delegate respondsToSelector:@selector(exploreMapViewControllerDidExitFullExhibitionDetails)]) {
                [self.delegate exploreMapViewControllerDidExitFullExhibitionDetails];
            }
            
            [self.dataController deselectMapMarker];
            
            [self.mapView deselectAllAnnotations];
            
            [self.exhibitionViewController setScrollPosition:CGPointZero animated:YES];
            
            break;
        }
            
        case ExploreMapViewStatePeek: {
            
            self.currentSummaryHeight = [self.exhibitionViewController estimatedExhibitionSummaryHeight];
            
            self.childViewBottomConstraint.constant = -(CGRectGetHeight(self.childContainerView.bounds) - self.currentSummaryHeight);
            [self.exhibitionViewController exhibitionShouldEnableScroll:NO];
            [self.exhibitionViewController showUpArrow:YES animated:YES];
            self.tapGestureRecognizer.enabled = YES;
            
            if ([self.delegate respondsToSelector:@selector(exploreMapViewControllerDidExitFullExhibitionDetails)]) {
                [self.delegate exploreMapViewControllerDidExitFullExhibitionDetails];
            }
            
            [self.exhibitionViewController setScrollPosition:CGPointZero animated:YES];
            
            break;
        }
            
        case ExploreMapViewStateFull: {
            
            self.currentSummaryHeight = [self.exhibitionViewController estimatedExhibitionSummaryHeight];
            self.childViewBottomConstraint.constant = 0;
            [self.exhibitionViewController exhibitionShouldEnableScroll:YES];
            [self.exhibitionViewController showUpArrow:NO animated:YES];
            [self.delegate exploreMapViewControllerDidShowFullExhibition:self];
            self.tapGestureRecognizer.enabled = NO;
            
            if ([self.delegate respondsToSelector:@selector(exploreMapViewControllerDidPresentedFullExhibitionDetails:)]) {
                [self.delegate exploreMapViewControllerDidPresentedFullExhibitionDetails:self.exhibitionViewController.venueSummary];
            }
            
            break;
        }
            
        case ExploreMapViewStateTransition: {
            
            self.currentSummaryHeight = [self.exhibitionViewController estimatedExhibitionSummaryHeight];
            [self.exhibitionViewController exhibitionShouldEnableScroll:NO];
            [self.delegate exploreMapViewControllerDidHideFullExhibition:self];
            self.tapGestureRecognizer.enabled = NO;
            
            break;
        }
            
        default:
            break;
    }
    
    [self didUpdateChildViewBottomConstraint];
    
    if (existingConstraintConstant != self.childViewBottomConstraint.constant ) {
        
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            [self.exhibitionViewController.tableView beginUpdates];
            [self.exhibitionViewController.tableView endUpdates];
        }];
    }
}

#pragma mark - Exhibition Info

- (void)addExhibitionInfoChildViewController {
    
    self.exhibitionViewController = [[ExhibitionInfoViewController alloc] initWithNibName:@"ExhibitionInfoViewController" bundle:nil];
    [self addChildViewController:self.exhibitionViewController];
    self.exhibitionViewController.delegate = self;
    
    self.exhibitionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.childContainerView addSubview:self.exhibitionViewController.view];
    
    [self.childContainerView pinView:self.exhibitionViewController.view];
}

#pragma mark - Data Management

- (void)shouldUpdateDataController {
    
    NSArray <VenueSearchSummary *> *data = [self.delegate exploreMapViewControllerConsultParentForData:self];
    
    [self updateMapLocation:NO];
    
    if (self.needsScaleToClosestVenue) {
        
        // calculate closet distance
        CLLocationCoordinate2D currentLocationCoordinate = self.mapView.location;
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocationCoordinate.latitude
                                                                 longitude:currentLocationCoordinate.longitude];
        CLLocationDistance smallestDistance = DBL_MAX;
        
        for (VenueSearchSummary *venue in data) {
            CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:venue.latitude
                                                                   longitude:venue.longitude];
            CLLocationDistance distance = [currentLocation distanceFromLocation:venueLocation];
            
            if (distance < smallestDistance) {
                smallestDistance = distance;
            }
        }
        
        // We multiply by 2.5 here because the scale meters is the vertical distance of the map
        // and the current location is in the middle, the 0.5 is that we put a little more distance
        // on it
        self.mapView.scaleMeters = smallestDistance * 2.5;
    }
}

- (void)removeMapAnnotations {
    
    [self.mapView removeAllAnnotations];
    [self exploreMapDataController:self.dataController didDeselectVenue:self.exhibitionViewController.venueSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ExploreMapDataController

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didUpdateLocation:(CLLocation *)location zoomLevel:(NSUInteger)zoomLevel shouldClearCache:(BOOL)shouldClearCache {

    if (!self.isMovingToUserLocation) {
        
        [self.locationButton setImage:[UIImage imageNamed:@"Icondarklocationdisabled"] forState:UIControlStateNormal];
    }
  
    self.isMovingToUserLocation = NO;
    
    self.needsScaleToClosestVenue = shouldClearCache;
    
    self.currentScaleMeters = self.mapView.scaleMeters;
    
    if ([self.delegate respondsToSelector:@selector(exploreMapViewController:didUpdateToNewLocation:zoomLevel:shouldClearCache:)]) {
        
        [self.delegate exploreMapViewController:self didUpdateToNewLocation:location zoomLevel:zoomLevel shouldClearCache:shouldClearCache];
    }
    
    [self updateMapLocation:YES];
    
    [self requestInitialLocationName:^(NSString *name, NSError *error) {
     
        if (error) {
            
            NSLog(@"Error trying to fetch location in Map View");
        }
        else {
            
            self.locationLabel.text = name;
        }
    }];
}

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didSelectVenue:(VenueSearchSummary *)summary {
    
    self.exhibitionViewController.venueSummary = summary;
    
    self.mapViewState = ExploreMapViewStatePeek;
}

- (void)exploreMapDataController:(ExploreMapDataController *)exploreMapDataController didDeselectVenue:(VenueSearchSummary *)summary {

    self.exhibitionViewController.venueSummary = nil;
    
    self.mapViewState = ExploreMapViewStateHidden;
}

- (NSDate*)getCurrentDateFromCalendar:(ExploreMapDataController *)exploreMapDataController {
    return self.currentDate;
}

- (void)exploreMapDataControllerDidSelectUserLocation:(ExploreMapDataController *)exploreMapDataController {
  
    // Note: Modification from Sep 2016 - Change requests from Yamo
//    self.bannerTopConstraint.constant = 0.0f;
//
//    [UIView animateWithDuration:0.3 animations:^{
//       
//        [self.view layoutIfNeeded];
//    }];
}


- (void)exploreMapDataControllerDidDeselectUserLocation:(ExploreMapDataController *)exploreMapDataController {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
//    self.bannerTopConstraint.constant = - 55.0f;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        [self.view layoutIfNeeded];
//    }];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark ExhibitionInfoViewControllerDelegate

- (void)exhibitionInfoViewControllerDidPullDown:(ExhibitionInfoViewController *)viewController {
    
    self.mapViewState = ExploreMapViewStateTransition;
    [self handlePanGesture:self.panGestureRecognizer];
}


#pragma mark - MapPlacesViewControllerDelegate

- (void)mapPlacesViewController:(MapPlacesViewController *)controller didSelectLocation:(id<RoutePlannerInterface>)location {
    
    self.mapView.isSelectedLocation = YES;
    [self.mapView updateMapWithSelectedPlaceCoordinate:location.coordinate];
    
    self.locationLabel.text = location.displayName;
    
    self.needsScaleToClosestVenue = YES;
}

@end
