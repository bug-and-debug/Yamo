//
//  LOCFloatingTextField.h
//
//  Created by Simon Lee on 09/06/2015.
//  Copyright (c) 2015 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LOComponentAnimate) {
    LOComponentAnimateUpwards,
    LOComponentAnimateDownwards
};

@interface LOCFloatingTextField : UITextField

@property (strong, nonatomic) IBInspectable NSString *placeholderLabelText;

@property (strong, nonatomic) IBInspectable UIColor *placeholderTextColor;

@property (strong, nonatomic) IBInspectable UIColor *placeholderAnimatedTextColor;

@property (assign, nonatomic) IBInspectable CGFloat leftPadding;

@property (assign, nonatomic) IBInspectable CGFloat rightPadding;

@property (strong, nonatomic) UIFont *placeholderTextFont;

@property (strong, nonatomic) UIFont *placeholderAnimatedTextFont;

@property (assign, nonatomic) LOComponentAnimate animationType;

- (void)initialise;

@end
