//
//  YourPlaceActionSheetController.h
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourPlaceOption.h"

@protocol YourPlaceActionSheetControllerDelegate;

@interface YourPlaceActionSheetController : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<YourPlaceActionSheetControllerDelegate> delegate;

@end

@protocol YourPlaceActionSheetControllerDelegate <NSObject>

- (void)yourPlaceActionSheetController:(YourPlaceActionSheetController *)controller
               didSelectEditOptionType:(YourPlaceOptionType)type;

@end
