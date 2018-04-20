//
//  RoutePlannerViewController.m
//  mapPlaying
//
//  Created by Dario Langella on 06/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerViewController.h"
#import "RoutePlannerListViewController.h"
#import "YourPlacesViewController.h"
#import "SaveRouteViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotationObject.h"
#import "MapAnnotationView.h"
#import "MapPlaceAnnotationObject.h"
#import "MapPlaceAnnotationView.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "TimeToDisplayString.h"
#import "APIClient+Authentication.h"
#import "APIClient+Venue.h"
#import "RouteStepAppearance.h"
#import "RoutePlannerCoordinator.h"
#import "Route.h"
#import "Venue.h"
#import "Place.h"
#import "TempPlace.h"
#import "RouteDTO.h"
#import "UIViewController+Network.h"
#import "UserService.h"
#import "Yamo-Swift.h"
#import "UIViewController+Title.h"

@import UIButton_LOCExtensions;
@import LOCPermissions_Swift;
@import UIAlertController_LOCExtensions;
@import UIImage_LOCExtensions;

static CGFloat RoutePlannerViewControllerRouteWalkDriveButtonHeight = 45.0f;
static CGFloat RoutePlannerViewControllerRouteTimeViewHeight = 68.0f;

static CGFloat RouteMapDefaultSpanDelta = 0.005;

typedef NS_ENUM(NSInteger, RoutePlannerViewControllerMode) {
    RoutePlannerViewControllerModeMap,
    RoutePlannerViewControllerModeBetween,
    RoutePlannerViewControllerModeDirections
};

/**
 *  A type defines the invoke should happen after the subscription successful
 */
typedef NS_ENUM(NSInteger, SubscriptionInvokeType) {
    SubscriptionInvokeTypeSaveRoute,
    SubscriptionInvokeTypeSelectReturnRoute,
    SubscriptionInvokeTypeAdditionalRoute
};

@interface RoutePlannerViewController () <RoutePlannerCoordinatorDelegate, RoutePlannerListViewControllerDelegate, YourPlacesViewControllerDelegate, SaveRouteViewControllerDelegate, MKMapViewDelegate, PaywallNavigationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UIView *userLocationButtonBackground;

@property (weak, nonatomic) IBOutlet UIButton *walkButton;
@property (weak, nonatomic) IBOutlet UIButton *driveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeTimeViewTop;
@property (weak, nonatomic) IBOutlet UIView *routeTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeTimeViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *nextRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedRouteLabel;
@property (weak, nonatomic) IBOutlet UIView *fakeGoButton;
@property (weak, nonatomic) IBOutlet UIImageView *fakeGoImageView;
@property (weak, nonatomic) IBOutlet UILabel *goButtonLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *goButtonActivityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeErrorLabelTrailingConstraint;

@property (weak, nonatomic) IBOutlet UIView *directionsContainerView;

@property (strong, nonatomic) RoutePlannerListViewController *directionsViewController;
@property (nonatomic, strong) RoutePlannerCoordinator *routePlanner;
@property (nonatomic) RoutePlannerTransitType currentTransitType;
@property (nonatomic) RoutePlannerViewControllerMode currentMode;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) BOOL routeWasSaved;
@property (nonatomic) BOOL sequenceWasModified;
@property (nonatomic) BOOL isZoomingToCenter;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic) SubscriptionInvokeType subscriptionInvokeType;

@end

@implementation RoutePlannerViewController

#pragma mark - Initialize

- (instancetype)initWithRoute:(Route *)route {
    
    self = [RoutePlannerViewController new];
    
    if (self) {
        
        self.routePlanner = [[RoutePlannerCoordinator alloc] initWithRoute:route];
        self.routePlanner.delegate = self;
        
        // If the route has a uuid, it means its been saved already
        if (route.uuid) {
            self.routeWasSaved = YES;
        }
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupAppearance];
    [self setupLocationPermission];
    [self addRoutePlannerDirectionsTableViewController];
    
    self.mapView.delegate = self;
    [self addAnnotationViewObjectInMaps];
    
    // Default pressed walk button
    [self handlePressWalkButton];
    
    self.currentMode = RoutePlannerViewControllerModeMap;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Custom the back button
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icondarkdisabled 2"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleBackButtonPressed:)]];
    
    [self updateSaveRouteButtonAppearance];
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    self.fakeGoButton.hidden = YES;
    self.routeErrorLabelTrailingConstraint.constant = 106.0;
}

