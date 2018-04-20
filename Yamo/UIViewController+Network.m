//
//  UIViewController+Network.m
//  Yamo
//
//  Created by Peter Su on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIViewController+Network.h"
#import <objc/runtime.h>

@import UIView_LOCExtensions;

@implementation UIViewController (Network)

- (UIView *)networkActivityIndicatorContainer {
    return objc_getAssociatedObject(self, @selector(networkActivityIndicatorContainer));
}

- (void)setNetworkActivityIndicatorContainer:(UIView *)networkActivityIndicatorContainer {
    objc_setAssociatedObject(self, @selector(networkActivityIndicatorContainer), networkActivityIndicatorContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)networkActivityIndicator {
    return objc_getAssociatedObject(self, @selector(networkActivityIndicator));
}

- (void)setNetworkActivityIndicator:(UIActivityIndicatorView *)networkActivityIndicator {
    objc_setAssociatedObject(self, @selector(networkActivityIndicator), networkActivityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showIndicator:(BOOL)show {

    if (!self.networkActivityIndicator) {
        [self initializeActivityIndicator];
    }
    
    if (show) {
        [self.networkActivityIndicator startAnimating];
        self.networkActivityIndicatorContainer.hidden = NO;
    } else {
        [self.networkActivityIndicator stopAnimating];
        self.networkActivityIndicatorContainer.hidden = YES;
    }
}

#pragma mark - Private

- (void)initializeActivityIndicator {
    
    self.networkActivityIndicatorContainer = [UIView new];
    self.networkActivityIndicatorContainer.hidden = YES;
    self.networkActivityIndicatorContainer.layer.cornerRadius = 5.0f;
    self.networkActivityIndicatorContainer.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    self.networkActivityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.networkActivityIndicatorContainer pinHeight:44.0f];
    [self.networkActivityIndicatorContainer pinWidth:44.0f];
    
    [self.view addSubview:self.networkActivityIndicatorContainer];
    [self.view pinToCenterWithView:self.networkActivityIndicatorContainer];
    
    
    self.networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.networkActivityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.networkActivityIndicator.hidesWhenStopped = YES;
    
    [self.networkActivityIndicatorContainer addSubview:self.networkActivityIndicator];
    [self.view pinToCenterWithView:self.networkActivityIndicator];
    
    [self.view layoutIfNeeded];
    
}

@end
