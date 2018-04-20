//
//  NavigationController.m
//  Yamo
//
//  Created by Dario Langella on 15/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ContentNavigationController.h"
#import "UINavigationBar+Yamo.h"

@interface ContentNavigationController ()
@property (nonatomic, strong) UIBarButtonItem *hamburgerButton;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@end

@implementation ContentNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setNavigationBarStyleOpaque];
}

// Note: Modification from Sep 2016 - Change requests from Yamo
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    NSMutableSet *items = viewController.navigationItem.leftBarButtonItems ? [NSMutableSet setWithArray:viewController.navigationItem.leftBarButtonItems] : [[NSMutableSet alloc] init];
//    
//    if (navigationController.viewControllers.count == 1) {
//        
//        // Add Hamburger icon when the it's the first view controller
//        
//        if (!self.hamburgerButton) {
//            self.hamburgerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icondarkmenudisabled"] style:UIBarButtonItemStylePlain target:self action:@selector(handleMenuBarButtonTap:)];
//        }
//        
//        [items addObject:self.hamburgerButton];
//    }
//    else if (items.count == 0) {
//        
//        // Otherwise add custom back button if there are no custom buttons in the view controller
//        
//        if (!self.backBarButton) {
//            self.backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icondarkdisabled 2"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBackBarButtonTap:)];
//        }
//        
//        [items addObject:self.backBarButton];
//    }
//    
//    viewController.navigationItem.leftItemsSupplementBackButton = NO;
//    viewController.navigationItem.backBarButtonItem = nil;
//    viewController.navigationItem.leftBarButtonItem = nil;
//    viewController.navigationItem.leftBarButtonItems = items.allObjects;
//}
//
//- (void)handleBackBarButtonTap:(id)sender {
//    [self popViewControllerAnimated:YES];
//}
//
//- (void)handleMenuBarButtonTap:(id)sender {
//    [self.menuDelegate contentNavigationControllerMenuButtonWasTapped:self];
//}

@end