#pragma mark - Setters

- (void)setCurrentMode:(RoutePlannerViewControllerMode)currentMode {
    
    switch (currentMode) {
        case RoutePlannerViewControllerModeMap: {
            self.routeTimeViewTop.constant = [self heightOfMapMode];
            
            self.routeErrorLabel.hidden = YES;
            // Note: Modification from Sep 2016 - Change requests from Yamo
//            self.nextRouteLabel.hidden = NO;
//            self.totalRouteLabel.hidden = NO;
            self.nextRouteLabel.hidden = YES;
            self.totalRouteLabel.hidden = YES;
            
            [self.view needsUpdateConstraints];
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            }];
            
            if (!self.routePlanner.currentSourcePlace) {
                [self.routePlanner checkDirectionsForRouteForTransitType:self.currentTransitType];
            }
            
            break;
        }
        case RoutePlannerViewControllerModeDirections: {
            self.routeTimeViewTop.constant = 0;
            
            self.goButtonLabel.text = NSLocalizedString(@"View Route", nil);
            
            if (self.routePlanner.currentSourcePlace) {
                self.routeErrorLabel.text = NSLocalizedString(@"Reorder your route", nil);
            }
            self.routeErrorLabel.hidden = NO;
            self.nextRouteLabel.hidden = YES;
            self.totalRouteLabel.hidden = YES;
            
            [self.view needsUpdateConstraints];
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
                if (self.directionsViewController) {
                    self.directionsViewController.didChangeSequenceOfSteps = NO;
                    [self.directionsViewController forceReloadData];
                }
            }];
            break;
        }
        case RoutePlannerViewControllerModeBetween: {
            break;
        }
        default:
            break;
    }
    _currentMode = currentMode;
}

- (void)setSequenceWasModified:(BOOL)sequenceWasModified {
    _sequenceWasModified = sequenceWasModified;
    
    self.routeWasSaved = NO;
}

#pragma mark - Appearance

