//
//  MapSuggestionsViewController.h
//  Yamo
//
//  Created by Dario Langella on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchNavigationViewController.h"
#import "VenueSearchSummary.h"

@interface MapSuggestionsViewController : UIViewController

@property (nonatomic, weak) id <LaunchNavigationViewControllerDelegate> onboardingDelegate;
@property (nonatomic) NSArray <VenueSearchSummary *> *venueSummaries;

+ (NSInteger)numberOfMatchingVenueSummaries:(NSArray <VenueSearchSummary *> *)venueSummaries;

@end
