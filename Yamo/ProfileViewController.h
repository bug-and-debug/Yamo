//
//  ProfileViewController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "ProfileDataController.h"
#import "NoContentView.h"

@import LOCScrollingTabViewController;

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) ProfileDTO *user;
@property (nonatomic, strong) ProfileDataController *dataController;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) NoContentView *noContentView;


- (void)setScrollingTabViewController;

@end
