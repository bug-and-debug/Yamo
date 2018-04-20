//
//  HelpOverlayViewController.h
//  Yamo
//
//  Created by Mo Moosa on 28/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;

@protocol HelpOverlayViewControllerDelegate;

@interface HelpOverlayViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) NSArray *cutouts;

- (UIView *)cutOutViews:(NSArray <NSValue *> *)sourceValues withCornerRadius:(CGFloat)cornerRadius title:(NSString *) title detail:(NSString *)detail;

@property (nonatomic, weak) id<HelpOverlayViewControllerDelegate> delegate;

@end

@protocol HelpOverlayViewControllerDelegate <NSObject>

- (void)dimissHelp:(UIViewController *)controller;

@end