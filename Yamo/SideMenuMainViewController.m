//
//  SideMenuMainViewController.m
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SideMenuMainViewController.h"
#import "APIClient+Authentication.h"

CGFloat const SideMenuViewControllerWidth = 220.0f;

@interface SideMenuMainViewController () <ContentNavigationControllerDelegate>

@property (nonnull) UITapGestureRecognizer *dismissMenuTapGestureRecognizer;
@property (nonnull) UIPanGestureRecognizer *dismissMenuPanGestureRecognizer;
@property (nonnull) UIView *OverlayView;

@property (nonatomic) CGFloat panStartX;
@property (nonatomic) CGFloat panDiff;

@property (nonatomic) BOOL sideMenuIsShowing;

@end

@implementation SideMenuMainViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.contentNavigationController = [ContentNavigationController new];
        self.contentNavigationController.menuDelegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.contentNavigationController];
    [self.view addSubview:self.contentNavigationController.view];
    [self.contentNavigationController didMoveToParentViewController:self];
    
    self.OverlayView = [self setTransparentOverlayForContentView];
    self.dismissMenuTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissMenuTapGestureRecognizer:)];
    
    [self.contentNavigationController.view addGestureRecognizer:self.dismissMenuTapGestureRecognizer];
    self.dismissMenuTapGestureRecognizer.enabled = NO;
    
    self.dismissMenuPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    
    [self.sideMenuViewController.view addGestureRecognizer:self.dismissMenuPanGestureRecognizer];
    self.dismissMenuPanGestureRecognizer.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setLeftMenuHidden:!self.sideMenuIsShowing animated:NO];
}

#pragma mark - ViewController Management

- (void)displayNavigationControllerWithRootViewController:(UIViewController *)rootViewController {
    
    [self.contentNavigationController setViewControllers:@[rootViewController] ];
}

- (void)selectViewControllerAtIndex:(NSUInteger)index {
    
    [self displayNavigationControllerWithRootViewController:self.viewControllers[index]];
}

#pragma mark - ViewControllers
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    [self.sideMenuViewController setViewControllers:_viewControllers];
}

#pragma mark - SideMenu

- (void)prepareSideMenu {
    
    if (!self.sideMenuViewController) {
        
        self.sideMenuViewController = [SideMenuViewController new];
        [self.sideMenuViewController setViewControllers:self.viewControllers];
        self.sideMenuViewController.delegate = self;
        
        [self.view addSubview:self.sideMenuViewController.view];
        [self addChildViewController:self.sideMenuViewController];
        
        [self.sideMenuViewController didMoveToParentViewController:self];
        
        self.sideMenuViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
        

    }
    
}
- (void)setLeftMenuHidden:(BOOL)hidden animated:(BOOL)animated {
    
    // End editing on current view
    UIViewController *activeViewController = [self.contentNavigationController.viewControllers lastObject];
    if (activeViewController) {
        [activeViewController.view endEditing:YES];
    }
    
    [self setLeftMenuHidden:hidden animated:animated completion:nil];
}

- (void)setLeftMenuHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    
    [self prepareSideMenu];
    
    void (^animationBlock)() = ^() {
        
        if (hidden) {
            self.contentNavigationController.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
            self.sideMenuViewController.view.frame = CGRectMake(-SideMenuViewControllerWidth, 0.0f, SideMenuViewControllerWidth, self.view.bounds.size.height);
            [self.OverlayView removeFromSuperview];

            
        }
        else {
            
            self.contentNavigationController.view.frame = CGRectMake(SideMenuViewControllerWidth, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
            self.sideMenuViewController.view.frame = CGRectMake(0.0f, 0.0f, SideMenuViewControllerWidth, self.view.bounds.size.height);
            [self.contentNavigationController.view addSubview:self.OverlayView];

            
        }
    };
    
    void (^completionBlock)(BOOL) =  ^(BOOL finished) {
        
        if (finished) {
            
            if (hidden) {
                
                self.sideMenuIsShowing = NO;
                self.dismissMenuTapGestureRecognizer.enabled = NO;
                self.dismissMenuPanGestureRecognizer.enabled = NO;
 
            }
            else {
                
                self.sideMenuIsShowing = YES;
                self.dismissMenuTapGestureRecognizer.enabled = YES;
                self.dismissMenuPanGestureRecognizer.enabled = YES;
                [self.sideMenuViewController loadNotificationBadge];

            }
        }
        
        if (completion) {
            
            completion(finished);
        }
    };
    
    if (animated) {
        
        [UIView animateWithDuration:0.5
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animationBlock
                         completion:completionBlock];
        
    }
    else {
        
        animationBlock();
        completionBlock(YES);
    }
}

