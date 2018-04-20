//
//  SignupView.m
//  RoundsOnMe
//
//  Created by Peter Su on 29/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "SignupView.h"
#import "UIFont+Yamo.h"
#import "LOCMacros.h"
#import "NSNumber+Yamo.h"

NSString * const circleForProfileImage = @"oval";
NSString * const loginFacebookText = @"Connect with Facebook";
NSString * const loginFacebookBackground = @"FBBlueButtonBackground";
NSString * const addImage = @"X";
NSString * const signUpBackgroundEnabled = @"Buttonyellowactive";
NSString * const signUpBackgroundDisabled = @"Buttonyellowdisabled";

static CGFloat SignupProfileImageSize = 100.0f;

@interface SignupView ()

@property CGFloat topViewHeight;
@property CGFloat middleViewHeight;

@end

@implementation SignupView

- (UIView *)topView {
    
    UIView *topView = [[UIView alloc] init];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:topView];
    
    self.topViewHeight = 220;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:_topViewHeight]];
    
    self.profileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:circleForProfileImage]];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.cornerRadius = SignupProfileImageSize / 2;
    self.profileImageView.layer.borderWidth = 0.2;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [topView addSubview:self.profileImageView];
    [self profileImageConstraints:topView];
  
    self.plusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:addImage]];
    self.plusImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.profileImageView addSubview:self.plusImageView];
    [self plusImageConstraints:topView];
    
    //----Login Button
    self.loginWithFacebook = [[UIButton alloc] init];
    self.loginWithFacebook.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginWithFacebook setBackgroundImage:[UIImage imageNamed:loginFacebookBackground] forState:UIControlStateNormal];
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(loginFacebookText, nil) attributes:attributes];
    
    [self.loginWithFacebook setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [topView addSubview:self.loginWithFacebook];
    [self loginButtonConstrints:topView];
  
    return topView;
}

- (UIView *)middleView {
    
    self.signupFormView = [SignupFormView loadFromNib];
    self.signupFormView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.middleViewHeight = self.signupFormView.frame.size.height;
    return self.signupFormView;
}

- (UIView *)bottomView {
 
    UIView *bottomView = [[UIView alloc] init];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomView];
    
    CGFloat navigationBarHeight = 44.0f;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat height = screenHeight - self.topViewHeight - self.middleViewHeight - 20;
    
    if (IS_IPHONE_4_OR_LESS) {
        height = height*2; // We want to maximise the extra space as the sign up form is quite large
    }
    else {
        height -= navigationBarHeight; // Minus the navigation bar height
    }
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:bottomView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:height]
                           ]];
    
    NSAttributedString *signupTitleNormal = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Sign up", nil)
                                                                            attributes:@{ NSFontAttributeName:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                                                                          NSKernAttributeName:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14],
                                                                                          NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:1.0]
                                                                                          }];
  
    self.signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signupButton setAttributedTitle:signupTitleNormal forState:UIControlStateNormal];
    [self.signupButton setTintColor:[UIColor whiteColor]];
    [self.signupButton setBackgroundImage:[UIImage imageNamed:signUpBackgroundEnabled] forState:UIControlStateNormal];
    [self.signupButton setBackgroundImage:[UIImage imageNamed:signUpBackgroundDisabled] forState:UIControlStateDisabled];
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:self.signupButton];
    
    self.goToLoginButton = [[UILabel alloc] init];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacing = 4.0;
    
    NSString *firstPartBottomTitle = NSLocalizedString(@"Already have an account?", nil);
    NSString *secondPartBottomTitle = NSLocalizedString(@"Log in!", nil);
    NSString *wholeTitle = [NSString stringWithFormat:@"%@ %@", firstPartBottomTitle, secondPartBottomTitle];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12],
                                  // NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12]
    };
    
    NSMutableAttributedString *goToLoginButtonTitle = [[NSMutableAttributedString alloc] initWithString:wholeTitle attributes:attributes];

    [goToLoginButtonTitle addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(firstPartBottomTitle.length + 1, secondPartBottomTitle.length)];
    
        
    [self.goToLoginButton setAttributedText:goToLoginButtonTitle];
     self.goToLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:self.goToLoginButton];
    [self addConstraintsForLoginButton:bottomView];
    [self addConstraintsForSignUpButton:bottomView];
    
    [self.signupButton addTarget:self action:@selector(handleDidPressSignupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidPressGoToLoginButton:)];
    tap.numberOfTapsRequired = 1;
    self.goToLoginButton.userInteractionEnabled = YES;
    [self.goToLoginButton addGestureRecognizer:tap];
    
    return  bottomView;
}

- (NSArray<UITextField *> *)formTextFields {
    
    return self.signupFormView.formTextFields;
}

- (NSArray<UIButton *> *)formValidatedButtons {
    
    return @[self.signupButton];
}

- (NSDictionary *)formValuesWithKeys {
    return self.signupFormView.valuesForForm;
}

#pragma mark - Actions

- (void)handleDidPressSignupButton:(UIButton *)sender {

//    if (self.profileImage) {
    
        [super handleDidPressSignupButton:sender];
//    }
//    else {
//        
//        if ([self.delegate respondsToSelector:@selector(signupView:didFailWithErrorReason:)]) {
//            
//            [self.delegate signupView:self didFailWithErrorReason:SignupViewErrorReasonNoPhoto];
//        }
//    }
}

#pragma mark - Constraints

- (void)profileImageConstraints:(UIView*)topView {
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:38.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:SignupProfileImageSize
                            ],
                           [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:SignupProfileImageSize
                            ],
                           [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0
                            ]
                           ]];
}

- (void)plusImageConstraints:(UIView*)topView {
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.plusImageView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.profileImageView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.plusImageView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.plusImageView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:23.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.plusImageView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:23.0
                            ]
                           ]];
    
}

- (void)loginButtonConstrints:(UIView*)topView {
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.loginWithFacebook
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:-2.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginWithFacebook
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:15.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginWithFacebook
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:-15.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginWithFacebook
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.loginWithFacebook
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0
                                                         constant:48.0
                            ]
                           
                           ]];
}

- (void)addConstraintsForLoginButton:(UIView*)bottomView {
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.goToLoginButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem: bottomView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:-15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.goToLoginButton
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:bottomView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0
                            ],
                           [NSLayoutConstraint constraintWithItem:self.goToLoginButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:25
                            ]
                           
                           ]];
    
}

- (void)addConstraintsForSignUpButton:(UIView*)bottomView {
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.signupButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.goToLoginButton
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:-8
                            ],
                           [NSLayoutConstraint constraintWithItem:self.signupButton
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:bottomView
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0
                                                            constant:15
                               ],
                           [NSLayoutConstraint constraintWithItem:self.signupButton
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:bottomView
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:-15
                            ],
                           [NSLayoutConstraint constraintWithItem:self.signupButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:48
                            ]
                           
                           ]];
    
}


#pragma mark - Profile Image

- (void)setProfileImage:(UIImage *)profileImage {
    _profileImage = profileImage;
    
    self.profileImageView.image = _profileImage;
}

@end
