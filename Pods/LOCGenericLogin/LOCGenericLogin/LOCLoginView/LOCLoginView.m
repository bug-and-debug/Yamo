//
//  LOCLoginView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCLoginView.h"
#import "LOCSocialButton.h"

@interface LOCLoginView ()

@property (nonatomic, strong) LOCTopBrandingView *brandingView;
@property (nonatomic, strong) LOCLoginFormView *formView;
@property (nonatomic, strong) NSLayoutConstraint *formViewHeightConstraint;
@property (nonatomic, strong) LOCSocialMediaLoginView *socialMediaView;

@end

@implementation LOCLoginView

#pragma mark - Setup

- (void)setup {
    
    [super setup];
    
}

- (void)updateFormForRetainedValues:(NSDictionary<NSString *,NSString *> *)dictionary {
    
    for (UITextField *textField in self.formView.formTextFields) {
        
        if ([[dictionary allKeys] containsObject:textField.LOCLoginFormKey]
            && ![textField.LOCLoginFormKey isEqualToString:LOCFormViewPasswordKey]) {
            
            textField.text = [dictionary objectForKey:textField.LOCLoginFormKey];
        }
    }
}

#pragma mark - LOCStateViewDelegate

- (UIView *)topView {
    
    //self.brandingView = [LOCTopBrandingView new];
    //return self.brandingView;
    self.formView = [LOCLoginFormView new];
    
    [self.formView.loginButton addTarget:self
                                  action:@selector(handleLoginButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.formView.goToForgotPasswordButton addTarget:self
                                               action:@selector(handleForgotPasswordButtonPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
    [self.formView.signupButton addTarget:self
                                   action:@selector(handleSignupButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    return self.formView;
}

- (UIView *)middleView {
    
    self.formView = [LOCLoginFormView new];
    
    [self.formView.loginButton addTarget:self
                                  action:@selector(handleLoginButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.formView.goToForgotPasswordButton addTarget:self
                                               action:@selector(handleForgotPasswordButtonPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
    [self.formView.signupButton addTarget:self
                                   action:@selector(handleSignupButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    return self.formView;
}

- (UIView *)bottomView {
    
    self.socialMediaView = [LOCSocialMediaLoginView new];
    self.socialMediaView.backgroundColor = [UIColor cyanColor];
    
    NSArray *socialMediaButtonTypes = @[ @(AllowedSocialMediaTypeFacebook),
                                         @(AllowedSocialMediaTypeTwitter),
                                         @(AllowedSocialMediaTypeGooglePlus) ];
    [self.socialMediaView setAllowedSocialMediaButtonTypes:socialMediaButtonTypes];
    
    // Default actions for social media buttons
    [self.socialMediaView action:^{
        [self actionForFacebookLogin];
    }
             forSocialButtonType:AllowedSocialMediaTypeFacebook];
    
    [self.socialMediaView action:^{
        [self actionForTwitterLogin];
    }
             forSocialButtonType:AllowedSocialMediaTypeTwitter];
    
    [self.socialMediaView action:^{
        [self actionForGooglePlusLogin];
    }
             forSocialButtonType:AllowedSocialMediaTypeGooglePlus];
    
    
    return self.socialMediaView;
}

- (NSArray<UITextField *> *)formTextFields {
    return self.formView.formTextFields;
}

- (NSArray<UIButton *> *)formValidatedButtons {
    return self.formView.formValidatedButtons;
}

- (NSDictionary *)formValuesWithKeys {
    return self.formView.valuesForForm;
}

#pragma mark - Actions

- (void)handleLoginButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(loginViewLoginButtonPressed:withValues:)]) {
        
        [self.delegate loginViewLoginButtonPressed:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)handleForgotPasswordButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(loginViewForgottenPasswordButtonPressed:withValues:)]) {
        
        [self.delegate loginViewForgottenPasswordButtonPressed:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)handleSignupButtonPressed:(UIButton *)sender {
 
    if ([self.delegate respondsToSelector:@selector(loginViewSignupButtonPressed:withValues:)]) {
        
        [self.delegate loginViewSignupButtonPressed:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)actionForFacebookLogin {
    
    if ([self.delegate respondsToSelector:@selector(loginViewDidPressConnectWithSocialMediaType:)]) {
        
        [self.delegate loginViewDidPressConnectWithSocialMediaType:AllowedSocialMediaTypeFacebook];
    }
}

- (void)actionForGooglePlusLogin {
    
    if ([self.delegate respondsToSelector:@selector(loginViewDidPressConnectWithSocialMediaType:)]) {
        
        [self.delegate loginViewDidPressConnectWithSocialMediaType:AllowedSocialMediaTypeGooglePlus];
    }
}

- (void)actionForTwitterLogin {
    
    if ([self.delegate respondsToSelector:@selector(loginViewDidPressConnectWithSocialMediaType:)]) {
        
        [self.delegate loginViewDidPressConnectWithSocialMediaType:AllowedSocialMediaTypeTwitter];
    }
}

@end
