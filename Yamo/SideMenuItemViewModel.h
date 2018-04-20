//
//  SideMenuItem.h
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;
#import "SideMenuChildViewController.h"

@interface SideMenuItemViewModel : NSObject

@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nullable) NSString *premiumTitle;
@property (nonatomic, nullable) NSString *detailText;
@property (nonatomic, nullable) UIImage *icon;
@property (nonatomic) SideMenuItemAvailability featureAvailability;

@end
