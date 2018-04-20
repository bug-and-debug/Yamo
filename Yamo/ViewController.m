//
//  ViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 30/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ViewController.h"
#import "APIClient+Authentication.h"
#import "HelpOverlayViewController.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSArray *frames;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttons = [NSMutableArray array];
    
    self.frames = @[[NSValue valueWithCGRect:CGRectMake(20.0f, 20.0f, 44.0f, 44.0f)],
                    [NSValue valueWithCGRect:CGRectMake(200.0f, 120.0f, 73.0f, 44.0f)],
                    [NSValue valueWithCGRect:CGRectMake(120.0f, 273.0f, 100.0f, 44.0f)],
                    [NSValue valueWithCGRect:CGRectMake(200.0f, 520.0f, 144.0f, 44.0f)],
                    [NSValue valueWithCGRect:CGRectMake(0.0f, 150.0f, 80.0f, 60.0f)],
                    [NSValue valueWithCGRect:CGRectMake(75.0f, 230.0f, 64.0f, 44.0f)],
                    [NSValue valueWithCGRect:CGRectMake(150.0f, 370.0f, 94.0f, 44.0f)],
                    ];
    
    for (NSValue *value in self.frames) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = value.CGRectValue;
        
        [button setTitle:[NSString stringWithFormat:@"%lu", [self.frames indexOfObject:value] + 1] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [self.buttons addObject:button];
    }
    
    [[APIClient sharedInstance] loginWithEmail:@"admin@yamo.com"
                                      password:@"testing"
                                  successBlock:^(id  _Nullable element) {
                                      
                                      NSLog(@"element: %@", element);
                                      
                                  } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                      
                                      
                                      
                                  }];
    
}

- (IBAction)handleTryButtonTap:(id)sender {
    
    HelpOverlayViewController *viewController = [HelpOverlayViewController new];
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIButton *button in self.buttons) {
        
        [array addObject:[viewController cutOutViews:@[[NSValue valueWithCGRect:button.frame]] withCornerRadius:arc4random_uniform(30) title:@"Help title" detail:@"Our Advantage Health Cash Plan is designed to cover your optical and dental needs"]];
    }
    
    viewController.cutouts = array;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
