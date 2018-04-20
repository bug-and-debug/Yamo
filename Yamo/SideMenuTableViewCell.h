//
//  SideMenuTableViewCell.h
//  Yamo
//
//  Created by Dario Langella on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, getter=isActive) BOOL active;
@property (weak, nonatomic) UIColor *activeColor;
@end
