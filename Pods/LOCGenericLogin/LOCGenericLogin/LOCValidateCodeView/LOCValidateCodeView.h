//
//  LOCValidateCodeView.h
//  GenericLogin
//
//  Created by Peter Su on 24/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCStateView.h"
#import "LOCTopBrandingView.h"
#import "LOCValidateCodeFormView.h"

@protocol LOCValidateCodeViewDelegate <NSObject>

- (void)validateCodeViewDidPressCancelButton:(UIButton *)button;
- (void)validateCodeViewDidPressSubmitDetailsButton:(UIButton *)button withValues:(NSDictionary *)values;

@end


@interface LOCValidateCodeView : LOCStateView

@property (nonatomic, strong, readonly) LOCTopBrandingView *brandingView;
@property (nonatomic, strong, readonly) LOCValidateCodeFormView *formView;
@property (nonatomic, strong, readonly) UIButton *cancelButton;
@property (nonatomic, weak) id<LOCValidateCodeViewDelegate> delegate;

- (void)handleDidPressSubmitButton:(UIButton *)sender;
- (void)handleDidPressCancelButton:(UIButton *)sender;

@end
