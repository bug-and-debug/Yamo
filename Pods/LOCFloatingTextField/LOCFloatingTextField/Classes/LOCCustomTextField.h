//
//  LOCCustomTextField.h
//  LOCCustomTextField
//
//  Created by Peter Su on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LOCCustomTextFieldAnimationType) {
    LOCCustomTextFieldAnimationTypeEntry,
    LOCCustomTextFieldAnimationTypeDisplay
};

typedef void (^ _Nullable LOCCustomTextFieldAnimationBlock)(LOCCustomTextFieldAnimationType animationType);

@protocol LOCCustomTextFieldInterface <NSObject>

- (void)animateViewsForTextEntry;

- (void)animateViewsForTextDisplay;

- (void)drawViewsForRect:(CGRect)rect;

- (void)updateViewsForBoundsChange:(CGRect)rect;

@end

@interface LOCCustomTextField : UITextField <LOCCustomTextFieldInterface>

- (void)initialise;

@property (nonatomic, strong) UILabel * _Nonnull placeholderLabel;

@property (nonatomic, copy) LOCCustomTextFieldAnimationBlock animationCompletionBlock;

@end
