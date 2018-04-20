//
//  UIViewController+Network.h
//  Yamo
//
//  Created by Peter Su on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Network)

@property (nonatomic, strong) UIView *networkActivityIndicatorContainer;
@property (nonatomic, strong) UIActivityIndicatorView *networkActivityIndicator;

- (void)showIndicator:(BOOL)show;

@end
