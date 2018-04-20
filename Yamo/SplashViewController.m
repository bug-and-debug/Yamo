//
//  SplashViewController.m
//  RoundsOnMe
//
//  Created by Jose Fernandez on 29/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "SplashViewController.h"
#import "NavigationManager.h"

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [[NavigationManager sharedInstance] pushNextViewControllerFromViewController:self];
}

@end
