//
//  ExploreMapViewController.h
//  Yamo
//
//  Created by Mo Moosa on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@class ExploreMapViewController, VenueSearchSummary;

typedef NS_ENUM(NSUInteger, ExploreMapViewState) {
    
    ExploreMapViewStateHidden,
    ExploreMapViewStatePeek,
    ExploreMapViewStateFull,
    ExploreMapViewStateTransition
};

@protocol ExploreMapViewControllerDelegate <NSObject>

- (void)exploreMapViewControllerDidPressShareButton:(ExploreMapViewController *)viewController;
- (void)exploreMapViewControllerDidPressListButton:(ExploreMapViewController *)viewController;
- (void)exploreMapViewControllerDidShowFullExhibition:(ExploreMapViewController *)viewController;
- (void)exploreMapViewControllerDidHideFullExhibition:(ExploreMapViewController *)viewController;
- (NSArray <VenueSearchSummary *> *)exploreMapViewControllerConsultParentForData:(ExploreMapViewController *)viewController;
- (void)exploreMapViewController:(ExploreMapViewController *)viewController didUpdateToNewLocation:(CLLocation *)location zoomLevel:(NSUInteger)zoomLevel shouldClearCache:(BOOL)shouldClearCache;

- (void)exploreMapViewControllerDidPresentedFullExhibitionDetails:(VenueSearchSummary *)venueSearchSummary;
- (void)exploreMapViewControllerDidExitFullExhibitionDetails;

@end

@interface ExploreMapViewController : UIViewController

@property (nonatomic, weak) id <ExploreMapViewControllerDelegate> delegate;
@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) CGFloat currentScaleMeters;
@property (nonatomic) BOOL shouldShowImageForMap;
@property (nonatomic) ExploreMapViewState mapViewState;
@property (nonatomic, strong) NSDate *currentDate;

- (void)shouldUpdateDataController;
- (void)removeMapAnnotations;

- (void)selectVenue:(VenueSearchSummary *)venue;
- (void) closeFullExhibition;
@end
