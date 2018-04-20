//
//  LaunchNavigationViewControllerDelegate
//  Yamo
//
//  Created by Mo Moosa on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LaunchNavigationViewControllerDelegate <NSObject>

- (void)viewControllerDidFinish:(UIViewController *)viewController;

@optional

- (BOOL)viewControllerShouldBeSkipped:(UIViewController *)viewController;

@end
