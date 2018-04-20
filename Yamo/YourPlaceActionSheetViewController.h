//
//  YourPlaceActionSheetViewController.h
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourPlaceOption.h"

@protocol YourPlaceActionSheetViewControllerDelegate;

@interface YourPlaceActionSheetViewController : UIViewController

@property (nonatomic, weak) id<YourPlaceActionSheetViewControllerDelegate> delegate;

@end

@protocol YourPlaceActionSheetViewControllerDelegate <NSObject>

- (void)yourPlaceActionSheetViewController:(YourPlaceActionSheetViewController *)controller
                   shouldEditPlaceWithType:(YourPlaceOptionType)type;

@end
