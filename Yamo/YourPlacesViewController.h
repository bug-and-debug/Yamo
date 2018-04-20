//
//  YourPlacesViewController.h
//  Yamo
//
//  Created by Peter Su on 03/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesViewController.h"

@protocol RoutePlannerInterface;

@protocol YourPlacesViewControllerDelegate;

@interface YourPlacesViewController : PlacesViewController

+ (instancetype)yourPlacesViewControllerWithContext:(PlacesViewControllerContext)context;

@property (nonatomic, weak) id<YourPlacesViewControllerDelegate> delegate;

@end

@protocol YourPlacesViewControllerDelegate <NSObject>

- (BOOL)yourPlacesViewController:(YourPlacesViewController *)controller needToCheckDuplication:(id<RoutePlannerInterface>)location;

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectSourceLocation:(id<RoutePlannerInterface>)sourceLocation;

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectReturnLocation:(id<RoutePlannerInterface>)returnLocation;

- (void)yourPlacesViewController:(YourPlacesViewController *)controller didSelectAdditionalLocation:(id<RoutePlannerInterface>)additionalLocation;

@end
