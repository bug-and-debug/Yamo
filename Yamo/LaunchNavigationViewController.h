//
//  LaunchNavigationViewController.h
//  Yamo
//
//  Created by Mo Moosa on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchNavigationViewControllerDelegate.h"

@protocol LaunchNavigationViewController <NSObject>

@property (nonatomic, weak) id <LaunchNavigationViewControllerDelegate> onboardingDelegate;

@end
