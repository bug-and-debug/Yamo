//
//  SignupView.h
//  RoundsOnMe
//
//  Created by Peter Su on 29/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <LOCGenericLogin/LOCSignupView.h>
#import "SignupFormView.h"

@interface SignupView : LOCSignupView

@property (nonatomic, strong) SignupFormView *signupFormView;
@property (nonatomic, strong) UIButton *loginWithFacebook;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImageView *plusImageView;

@property (strong, nonatomic) UIButton *signupButton;
@property (strong, nonatomic) UILabel *goToLoginButton;
@property (nonatomic) UIImage *profileImage;

@end
