//
//  LOCForgotPasswordView.m
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCForgotPasswordView.h"

@interface LOCForgotPasswordView () 

@property (nonatomic, strong) LOCTopBrandingView *brandingView;
@property (nonatomic, strong) LOCForgotPasswordFormView *formView;

@end

@implementation LOCForgotPasswordView

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
    
    self.formView = [LOCForgotPasswordFormView new];
    
    [self.formView.submitEmailButton addTarget:self
                                        action:@selector(handleDidPressSubmitEmailButton:)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.formView.cancelButton addTarget:self
                                   action:@selector(handleDidPressCancelButton:)
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

- (void)handleDidPressSubmitEmailButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(forgotPasswordViewButtonPressed:withValues:)]) {
        [self.delegate forgotPasswordViewButtonPressed:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)handleDidPressCancelButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(forgotPasswordViewCancelButtonPressed:)]) {
        [self.delegate forgotPasswordViewCancelButtonPressed:sender];
    }
}

@end
