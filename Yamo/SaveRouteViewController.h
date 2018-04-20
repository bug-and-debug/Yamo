//
//  SaveRouteViewController.h
//  Yamo
//
//  Created by Peter Su on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@protocol SaveRouteViewControllerDelegate;

@interface SaveRouteViewController : UIViewController

@property (nonatomic, weak) id<SaveRouteViewControllerDelegate> delegate;

- (instancetype)initWithRoute:(Route *)route;

@end

@protocol SaveRouteViewControllerDelegate <NSObject>

- (void)saveRouteViewController:(SaveRouteViewController *)controller didSaveNewRoute:(Route *)newRoute;

@end
