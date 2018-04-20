//
//  LOCCustomTextField.m
//  LOCCustomTextField
//
//  Created by Peter Su on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCustomTextField.h"

@interface LOCCustomTextField ()

@end

@implementation LOCCustomTextField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialise];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initialise];
    }
    
    return self;
}

- (void)initialise {
    
    self.placeholderLabel = [UILabel new];
}

#pragma mark - LOCCustomTextFieldInterface

- (void)animateViewsForTextEntry {
    NSAssert(NO, @"Must be overridden");
}

- (void)animateViewsForTextDisplay {
    NSAssert(NO, @"Must be overridden");
}

- (void)drawViewsForRect:(CGRect)rect {
    NSAssert(NO, @"Must be overridden");
}

- (void)updateViewsForBoundsChange:(CGRect)rect {
    NSAssert(NO, @"Must be overridden");
}

#pragma mark - Override

- (void)drawRect:(CGRect)rect {
    [self drawViewsForRect:rect];
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    // Don't draw placeholder
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (text && text.length > 0) {
        [self animateViewsForTextEntry];
    } else {
        [self animateViewsForTextDisplay];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - 

- (void)textFieldDidBeginEditing {
    
    [self animateViewsForTextEntry];
}

- (void)textFieldDidEndEditing {
    
    [self animateViewsForTextDisplay];
}

#pragma mark - Interface Builder

- (void)prepareForInterfaceBuilder {
    [self drawViewsForRect:self.frame];
}

@end