- (void)setupAppearance {
    
    [self setAttributedTitle:NSLocalizedString(@"Route planner", nil)];

    self.userLocationButtonBackground.backgroundColor = [UIColor whiteColor];
    [self.userLocationButton addTarget:self action:@selector(handleDidPressCenterToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.driveButton addTarget:self action:@selector(handlePressDriveButton) forControlEvents:UIControlEventTouchUpInside];
    [self setupAppearanceForTopButton:self.driveButton withTitleText:NSLocalizedString(@"Drive", nil)];
    
    [self.walkButton addTarget:self action:@selector(handlePressWalkButton) forControlEvents:UIControlEventTouchUpInside];
    [self setupAppearanceForTopButton:self.walkButton withTitleText:NSLocalizedString(@"Walk", nil)];
    
    self.routeTimeViewHeight.constant = RoutePlannerViewControllerRouteTimeViewHeight;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapRouteTimeView)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidPanRouteTimeViewPanGestureRecognizer:)];
    [self.routeTimeView addGestureRecognizer:self.tapGestureRecognizer];
    [self.routeTimeView addGestureRecognizer:self.panGestureRecognizer];
    
    self.nextRouteLabel.textColor = [UIColor yamoTextGray];
    self.nextRouteLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    
    self.totalRouteLabel.textColor = [UIColor yamoTextGray];
    self.totalRouteLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    
    self.routeErrorLabel.text = NSLocalizedString(@"Could not calculate the route in the meantime", nil);
    self.routeErrorLabel.textColor = [UIColor yamoTextGray];
    self.routeErrorLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    self.routeErrorLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *buttonImage = [UIImage imageNamed:@"YellowButtonBackground"];
    self.fakeGoImageView.image = [buttonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 10, 0) resizingMode:UIImageResizingModeStretch];
    self.fakeGoButton.layer.cornerRadius = 4.0f;
    self.goButtonLabel.text = NSLocalizedString(@"View Route", nil);
    self.goButtonLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    self.goButtonLabel.textColor = [UIColor whiteColor];
    
    [self.goButtonActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)setupAppearanceForTopButton:(UIButton *)topButton
                      withTitleText:(NSString *)titleText {

    topButton.titleLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    
    [topButton setTitle:titleText forState:UIControlStateNormal];

    [topButton setTitleColor:[UIColor yamoTextGray] forState:UIControlStateNormal];
    
    [topButton setBackgroundColor:[UIColor yamoLightGray] forState:UIControlStateNormal];
    [topButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [topButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)addRoutePlannerDirectionsTableViewController {
    
    if (!self.directionsViewController) {
        self.directionsViewController = [RoutePlannerListViewController new];
        self.directionsViewController.delegate = self;
        self.directionsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:self.directionsViewController];
        [self.directionsContainerView addSubview:self.directionsViewController.view];
        
        [self.view addConstraints:@[ [NSLayoutConstraint constraintWithItem:self.directionsContainerView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.directionsViewController.view
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:0],
                                     [NSLayoutConstraint constraintWithItem:self.directionsContainerView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.directionsViewController.view
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:0],
                                     [NSLayoutConstraint constraintWithItem:self.directionsContainerView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.directionsViewController.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:0],
                                     [NSLayoutConstraint constraintWithItem:self.directionsContainerView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.directionsViewController.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0]]];
    }
}

- (void)updateAppearanceForButtonIfCurrentlyCentered:(BOOL)centered {
    
    UIImage *centerImage = centered ? [UIImage imageNamed:@"Icondarklocationactive"] : [UIImage imageNamed:@"LocationIcon"];
    [self.userLocationButton setImage:[centerImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                             forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)handleBackButtonPressed:(id)sender {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        if (!self.routeWasSaved && hasSubscription) {
            [UIAlertController showAlertInViewController:self
                                               withTitle:NSLocalizedString(@"Discard Route", nil)
                                                 message:NSLocalizedString(@"Would you like to discard the unsaved route?", nil)
                                       cancelButtonTitle:NSLocalizedString(@"Discard", nil)
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@[NSLocalizedString(@"Keep Editing", nil)]
                                                tapBlock:^(UIAlertController * controller, UIAlertAction * action, NSInteger idx) {
                                                    if (action.style != UIAlertActionStyleCancel) {
                                                        return;
                                                    }
                                                    
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)handlePressDriveButton {
    
    self.currentTransitType = RoutePlannerTransitTypeDrive;
    
    if (!self.driveButton.selected) {
        self.driveButton.selected = YES;
        self.walkButton.selected = NO;
        
        [self sendLocationsToMap:self.routePlanner.route.steps];
    }
}

- (void)handlePressWalkButton {
    
    self.currentTransitType = RoutePlannerTransitTypeWalk;
    
    if (!self.walkButton.selected) {
        self.walkButton.selected = YES;
        self.driveButton.selected = NO;
        
        [self sendLocationsToMap:self.routePlanner.route.steps];
    }
}

- (void)handleDidPressSaveRoute {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        if (hasSubscription) {
            
            [self presentSaveRouteViewController];
        }
        else {
            
            self.subscriptionInvokeType = SubscriptionInvokeTypeSaveRoute;
            [PaywallNavigationController presentPaywallInViewController:self paywallDelegate:self];
        }
    }];
}

- (void)handleDidPressCenterToUserLocation {
    
    void (^gotLocationBlock)(CLLocation *location, NSError *error) = ^(CLLocation *location, NSError *error) {
        
        self.isZoomingToCenter = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self zoomToLocationOnMapWithLatitude:location.coordinate.latitude
                                        longitude:location.coordinate.longitude
                                         animated:YES];
        } completion:^(BOOL finished) {
            
            if (finished) {
                [self updateAppearanceForButtonIfCurrentlyCentered:YES];
            }
            
            self.isZoomingToCenter = NO;
        }];
    };
    
    
    if ([PermissionRequestLocation sharedInstance].currentStatus != PermissionRequestStatusSystemPromptAllowed) {
        
        [[PermissionRequestLocation sharedInstance] requestPermissionInViewController:self completion:^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo) {
            
            if (outcome != PermissionRequestStatusSystemPromptAllowed) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location Disabled", @"Alert Title") message:NSLocalizedString(@"Please go to the Settings and allow location services." , @"Alert Message") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Location Alert Button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:settingsAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                
                [[UserService sharedInstance] currentLocationForUser:gotLocationBlock];
            }
        }];
    }
    else {
        
        [[UserService sharedInstance] currentLocationForUser:gotLocationBlock];
    }
}

