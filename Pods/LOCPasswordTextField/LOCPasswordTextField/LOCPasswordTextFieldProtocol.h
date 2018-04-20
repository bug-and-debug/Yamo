//
//  LOCPasswordTextFieldProtocol.h
//  LOCPasswordTextField
//
//  Created by Peter Su on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@protocol LOCPasswordTextFieldDelegate;

typedef NS_ENUM(NSInteger, LOCPasswordTextFieldRevealState){
    LOCPasswordTextFieldRevealStateRevealed,
    LOCPasswordTextFieldRevealStateHidden
};

@protocol LOCPasswordTextFieldProtocol <NSObject>

@property (nonatomic, weak) id<LOCPasswordTextFieldDelegate> delegate;

@property (nonatomic) LOCPasswordTextFieldRevealState revealState;

@optional

- (UIView *)hiddenEyeCon;

- (UIView *)revealEyeCon;

+ (UIView *)viewForImageIcon:(UIImage *)image leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end

@protocol LOCPasswordTextFieldDelegate <UITextFieldDelegate>

- (BOOL)passwordTextField:(UITextField<LOCPasswordTextFieldProtocol> *)passwordTextField shouldToggleSecureEntryMode:(BOOL)secureEntryMode;

@end
