//
//  SideMenuChildViewController.h
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, SideMenuItemAvailability) {
    SideMenuItemAlwaysAvailable,
    SideMenuItemRequiresSubscription
};

@protocol SideMenuChildViewController <NSObject>

@property (nonatomic, readonly, getter=featureAvailability) SideMenuItemAvailability featureAvailability;

@property (nonatomic, readonly, getter=preferredTitle) NSString *preferredTitle;

@optional

@property (nonatomic, readonly, getter=preferredPremiumTitle) NSString *preferredPremiumTitle;

@property (nonatomic, readonly, getter=preferredDetailText) NSString *preferredDetailText;

@end
