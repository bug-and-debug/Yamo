//
//  SettingsViewController.h
//  Yamo
//
//  Created by Jin on 7/12/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTableViewCell.h"

@interface SettingsViewController : UIViewController
{
    IBOutlet UITableView* tv;
    IBOutlet NSLayoutConstraint* tv_height;
    IBOutlet NSLayoutConstraint* tv_logout_offset;
}

- (IBAction)logout:(id)sender;

@end