- (void)handleDidTapRouteTimeView {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    return;
    
//    if (self.sequenceWasModified) {
//        
//        [self actionForRouteSequenceChanged];
//    } else {
//        if (self.currentMode == RoutePlannerViewControllerModeMap) {
//            self.currentMode = RoutePlannerViewControllerModeDirections;
//        } else if (self.currentMode == RoutePlannerViewControllerModeDirections) {
//            self.currentMode = RoutePlannerViewControllerModeMap;
//        }
//    }
//    
//    self.directionsViewController.needsUpdateContentsLayout = YES;
}

- (void)handleDidPanRouteTimeViewPanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    return;
    
//    if (!self.sequenceWasModified) {
//        
//        // Started panning
//        CGPoint location = [gesture locationInView:self.view];
//        location.y -= RoutePlannerViewControllerRouteTimeViewHeight;
//        if (location.y > 0 && location.y < CGRectGetMaxY(self.mapView.frame) - RoutePlannerViewControllerRouteWalkDriveButtonHeight) {
//            self.routeTimeViewTop.constant = location.y;
//        }
//        UIGestureRecognizerState state = [gesture state];
//        
//        // This snaps the view to the top or bottom depending on whether the end state
//        if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
//            
//            if (location.y > [self heightOfMapMode] / 2) {
//                self.currentMode = RoutePlannerViewControllerModeMap;
//            } else {
//                self.currentMode = RoutePlannerViewControllerModeDirections;
//            }
//        }
//        
//        self.directionsViewController.needsUpdateContentsLayout = YES;
//    }
}

#pragma mark - Helpers

- (void)actionForRouteSequenceChanged {
    
    // Re-calculate the directions for route
    // Show the map and then set the sequence modified to NO
    [self.routePlanner checkDirectionsForRouteForTransitType:self.currentTransitType];
}

- (CGFloat)heightOfMapMode {
    
    CGFloat statusBarNavigationBarHeight = 64;
    
    return CGRectGetHeight([UIScreen mainScreen].bounds) - RoutePlannerViewControllerRouteTimeViewHeight - statusBarNavigationBarHeight - RoutePlannerViewControllerRouteWalkDriveButtonHeight;
}

- (void)sendLocationsToMap:(NSArray<RouteStep *> *)locations {
    
    [self.routePlanner updateSteps:locations shouldInvalidateCache:NO];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routePlanner checkDirectionsForRouteForTransitType:self.currentTransitType];
}

- (void)zoomToLocationOnMapWithLatitude:(CLLocationDegrees)latitude
                              longitude:(CLLocationDegrees)longitude
                               animated:(BOOL)animated {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    // Validate coordinate
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        coordinate = CLLocationCoordinate2DMake(UserServiceDefaultLocationLatitude,
                                                UserServiceDefaultLocationLongitude);
    }
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    mapRegion.span.latitudeDelta = RouteMapDefaultSpanDelta;
    mapRegion.span.longitudeDelta = RouteMapDefaultSpanDelta;
    
    [self.mapView setRegion:mapRegion animated:animated];
    
    self.isZoomingToCenter = YES;
    [self updateAppearanceForButtonIfCurrentlyCentered:YES];
}

- (void)updateAppearanceForSelectedSourcePlace:(id<RoutePlannerInterface>)sourceLocation {
    
    [self.routePlanner setCurrentSourcePlace:sourceLocation];
    [self didUpdateAppearanceForPlace];
}

- (void)updateAppearanceForSelectedReturnPlace:(id<RoutePlannerInterface>)returnLocation {
    
    [self.routePlanner setCurrentReturnPlace:returnLocation];
    [self didUpdateAppearanceForPlace];
}

