//
//  NavigationController.h
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;
@class ContentNavigationController;

@protocol ContentNavigationControllerDelegate <NSObject>

@required
- (void)contentNavigationControllerMenuButtonWasTapped:(ContentNavigationController *_Nullable)contentNavigationController;
@end

@interface ContentNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonnull, nonatomic) UIBarButtonItem *menuButton;
@property (nonatomic,assign)  _Nonnull id <ContentNavigationControllerDelegate> menuDelegate;

@end
