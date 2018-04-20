//
//  SettingsViewController.m
//  Yamo
//
//  Created by Jin on 7/12/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "SettingsViewController.h"
#define CELL_TITLE @[@"Notification 1", @"Notification 2", @"Notification 3", @"Notification 4"]

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tv_height.constant = 80*4 + 40;
    tv_logout_offset.constant = SCREEN_HEIGHT - tv_height.constant - 109.f - 50.f;
    if(tv_logout_offset.constant < 0)
        tv_logout_offset.constant = 0;
    [self.view setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - <delegate> UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0)
//        return 4;
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tv.sectionHeaderHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setText:@"Push Notifications"];
    [headerView addSubview:label];
    [headerView setBackgroundColor:RGBCOLOR(246, 246, 246)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int idx = 0;
    if(indexPath.section == 0)
        idx = (int)indexPath.row;
    else if(indexPath.section == 1)
        idx = 1;
    
    SettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell-setting"];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell-setting"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell-setting"];
    }
    
    [((UILabel*)[cell viewWithTag:1]) setText:[CELL_TITLE objectAtIndex:idx]];
    [((UISwitch*)[cell viewWithTag:2]) setOn:arc4random()%2 == 0 ? YES : NO animated:YES];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - IBAction
- (IBAction)logout:(id)sender
{
    [[Utility sharedObject] setDefaultObject:@"0" forKey:USER_SAVED];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
