//
//  LeftMenuViewController.m
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"
#import "UserService.h"

@interface LeftMenuViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *footerViewTapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *footerViewLongPressGestureRecognizer;

@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIImageView *yamoHeaderLogo;
@property (nonatomic) UIView *headerContentView;
@property (nonatomic) UIView *footerContentView;

@end

@implementation LeftMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        void (^setupLogoutButtonTitle)(BOOL) = ^(BOOL hasSubscription){

            NSString *logoutTitle = hasSubscription ? NSLocalizedString(@"Log out", nil) : @"";
            NSMutableAttributedString *logOutAttributedText = [[NSMutableAttributedString alloc] initWithString:logoutTitle];
            [logOutAttributedText addAttribute:NSKernAttributeName value:@(1.0f) range:NSMakeRange(0, [logOutAttributedText length])];
            [logOutAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [logOutAttributedText length])];
            [self.logoutButton setAttributedTitle:logOutAttributedText forState:UIControlStateNormal];
        };
        
        self.logoutButton =  [[UIButton alloc] initWithFrame:CGRectZero];
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.logoutButton.titleLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:17.0f];
        [self.logoutButton addTarget:self action:@selector(handleFooterViewButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        setupLogoutButtonTitle(NO);
        
        [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
            setupLogoutButtonTitle(hasSubscription);
        }];
        
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.closeButton setImage:[UIImage imageNamed:@"dismiss_X"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(handleHeaderViewButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.yamoHeaderLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.yamoHeaderLogo.translatesAutoresizingMaskIntoConstraints = NO;
        self.yamoHeaderLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self.yamoHeaderLogo setImage:[UIImage imageNamed:@"Yamo_logo_01B"]];
        
        self.headerContentView = [UIView new];
        self.footerContentView = [UIView new];
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUserSubscriptionStatusChangedForLogout:)
                                                     name:UserServiceUserTypeChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIView *)headerView{
    
    [self.headerContentView addSubview: self.closeButton];
    [self.headerContentView addSubview: self.yamoHeaderLogo];
    [self setYamoLogoInHeaderContraints];
    [self setCloseButtonInHeaderContrants];
    return self.headerContentView;
}

- (UIView *)footerView {
    
    self.footerViewTapGestureRecognizer = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(handleFooterViewButtonTap:)];
    self.footerViewLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(handleFooterViewLongPressGestures:)];
    [self.footerContentView addGestureRecognizer:self.footerViewTapGestureRecognizer];
    [self.footerContentView addGestureRecognizer:self.footerViewLongPressGestureRecognizer];
    [self.footerContentView addSubview: self.logoutButton];
    [self setLogoutButtonInFooterContrants];
    
    self.footerViewTapGestureRecognizer.enabled = NO;
    self.footerViewLongPressGestureRecognizer.enabled = NO;
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        self.footerViewTapGestureRecognizer.enabled = hasSubscription;
        self.footerViewLongPressGestureRecognizer.enabled = hasSubscription;
    }];
    
    return self.footerContentView;
}

- (void)handleUserSubscriptionStatusChangedForLogout:(id)sender {
    
    [[UserService sharedInstance] checkSubscriptionStatus:^(User *user, BOOL hasSubscription) {
        
        self.footerViewTapGestureRecognizer.enabled = hasSubscription;
        self.footerViewLongPressGestureRecognizer.enabled = hasSubscription;
        
        NSString *title = hasSubscription ? NSLocalizedString(@"Log out", nil) : @"";
        
        NSMutableAttributedString *logOutAttributedText = [[NSMutableAttributedString alloc] initWithString:title];
        [logOutAttributedText addAttribute:NSKernAttributeName value:@(1.0f) range:NSMakeRange(0, [logOutAttributedText length])];
        [logOutAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [logOutAttributedText length])];
        [self.logoutButton setAttributedTitle:logOutAttributedText forState:UIControlStateNormal];
    }];
}

- (void)handleFooterViewLongPressGestures:(UILongPressGestureRecognizer *)sender {

    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        UILongPressGestureRecognizer *gesture = sender;
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
                [self.footerContentView setBackgroundColor:[UIColor yamoOrange]];
                break;
            case UIGestureRecognizerStateEnded:
                [self.footerContentView setBackgroundColor:[UIColor clearColor]];
                if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidSelectFooter:)]) {
                    [self.delegate sideMenuViewControllerDidSelectFooter:self];
                }
                break;
            default:
                break;
        }
    }
}

- (void)handleFooterViewButtonTap:(id)sender {
    
    [self.footerContentView setBackgroundColor:[UIColor yamoOrange]];
    
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidSelectFooter:)]) {
        [self.delegate sideMenuViewControllerDidSelectFooter:self];
    }
}

- (void)handleHeaderViewButtonTap:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidSelectHeader:)]) {
        
        [self.delegate sideMenuViewControllerDidSelectHeader:self];
    }
}

#pragma mark - Constraints for Views in Header

- (void) setCloseButtonInHeaderContrants{
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                          attribute:NSLayoutAttributeTopMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.headerContentView
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:1.0f
                                                           constant:26.0f]];
    
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.headerContentView
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1.0f
                                                           constant:-15.0f]];
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:32.0f]];
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                        constant:32.0f]];
}

- (void) setLogoutButtonInFooterContrants{
    
    [self.footerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.footerContentView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1.0f
                                                                        constant:0.0f]];
    
    
//    [self.footerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton
//                                                                       attribute:NSLayoutAttributeTrailingMargin
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:self.footerContentView
//                                                                       attribute:NSLayoutAttributeTrailingMargin
//                                                                      multiplier:1.0f
//                                                                        constant:0.0f]];
    
    [self.footerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton
                                                                       attribute:NSLayoutAttributeLeadingMargin
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.footerContentView
                                                                       attribute:NSLayoutAttributeLeadingMargin
                                                                      multiplier:1.0f
                                                                        constant:16.0f]];
    
    [self.footerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:32.0f]];
    
}
- (void) setYamoLogoInHeaderContraints{
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yamoHeaderLogo
                                                                       attribute:NSLayoutAttributeTopMargin
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.headerContentView
                                                                       attribute:NSLayoutAttributeTopMargin
                                                                      multiplier:1.0f
                                                                        constant:45.0f]];
    
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yamoHeaderLogo
                                                                       attribute:NSLayoutAttributeLeadingMargin
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.headerContentView
                                                                       attribute:NSLayoutAttributeLeadingMargin
                                                                      multiplier:1.0f
                                                                        constant:10.0f]];
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yamoHeaderLogo
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:80.0f]];
    
    [self.headerContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.yamoHeaderLogo
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f
                                                                        constant:80.0]];
    


}

#pragma mark - Status Bar Apparence

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
