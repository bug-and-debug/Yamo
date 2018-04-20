//
//  YourPlaceActionSheet.h
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourPlaceActionSheetController.h"

@protocol YourPlaceActionSheetDelegate;

@interface YourPlaceActionSheet : UIView

@property (nonatomic, weak) IBOutlet UIView *view;

@property (nonatomic, weak) id<YourPlaceActionSheetDelegate> delegate;

@end

@protocol YourPlaceActionSheetDelegate <NSObject>

- (void)actionSheetDidPressCancel:(YourPlaceActionSheet *)actionSheet;

- (void)actionSheet:(YourPlaceActionSheet *)actionSheet didPressEditOptionType:(YourPlaceOptionType)type;

@end
