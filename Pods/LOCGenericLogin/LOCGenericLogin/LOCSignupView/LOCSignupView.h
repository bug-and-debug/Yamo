//
//  LOCSignupView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCStateView.h"
#import "LOCTopBrandingView.h"
#import "LOCSignupFormView.h"
@class LOCSignupView;

typedef NS_ENUM(NSUInteger, SignupViewErrorReason) {
    
    SignupViewErrorReasonUnknown,
    SignupViewErrorReasonNoPhoto
};

@protocol LOCSignupViewDelegate <NSObject>

- (void)signupViewDidPressSignupButton:(UIButton *)button withValues:(NSDictionary *)values;
- (void)signupViewDidPressBackToLoginButton:(UIButton *)button withValues:(NSDictionary *)values;
- (void)signupView:(LOCSignupView *)signupView didFailWithErrorReason:(SignupViewErrorReason)reason;

@end

@interface LOCSignupView : LOCStateView

@property (nonatomic, strong, readonly) LOCTopBrandingView *brandingView;
@property (nonatomic, strong, readonly) LOCSignupFormView *formView;
@property (nonatomic, weak) id<LOCSignupViewDelegate>delegate;

- (void)handleDidPressSignupButton:(UIButton *)sender;
- (void)handleDidPressGoToLoginButton:(UIButton *)sender;;

@end
