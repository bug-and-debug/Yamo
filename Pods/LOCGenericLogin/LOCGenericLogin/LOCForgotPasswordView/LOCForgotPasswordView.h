//
//  LOCForgotPasswordView.h
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCStateView.h"
#import "LOCForgotPasswordFormView.h"
#import "LOCTopBrandingView.h"

@protocol LOCForgotPasswordViewDelegate <NSObject>

- (void)forgotPasswordViewButtonPressed:(UIButton *)button withValues:(NSDictionary *)values;
- (void)forgotPasswordViewCancelButtonPressed:(UIButton *)button;

@end

@interface LOCForgotPasswordView : LOCStateView

@property (nonatomic, strong, readonly) LOCTopBrandingView *brandingView;
@property (nonatomic, strong, readonly) LOCForgotPasswordFormView *formView;
@property (nonatomic, weak) id<LOCForgotPasswordViewDelegate> delegate;

- (void)handleDidPressSubmitEmailButton:(UIButton *)sender;
- (void)handleDidPressCancelButton:(UIButton *)sender;

@end
