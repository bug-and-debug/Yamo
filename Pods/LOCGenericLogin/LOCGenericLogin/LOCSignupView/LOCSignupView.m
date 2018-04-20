//
//  LOCSignupView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSignupView.h"

@interface LOCSignupView ()

@property (nonatomic, strong) LOCTopBrandingView *brandingView;
@property (nonatomic, strong) LOCSignupFormView *formView;

@end

@implementation LOCSignupView

- (void)updateFormForRetainedValues:(NSDictionary<NSString *,NSString *> *)dictionary {
    
    for (UITextField *textField in self.formView.formTextFields) {
        
        if ([[dictionary allKeys] containsObject:textField.LOCLoginFormKey]) {
            textField.text = [dictionary objectForKey:textField.LOCLoginFormKey];
        }
    }
}

#pragma mark - LOCStateViewDelegate

- (UIView *)topView {
    
    self.brandingView = [LOCTopBrandingView new];
    return self.brandingView;
}

- (UIView *)middleView {
    
    self.formView = [LOCSignupFormView new];
    
    [self.formView.signupButton addTarget:self
                                   action:@selector(handleDidPressSignupButton:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.formView.goToLoginButton addTarget:self
                                      action:@selector(handleDidPressGoToLoginButton:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    return self.formView;
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

- (void)handleDidPressSignupButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(signupViewDidPressSignupButton:withValues:)]) {
        [self.delegate signupViewDidPressSignupButton:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)handleDidPressGoToLoginButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(signupViewDidPressBackToLoginButton:withValues:)]) {
        [self.delegate signupViewDidPressBackToLoginButton:sender withValues:[self formValuesWithKeys]];
    }
}

@end
