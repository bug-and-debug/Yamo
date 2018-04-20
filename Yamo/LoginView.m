//
//  LoginView.m
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LoginView.h"
#import "SignUpViewController.h"
#import "UIFont+Yamo.h"
#import "LOCMacros.h"
#import "NSNumber+Yamo.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
            colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@import UIView_LOCExtensions;

NSString * const LOCFormViewEmailKey = @"LOCFormViewEmailKey";
NSString * const loginBackgroundEnabled1 = @"Buttonyellowactive";
NSString * const loginBackgroundDisabled1 = @"Buttonyellowdisabled";

NSString * const loginFacebookButtonText = @"Log In with Facebook";

@interface LoginView()

@property CGFloat topViewHeight;
@property CGFloat middleViewHeight;

@end

@implementation LoginView


- (void)setup {
    [super setup];
    
}
- (UIView *)topView {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.topViewHeight = screenHeight/4;
    self.topViewHeight -= 18;

    UIView *brand = [[UIView alloc] init];
    brand.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:brand];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:brand
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:_topViewHeight]];
    
    return brand;
}
- (UIView *)middleView {
    
    self.loginFormView = [LoginFormView loadFromNib];
    self.loginFormView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginFormView.forgotPasswordButton addTarget:self action:@selector(handleForgotPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginFormView.facebookButton addTarget:self action:@selector(actionForFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(loginFacebookButtonText, nil) attributes:attributes];
    [self.loginFormView.facebookButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    self.middleViewHeight = self.loginFormView.frame.size.height;
    return self.loginFormView;
}

- (UIView *)bottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomView];
    
    CGFloat navigationBarHeight = 44.0f;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat height = screenHeight - self.topViewHeight - self.middleViewHeight - 20;
    
    height -= navigationBarHeight;
    
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:bottomView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:height]
                           ]];
    
    UIFont *graphikRegular14 = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    UIFont *graphikRegular12 = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    
    
    NSAttributedString *loginTitleNormal = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Sign in", nil)
                                                                           attributes:@{ NSFontAttributeName : graphikRegular14,
                                                                                         NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                                                                         NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:1.0]  }];

    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setAttributedTitle:loginTitleNormal forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 15;
    self.loginButton.clipsToBounds = YES;
    self.loginButton.backgroundColor = UIColorFromRGB(0x58BC80);
    self.loginButton.contentMode = UIViewContentModeRedraw;
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
 
    [self addSubview:self.loginButton];
    
   
    NSDictionary *signupAttributes = @{ NSFontAttributeName : graphikRegular14,
                                        NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                        NSForegroundColorAttributeName: UIColorFromRGB(0x46649E) };
    NSAttributedString *signupTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LogIn with Facebook", nil)
                                                                      attributes:signupAttributes];
    
    NSMutableAttributedString *signupButtonTitle = [NSMutableAttributedString new];
    [signupButtonTitle appendAttributedString:signupTitle ];
    
    self.fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.fbButton setAttributedTitle:signupButtonTitle forState:UIControlStateNormal];
    self.fbButton.titleLabel.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14];
    self.fbButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fbButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.fbButton];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.fbButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:-18
                            ],
                           [NSLayoutConstraint constraintWithItem:self.fbButton
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.fbButton
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:-15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.fbButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:21.5f
                            ],
                           ]];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.fbButton
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:-8.0f
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:-15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:48
                            ],
                           ]];
//    [self.signupButton addTarget:self action:@selector(handleSignupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.fbButton addTarget:self action:@selector(actionForFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(handleLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return  bottomView;
}
 
- (NSArray<UITextField *> *)formTextFields {
    
    return self.loginFormView.formTextFields;
}

- (NSArray<UIButton *> *)formValidatedButtons {
    
    return @[self.loginButton];
}

- (NSDictionary *)formValuesWithKeys {
    return self.loginFormView.valuesForForm;
}


@end
