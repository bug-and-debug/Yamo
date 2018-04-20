//
//  LOCLoginView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCStateView.h"
#import "LOCTopBrandingView.h"
#import "LOCLoginFormView.h"
#import "LOCSocialMediaLoginView.h"

@protocol LOCLoginViewDelegate <NSObject>

- (void)loginViewLoginButtonPressed:(UIButton *)button withValues:(NSDictionary *)values;
- (void)loginViewForgottenPasswordButtonPressed:(UIButton *)button withValues:(NSDictionary *)values;
- (void)loginViewSignupButtonPressed:(UIButton *)button withValues:(NSDictionary *)values;
- (void)loginViewDidPressConnectWithSocialMediaType:(AllowedSocialMediaType)socialMediaType;

@end

@interface LOCLoginView : LOCStateView

@property (nonatomic, strong, readonly) LOCTopBrandingView *brandingView;
@property (nonatomic, strong, readonly) LOCLoginFormView *formView;
@property (nonatomic, strong, readonly) NSLayoutConstraint *formViewHeightConstraint;
@property (nonatomic, strong, readonly) LOCSocialMediaLoginView *socialMediaView;

@property (nonatomic, weak) id<LOCLoginViewDelegate> delegate;

#pragma mark - Actions

- (void)handleLoginButtonPressed:(UIButton *)sender;
- (void)handleForgotPasswordButtonPressed:(UIButton *)sender;
- (void)handleSignupButtonPressed:(UIButton *)sender;
- (void)actionForFacebookLogin;
- (void)actionForGooglePlusLogin;
- (void)actionForTwitterLogin;

@end