#pragma mark - Gestures

- (void)handleDismissMenuTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    
    [self setLeftMenuHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SideMenuViewControllerDelegate

- (void)sideMenuViewController:(SideMenuViewController *)sideMenuViewController didSelectItemAtIndex:(NSUInteger)index {
    
    [self setLeftMenuHidden:YES animated:YES];
    
    [self selectViewControllerAtIndex:index];
}

- (void)sideMenuViewControllerDidSelectFooter:(SideMenuViewController *)sideMenuViewController {
    
    NSString *logoutTitle = NSLocalizedString(@"Log out", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak SideMenuMainViewController *weakSelf = self;
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:logoutTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[APIClient sharedInstance] logoutWithSuccessBlock:^{
            NSLog(@"Logged out from the server");
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            NSLog(@"Failed to log out from the server");
        }];
        
        if ([weakSelf.delegate respondsToSelector:@selector(sideMenuMainViewControllerDidSelectLogoutButton:)]) {
            [weakSelf setLeftMenuHidden:YES animated:NO completion:nil];
            [weakSelf.delegate sideMenuMainViewControllerDidSelectLogoutButton:self];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        self.sideMenuViewController.footerView.backgroundColor = [UIColor clearColor];
        
        }];
    
    [alertController addAction:logoutAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sideMenuViewControllerDidSelectHeader:(SideMenuViewController *)sideMenuViewController {
    
    [self setLeftMenuHidden:YES animated:YES];
}

#pragma mark - ContentNavigationControllerDelegate

- (void)contentNavigationControllerMenuButtonWasTapped:(ContentNavigationController *)contentNavigationController {
    
    if (self.sideMenuIsShowing) {
        
        [self setLeftMenuHidden:YES animated:YES];
    }
    else {
        
        [self setLeftMenuHidden:NO animated:YES];
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.sideMenuViewController.view];
    CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            self.panStartX = touchLocation.x;
            self.panDiff = 0;
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            self.panDiff = touchLocation.x - self.panStartX;
            self.panStartX = touchLocation.x;
            
            CGFloat expectedXPosition = self.sideMenuViewController.view.frame.origin.x + self.panDiff;
            
            if (expectedXPosition > -SideMenuViewControllerWidth && expectedXPosition <= 0) {
                
                CGRect sideMenuFrame = self.sideMenuViewController.view.frame;
                sideMenuFrame.origin.x = expectedXPosition;
                self.sideMenuViewController.view.frame = sideMenuFrame;
                
                CGRect frame = self.contentNavigationController.view.frame;
                frame.origin.x = CGRectGetMaxX(self.sideMenuViewController.view.frame);
                self.contentNavigationController.view.frame = frame;
                
                //            CGFloat progress = gestureRecognizer.view.center.x / self.sideMenuViewController.view.bounds.size.width;
                
                //            self.dimOutView.alpha = progress;
            }
            
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if (self.sideMenuViewController) {
                
                BOOL shouldCompleteTransition = gestureRecognizer.view.center.x > self.sideMenuViewController.view.bounds.origin.x;
                
                if (velocity.x > SideMenuViewControllerVelocityThreshold) {
                    
                    shouldCompleteTransition = YES;
                }
                else if (velocity.x < -SideMenuViewControllerVelocityThreshold) {
                    
                    shouldCompleteTransition = NO;
                }
                
                [self setLeftMenuHidden:!shouldCompleteTransition animated:YES];
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Set Transparent Overlay

- (UIView *) setTransparentOverlayForContentView {
    UIView* transparentOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    transparentOverlay.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    return transparentOverlay;
}

@end