- (void)addNewRouteToRoutePlanner:(id<RoutePlannerInterface>)newLocation {
    
    if ([newLocation isKindOfClass:[RouteStep class]]) {
        
        RouteStep *routeStep = (RouteStep *)newLocation;
        [self.routePlanner addNewRouteStep:routeStep];
        
        [self updateSaveRouteButtonAppearance];
    }
    
    [self didUpdateAppearanceForPlace];
}

- (void)didUpdateAppearanceForPlace {
    
    [self.directionsViewController forceReloadData];
    
    self.routeErrorLabel.hidden = NO;
    self.nextRouteLabel.hidden = YES;
    self.totalRouteLabel.hidden = YES;
    
    self.sequenceWasModified = YES;
    self.goButtonLabel.text = NSLocalizedString(@"Calculate...", nil);
    
    [self.navigationController popToViewController:self animated:YES];
}

- (void)setupLocationPermission {
    
    if ([PermissionRequestLocation sharedInstance].currentStatus != PermissionRequestStatusSystemPromptAllowed) {
        
        [[PermissionRequestLocation sharedInstance] requestPermissionInViewController:self completion:^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo) {
            
            if (outcome == PermissionRequestStatusSystemPromptAllowed) {
                
                [self setupUserCurrentLocation];
            }
            else {
                
                [self setCurrentSourcePlaceForCurrentLocation];
            }
        }];
    }
    else {
        
        [self setupUserCurrentLocation];
    }
}

- (void)setupUserCurrentLocation {
    
    [[UserService sharedInstance] currentLocationForUser:^(CLLocation *location, NSError *error) {
        
        self.mapView.showsUserLocation = YES;
        self.userLocation = location;
        [self zoomToLocationOnMapWithLatitude:location.coordinate.latitude
                                    longitude:location.coordinate.longitude
                                     animated:NO];
        
        [self setCurrentSourcePlaceForCurrentLocation];
    }];
}

- (void)setCurrentSourcePlaceForCurrentLocation {
    
    if (!self.routePlanner.currentSourcePlace && self.userLocation) {
        
        TempPlace *tempPlace = [TempPlace new];
        tempPlace.locationName = NSLocalizedString(@"Current Location", nil);
        tempPlace.latitude = self.userLocation.coordinate.latitude;
        tempPlace.longitude = self.userLocation.coordinate.longitude;
        
        self.routePlanner.currentSourcePlace = tempPlace;
    }
    
    [self.routePlanner checkDirectionsForRouteForTransitType:self.currentTransitType];
}

- (void)updateSaveRouteButtonAppearance {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
//    if (!self.routeWasSaved) {
//        UIImage *saveImage = [[UIImage imageNamed:@"Icondarktickdisabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:saveImage
//                                                                       style:UIBarButtonItemStylePlain
//                                                                      target:self
//                                                                      action:@selector(handleDidPressSaveRoute)];
//        
//        self.navigationItem.rightBarButtonItem = saveButton;
//    }
//    else {
//        
//        self.navigationItem.rightBarButtonItem = nil;
//    }
}

#pragma mark - Add Annotation Views In Maps

