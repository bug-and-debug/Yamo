//
//  MainViewController.m
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "Yamo-Swift.h"

@interface MainViewController ()

@property (nonatomic) LeftMenuViewController *leftMenuViewController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (LeftMenuViewController *)leftMenuViewController {
    
    if (!_leftMenuViewController) {
        
        _leftMenuViewController = [LeftMenuViewController new];
        [_leftMenuViewController setViewControllers:self.viewControllers];
        _leftMenuViewController.delegate = self;
        
        [self.view addSubview:_leftMenuViewController.view];
        [self addChildViewController:_leftMenuViewController];
        
        [_leftMenuViewController didMoveToParentViewController:self];
        
        _leftMenuViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return _leftMenuViewController;
}

- (SideMenuViewController *)sideMenuViewController {
    
    return self.leftMenuViewController;
}

@end
