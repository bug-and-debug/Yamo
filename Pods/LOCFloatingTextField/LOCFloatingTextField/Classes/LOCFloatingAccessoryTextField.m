//
//  LOCFloatingAccessoryTextField.m
//  LOCAccessoryTextField
//
//  Created by Peter Su on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFloatingAccessoryTextField.h"

@interface LOCFloatingAccessoryTextField ()

@property (nonatomic) CGFloat activeBorderThickness;

@property (nonatomic) CGFloat inactiveBorderThickness;

@property (nonatomic) CGPoint placeholderInsets;

@property (nonatomic) CGPoint textFieldInsets;

@property (nonatomic, strong) CALayer *activeBorderLayer;

@property (nonatomic, strong) CALayer *inactiveBorderLayer;

@property (nonatomic) CGPoint activePlaceholderPoint;

@property (nonatomic, strong) UIView *leftImageContainerView;

@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation LOCFloatingAccessoryTextField

- (void)initialise {
    
    [super initialise];
    
    self.activeBorderThickness = 1;
    self.inactiveBorderThickness = 1;
    self.placeholderInsets = CGPointMake(0, 0);
    self.textFieldInsets = CGPointMake(0, 8);
    
    self.activeBorderLayer = [CALayer new];
    self.inactiveBorderLayer = [CALayer new];
    
    self.activePlaceholderPoint = CGPointZero;
    
    [self setDefaultValuesForInspectables];
}

#pragma mark - IBInspectable Properties

- (void)setDefaultValuesForInspectables {
    
    self.placeholderColor = [UIColor blackColor];
    self.placeholderFontScale = 0.65;
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    
    [self updateBorder];
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self updatePlaceholder];
}

- (void)setErrorMessageColor:(UIColor *)errorMessageColor {
    _errorMessageColor = errorMessageColor;
    
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self updatePlaceholder];
}

- (void)setActiveImage:(UIImage *)activeImage {
    _activeImage = activeImage;
    
    [self updateLeftView];
}

- (void)setInactiveImage:(UIImage *)inactiveImage {
    _inactiveImage = inactiveImage;
    
    [self updateLeftView];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    [self updateBorder];
    [self updatePlaceholder];
    [self updateLeftView];
}

#pragma mark - Override

- (void)drawViewsForRect:(CGRect)rect {
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    self.placeholderLabel.frame = CGRectInset(frame, _placeholderInsets.x, _placeholderInsets.y);
    
    [self updateBorder];
    [self updatePlaceholder];
    [self updateLeftView];
    
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
    
    [self addSubview:self.placeholderLabel];
}

- (void)animateViewsForTextEntry {
    
    [self updateTextForPlaceholder];
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    [self updateLeftView];
    
    if (self.text && self.text.length == 0) {
        
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.placeholderLabel.frame = CGRectMake(10, self.placeholderLabel.frame.origin.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
        } completion:^(BOOL finished) {
            
            if (self.animationCompletionBlock) {
                self.animationCompletionBlock(LOCCustomTextFieldAnimationTypeEntry);
            }
        }];
    }
    
    [self layoutPlaceholderInTextRect];
    self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
    
    self.activeBorderLayer.frame = [self rectForBorder:self.activeBorderThickness];
    self.activeBorderLayer.hidden = NO;
    
}

- (void)animateViewsForTextDisplay {
    
    [self updateTextForPlaceholder];
    if (self.text && self.text.length == 0) {
        
        self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
        [self updateLeftView];
        
        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self layoutPlaceholderInTextRect];
        } completion:^(BOOL finished) {
            
            if (self.animationCompletionBlock) {
                self.animationCompletionBlock(LOCCustomTextFieldAnimationTypeDisplay);
            }
        }];
        
        self.activeBorderLayer.frame = [self rectForBorder:self.activeBorderThickness];
        self.activeBorderLayer.hidden = YES;
        
    }
}

#pragma mark - Private

- (void)updateBorder {
    self.inactiveBorderLayer.frame = [self rectForBorder:self.inactiveBorderThickness];
    self.inactiveBorderLayer.backgroundColor = _borderInactiveColor.CGColor;
    
    self.activeBorderLayer.frame = [self rectForBorder:self.activeBorderThickness];
    self.activeBorderLayer.hidden = YES;
    self.activeBorderLayer.backgroundColor = _borderActiveColor.CGColor;
}

- (void)updateTextForPlaceholder {
    
    self.placeholderLabel.text = self.errorMessage;
    self.placeholderLabel.textColor = self.errorMessageColor;
    if (self.isFirstResponder) {
        self.placeholderLabel.alpha = 0.0f;
    } else {
        self.placeholderLabel.alpha = 1.0f;
        if (self.text.length > 0) {
            
        } else {
            self.placeholderLabel.text = self.placeholder;
            self.placeholderLabel.textColor = self.placeholderColor;
        }
    }
}

- (void)updatePlaceholder {
    
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if (self.isFirstResponder || self.text.length > 0) {
        [self animateViewsForTextEntry];
    }
}

- (void)updateLeftView {
    
    if (self.activeImage && self.inactiveImage) {
        
        if (!self.leftImageContainerView) {
            
            self.leftImageContainerView = [UIView new];
            self.leftImageContainerView.translatesAutoresizingMaskIntoConstraints = NO;
            
            self.leftImageView = [[UIImageView alloc] initWithImage:self.inactiveImage highlightedImage:self.activeImage];
            self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat defaultPadding = 8.0f;
            
            [self.leftImageContainerView addSubview:self.leftImageView];
            
            [self.leftImageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.leftImageContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
            [self.leftImageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.leftImageContainerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
            
            [self.leftImageContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.leftImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:defaultPadding]];
            
            self.leftView = self.leftImageContainerView;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        
        if ((self.text && self.text.length > 0) || self.isFirstResponder) {
            
            self.leftImageView.highlighted = YES;
        } else {
            
            self.leftImageView.highlighted = NO;
        }
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    
    CGFloat fontSize = (self.text.length > 0 || self.isFirstResponder) ? font.pointSize * self.placeholderFontScale : font.pointSize;
    UIFont *smallerFont = [UIFont fontWithName:font.fontName size:fontSize];
    return smallerFont;
}

- (CGRect)rectForBorder:(CGFloat)thickness {
    CGRect newRect = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
    
    return newRect;
}

- (void)layoutPlaceholderInTextRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    
    switch (self.textAlignment) {
        case NSTextAlignmentCenter: {
            originX += CGRectGetWidth(textRect) / 2 - CGRectGetWidth(self.placeholderLabel.bounds) / 2;
            break;
        }
        case NSTextAlignmentRight: {
            originX += CGRectGetWidth(textRect) - CGRectGetWidth(self.placeholderLabel.bounds);
            break;
        }
        default:
            break;
    }
    
    self.placeholderLabel.frame = CGRectMake(originX, textRect.origin.y, CGRectGetWidth(self.bounds) - originX, CGRectGetHeight(textRect));
    
    self.activePlaceholderPoint = CGPointMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y - self.placeholderLabel.frame.size.height - self.placeholderInsets.y);
}

#pragma mark -

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGFloat padding = 0;
    if (self.leftImageContainerView) {
        padding = CGRectGetWidth(self.leftImageContainerView.bounds);
    }
    return CGRectInset(bounds, _textFieldInsets.x + padding, _textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGFloat padding = 0;
    if (self.leftImageContainerView) {
        padding = CGRectGetWidth(self.leftImageContainerView.bounds);
    }
    return CGRectInset(bounds, _textFieldInsets.x + padding, _textFieldInsets.y);
}

@end