- (void)addAnnotationViewObjectInMaps {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *arrayOfAnnotations = [NSMutableArray new];
    
    for (RouteStep *step in self.routePlanner.route.steps) {
        
        Venue *stepVenue = step.venue;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(stepVenue.latitude, stepVenue.longitude);
        
        UIColor *pinColor = [RouteStepAppearance stepColorForSequence:step];
        BOOL preferDark = [RouteStepAppearance prefersDarkContentForColor:pinColor];
        
        MapAnnotationObject *annotationView = [[MapAnnotationObject alloc] initWithTitle:nil
                                                                                subtitle:nil
                                                                                pinFrame:CGRectMake(0, 0, 30, 30)
                                                                                pinTitle:[RouteStepAppearance stepLetterForStep:step]
                                                                                pinColor:pinColor
                                                                              preferDark:preferDark
                                                                             andLocation:coordinate];;
        [arrayOfAnnotations addObject:annotationView];
    }
    
    if (self.routePlanner.currentSourcePlace) {
        
        CLLocationCoordinate2D sourceCoordinate = [self.routePlanner.currentSourcePlace coordinate];
        MapPlaceAnnotationObject *annotation = [[MapPlaceAnnotationObject alloc] initWithLocation:sourceCoordinate
                                                                                         isSource:YES];
        [arrayOfAnnotations addObject:annotation];
    }
    
    if (self.routePlanner.currentReturnPlace) {
        
        CLLocationCoordinate2D returnCoordinate = [self.routePlanner.currentReturnPlace coordinate];
        MapPlaceAnnotationObject *annotation = [[MapPlaceAnnotationObject alloc] initWithLocation:returnCoordinate
                                                                                         isSource:YES];
        [arrayOfAnnotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:arrayOfAnnotations];
    
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor yamoDarkGray];
    
    return polylineRender;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation  {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapAnnotationObject class]]) {

        MapAnnotationView *annotationView = (MapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"LOCAnnotation"];
        
        if (!annotationView) {
            annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LOCAnnotation"];

        } else
            annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MapPlaceAnnotationObject class]]) {
        
        MapPlaceAnnotationView *annotationView = (MapPlaceAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(MapPlaceAnnotationView.class)];
        
        if (!annotationView) {
            
            annotationView = [[MapPlaceAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:NSStringFromClass(MapPlaceAnnotationView.class)];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    if (!self.isZoomingToCenter) {
        
        [self updateAppearanceForButtonIfCurrentlyCentered:NO];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    self.isZoomingToCenter = NO;
}

#pragma mark - RoutePlannerCoordinatorDelegate

- (void)routePlannerDidBeginCalculatingDirections {
    
    if (self.directionsViewController) {
        [self.directionsViewController forceReloadData];
    }
    
    // Remove all lines
    [self.mapView removeOverlays:self.mapView.overlays];
    [self addAnnotationViewObjectInMaps];
    
    self.routeErrorLabel.text = NSLocalizedString(@"Calculating route...", nil);
    self.routeErrorLabel.hidden = NO;
    
    self.goButtonLabel.hidden = YES;
    [self.goButtonActivityIndicator startAnimating];
    
    self.nextRouteLabel.text = @"";
    self.totalRouteLabel.text = @"";
    self.suggestedRouteLabel.text = @"";
    self.nextRouteLabel.hidden = YES;
    self.totalRouteLabel.hidden = YES;
    self.suggestedRouteLabel.hidden = NO;
    
    self.driveButton.userInteractionEnabled = NO;
    self.walkButton.userInteractionEnabled = NO;
}

- (void)routePlannerDidFinishCalculatingDirections {
    
    self.driveButton.userInteractionEnabled = YES;
    self.walkButton.userInteractionEnabled = YES;
    
    self.goButtonLabel.hidden = NO;
    [self.goButtonActivityIndicator stopAnimating];
}

- (void)routePlannerDidUpdateTimeForFirstVenue:(double)nextTime {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    // self.nextRouteLabel.attributedText = [self routeLabelsAttributedText:[NSString stringWithFormat:@"To location A: %@", [TimeToDisplayString convertMinutesToDisplayTime:nextTime]]];
}

- (void)routePlannerDidUpdateTotalDistance:(double)totalDistance totalTime:(double)totalTime {
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    // self.totalRouteLabel.attributedText = [self routeLabelsAttributedText:[NSString stringWithFormat:@"Suggested Route: %@", [TimeToDisplayString convertMinutesToDisplayTime:totalTime]]];
    self.suggestedRouteLabel.attributedText = [self suggestedRouteLabelAttributedText:[NSString stringWithFormat:@"Suggested Route: %@", [TimeToDisplayString convertMinutesToDisplayTime:totalTime]]];
}

- (void)routePlannerShouldAddRoute:(MKRoute *)route {
    
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
}

- (void)routePlannerDidErrorWhenCalculatingRoute:(NSString *)errorMessage errorButtonTitle:(NSString *)buttonTitle {
    
    // Show error dialog and retry
    if (errorMessage.length > 0) {
        
        self.goButtonLabel.text = buttonTitle;
        self.routeErrorLabel.attributedText = [self routeLabelsAttributedText:errorMessage];
        self.routeErrorLabel.hidden = NO;
    } else {
        
        self.goButtonLabel.text = NSLocalizedString(@"View Route", nil);
        self.routeErrorLabel.hidden = YES;
        self.nextRouteLabel.hidden = NO;
        self.totalRouteLabel.hidden = NO;
        
        if (self.sequenceWasModified) {
            
            self.currentMode = RoutePlannerViewControllerModeMap;
            self.sequenceWasModified = NO;
            
            // Zoom to user's current location / first location in route planner
            id<RoutePlannerInterface> initialPlace = [self.routePlanner currentSourcePlace];
            if (initialPlace) {
                [self zoomToLocationOnMapWithLatitude:[initialPlace coordinate].latitude
                                            longitude:[initialPlace coordinate].longitude
                                             animated:NO];
            } else {
                // Zoom to user's location instead
                [self handleDidPressCenterToUserLocation];
            }
        }
    }
}

- (void)routePlannerDidReturnCache:(RoutePlannerCache *)cache {
    
    [self.mapView removeOverlays:self.mapView.overlays];
    for (MKRoute *route in cache.mapRoutes) {
        
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
    
    // Note: Modification from Sep 2016 - Change requests from Yamo
    // self.nextRouteLabel.attributedText = [self routeLabelsAttributedText:[NSString stringWithFormat:NSLocalizedString(@"To location A: %@", nil), [TimeToDisplayString convertMinutesToDisplayTime:cache.firstTimeTravelled]]];
    // self.totalRouteLabel.attributedText = [self routeLabelsAttributedText:[NSString stringWithFormat:NSLocalizedString(@"Suggested Route: %@", nil), [TimeToDisplayString convertMinutesToDisplayTime:cache.timeTravelled]]];
    self.suggestedRouteLabel.attributedText = [self suggestedRouteLabelAttributedText:[NSString stringWithFormat:NSLocalizedString(@"Suggested Route: %@", nil), [TimeToDisplayString convertMinutesToDisplayTime:cache.timeTravelled]]];
    
    [self routePlannerDidFinishCalculatingDirections];
    [self routePlannerDidErrorWhenCalculatingRoute:@"" errorButtonTitle:@""];
}

- (NSAttributedString *)routeLabelsAttributedText:(NSString *)text {
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoTextGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (NSAttributedString *)suggestedRouteLabelAttributedText:(NSString *)text {
    
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoTextGray],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

#pragma mark - RoutePlannerListViewControllerDelegate

- (RoutePlannerCoordinator *)consultParentRoutePlanner {
    return self.routePlanner;
}

- (void)routePlannerListViewControllerIsDeletingSteps:(BOOL)deletingSteps {
    
    BOOL enablePanAndTap = !deletingSteps;
    
    self.tapGestureRecognizer.enabled = enablePanAndTap;
    self.panGestureRecognizer.enabled = enablePanAndTap;
    self.fakeGoButton.backgroundColor = enablePanAndTap ? [UIColor yamoYellow] : [UIColor yamoLightGray];
}

- (void)routePlannerListViewControllerDidChangeSequence:(BOOL)didChangeSequence {
    
    self.routeErrorLabel.hidden = NO;
    self.nextRouteLabel.hidden = YES;
    self.totalRouteLabel.hidden = YES;
    
    self.sequenceWasModified = didChangeSequence;
    self.goButtonLabel.text = NSLocalizedString(@"Calculate...", nil);
    
    [self updateSaveRouteButtonAppearance];
}

- (void)routePlannerListViewControllerDidPressUpdateLocationForSource:(BOOL)isSource {
    
    if (isSource) {
        
        [self presentYourPlacesViewControllerForContext:PlacesViewControllerContextSelectSource];
    }
    else {
    
        [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
            
            if (hasSubscription) {
                
                [self presentYourPlacesViewControllerForContext:PlacesViewControllerContextSelectReturn];
            }
            else {
                
                self.subscriptionInvokeType = SubscriptionInvokeTypeSelectReturnRoute;
                [PaywallNavigationController presentPaywallInViewController:self paywallDelegate:self];
            }
        }];
    }
}

- (void)routePlannerListViewControllerDidPressAddNewLocation {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        if (hasSubscription) {
            
            [self presentYourPlacesViewControllerForContext:PlacesViewControllerContextSelectAdditional];
        }
        else {
            
            self.subscriptionInvokeType = SubscriptionInvokeTypeAdditionalRoute;
            [PaywallNavigationController presentPaywallInViewController:self paywallDelegate:self];
        }
    }];
}

- (void)presentYourPlacesViewControllerForContext:(PlacesViewControllerContext)context {
    
    YourPlacesViewController *yourPlacesViewController = [YourPlacesViewController yourPlacesViewControllerWithContext:context];
    yourPlacesViewController.delegate = self;
    
    [self.navigationController pushViewController:yourPlacesViewController animated:YES];
}

- (void)presentSaveRouteViewController {
    
    Route *saveRoute = self.routePlanner.route;
    NSNumber *loggedInUserId = [UserService sharedInstance].loggedInUser.uuid;
    
    if (saveRoute.uuid && [loggedInUserId isEqualToNumber:saveRoute.userId]) {
        
        // This is a saved route, edit it on the server
        
        [self showIndicator:YES];
        
        RouteDTO *saveRouteDTO = [[RouteDTO alloc] initWithRouteName:saveRoute.name
                                                               route:saveRoute];
        
        [[APIClient sharedInstance] venueEditRoute:saveRouteDTO
                                       withRouteId:saveRoute.uuid
                                      successBlock:^(id  _Nullable element) {
                                          
                                          if ([element isKindOfClass:Route.class]) {
                                              
                                              self.routeWasSaved = YES;
                                              self.routePlanner = [[RoutePlannerCoordinator alloc] initWithRoute:element];
                                              self.routePlanner.delegate = self;
                                              
                                              [self updateSaveRouteButtonAppearance];
                                          }
                                          
                                          [self showIndicator:NO];
                                          
                                      } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                          
                                          [self showIndicator:NO];
                                          
                                          NSLog(@"failed: %@", context);
                                          
                                          [UIAlertController showAlertInViewController:self
                                                                             withTitle:nil
                                                                               message:NSLocalizedString(@"Failed to save route, please try again", nil)
                                                                     cancelButtonTitle:nil
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                                                              tapBlock:nil];
                                      }];
        
    }
    else {
        
        SaveRouteViewController *saveRouteViewController = [[SaveRouteViewController alloc] initWithRoute:saveRoute];
        saveRouteViewController.delegate = self;
        
        [self presentViewController:saveRouteViewController animated:YES completion:nil];
    }
}

#pragma mark - PaywallNavigationViewControllerDelegate

- (void)paywallDidFinishedSubscription:(BOOL)hasSubscription {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (!hasSubscription) {
            return;
        }
        
        switch (self.subscriptionInvokeType) {
            case SubscriptionInvokeTypeSaveRoute:
                [self presentSaveRouteViewController];
                break;
            case SubscriptionInvokeTypeSelectReturnRoute:
                [self presentYourPlacesViewControllerForContext:PlacesViewControllerContextSelectReturn];
                break;
            case SubscriptionInvokeTypeAdditionalRoute:
                [self presentYourPlacesViewControllerForContext:PlacesViewControllerContextSelectAdditional];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - YourPlacesViewControllerDelegate

- (BOOL)yourPlacesViewController:(YourPlacesViewController *)controller needToCheckDuplication:(id<RoutePlannerInterface>)location {
    
    return [self.routePlanner hasExistingPlace:location];
}

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectSourceLocation:(id<RoutePlannerInterface>)sourceLocation {
    
    [self updateAppearanceForSelectedSourcePlace:sourceLocation];
}

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectReturnLocation:(id<RoutePlannerInterface>)returnLocation {
    
    [self updateAppearanceForSelectedReturnPlace:returnLocation];
}

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectAdditionalLocation:(id<RoutePlannerInterface>)additionalLocation {
    
    [self addNewRouteToRoutePlanner:additionalLocation];
}

#pragma mark - SaveRouteViewControllerDelegate

- (void)saveRouteViewController:(SaveRouteViewController *)controller didSaveNewRoute:(Route *)newRoute {
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        self.routeWasSaved = YES;
        self.routePlanner = [[RoutePlannerCoordinator alloc] initWithRoute:newRoute];
        self.routePlanner.delegate = self;
        
        [self updateSaveRouteButtonAppearance];
    }];
}

@end
