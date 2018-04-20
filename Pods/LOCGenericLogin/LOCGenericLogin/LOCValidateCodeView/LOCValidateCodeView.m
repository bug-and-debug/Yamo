//
//  LOCValidateCodeView.m
//  GenericLogin
//
//  Created by Peter Su on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCValidateCodeView.h"

@interface LOCValidateCodeView ()

@property (nonatomic, strong) LOCTopBrandingView *brandingView;
@property (nonatomic, strong) LOCValidateCodeFormView *formView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation LOCValidateCodeView

- (void)setup {
    
    [super setup];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setImage:[UIImage imageNamed:@"back-arrow"]
                                           forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    
    [self pinView:self.cancelButton forHeight:44];
    [self pinView:self.cancelButton forWidth:44];
    [self addConstraint:[self constraintForView:self.cancelButton 
                                         toView:self
                                      attribute:NSLayoutAttributeTop
                                        padding:0]];
    [self addConstraint:[self constraintForView:self.cancelButton
                                         toView:self
                                      attribute:NSLayoutAttributeLeft
                                        padding:kTextFieldLeadingTrailingMargin - 16]];
    
    [self.cancelButton addTarget:self
                          action:@selector(handleDidPressCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
}

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
    
    self.formView = [LOCValidateCodeFormView new];
    [self.formView.submitButton addTarget:self action:@selector(handleDidPressSubmitButton:)
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

- (void)handleDidPressSubmitButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(validateCodeViewDidPressSubmitDetailsButton:withValues:)]) {
        [self.delegate validateCodeViewDidPressSubmitDetailsButton:sender withValues:[self formValuesWithKeys]];
    }
}

- (void)handleDidPressCancelButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(validateCodeViewDidPressCancelButton:)]) {
        [self.delegate validateCodeViewDidPressCancelButton:sender];
    }
}

@end
