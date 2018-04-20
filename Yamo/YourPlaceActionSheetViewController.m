//
//  YourPlaceActionSheetViewController.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceActionSheetViewController.h"
#import "YourPlaceActionSheet.h"

@interface YourPlaceActionSheetViewController () <YourPlaceActionSheetDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet YourPlaceActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionSheetBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionSheetHeightConstraint;

@end

@implementation YourPlaceActionSheetViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self defaultSetup];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self defaultSetup];
    }
    return self;
}

- (void)defaultSetup {
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.actionSheet.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showActionSheet:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.actionSheet]) {
        return NO;
    }
    return YES;
}

#pragma mark - Helper

- (void)showActionSheet:(BOOL)show completion:(void (^)())completion {
    
    self.actionSheetBottomConstraint.constant = show ? 0.0f : -self.actionSheetHeightConstraint.constant;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                        
                         if (finished) {
                             
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
}

#pragma mark - Actions

- (void)didTapOnView {
    
    [self actionSheetDidPressCancel:nil];
}

#pragma mark - YourPlaceActionSheetDelegate

- (void)actionSheetDidPressCancel:(YourPlaceActionSheet *)actionSheet {
    
    [self showActionSheet:NO
               completion:^{
                   
                   [self dismissViewControllerAnimated:NO completion:nil];
               }];
}

- (void)actionSheet:(YourPlaceActionSheet *)actionSheet didPressEditOptionType:(YourPlaceOptionType)type {
    
    
    [self showActionSheet:NO
               completion:^{
                   
                   [self dismissViewControllerAnimated:NO completion:^{
                       
                       if ([self.delegate respondsToSelector:@selector(yourPlaceActionSheetViewController:shouldEditPlaceWithType:)]) {
                           [self.delegate yourPlaceActionSheetViewController:self shouldEditPlaceWithType:type];
                       }
                   }];
               }];
}

@end
