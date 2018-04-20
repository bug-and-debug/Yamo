//
//  LOTextField.m
//  ZiferblatAdmin
//
//  Created by Simon Lee on 09/06/2015.
//  Copyright (c) 2015 Locassa. All rights reserved.
//

#import "LOCFloatingTextField.h"

#define NotificationCenter  [NSNotificationCenter defaultCenter]
#define Notification_Observe_Object(notification, method, anObject) [NotificationCenter addObserver:self selector:@selector(method) name:notification object:anObject];
#define Notification_RemoveObserver                                 [NotificationCenter removeObserver:self];

static const CGFloat placeholderHeightPadding = 16.0;
static const CGFloat defaultPadding = 15.0;
static const CGFloat maxHeight = 60.0f;

@interface LOCFloatingTextField() <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;

@property (strong, nonatomic) UIColor *defaultPlaceholderAnimatedTextColor;

@property (strong, nonatomic) UIFont *defaultPlaceholderAnimatedTextFont;

@property (strong, nonatomic) NSString *inputText;

@property (strong, nonatomic) NSLayoutConstraint *placeholderCenterYConstraint;

@property (strong, nonatomic) NSLayoutConstraint *placeholderLeftPaddingConstraint;

@property (strong, nonatomic) NSLayoutConstraint *placeholderRightPaddingConstraint;

@property (nonatomic) BOOL firstLayout;

@end

@implementation LOCFloatingTextField

- (instancetype)init {
    
    if (self = [super init]) {
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

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialise];
    }
    
    return self;
}

- (void)dealloc {
    Notification_RemoveObserver;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (!self.firstLayout && self.text.length > 0 && self.placeholderLabelText.length > 0) {
        self.firstLayout = YES;
        [self textDidChange];
    }
}

#pragma mark - Set up

- (void)initialise {
    
    _leftPadding = defaultPadding;
    _rightPadding = defaultPadding;
    
    _placeholderTextColor = [UIColor grayColor];
    _defaultPlaceholderAnimatedTextColor = _placeholderTextColor;
    
    _placeholderTextFont = [UIFont fontWithName:@"Avenir" size:13.0f];
    _defaultPlaceholderAnimatedTextFont = _placeholderTextFont;
    
    _placeholderAnimatedTextColor = [UIColor grayColor];
    _placeholderAnimatedTextFont = [UIFont fontWithName:@"Avenir" size:13.0f];
    
    [self setup];
}

#pragma mark - Setters

- (void)setPlaceholderLabelText:(NSString *)placeholderLabelText {
    _placeholderLabelText = placeholderLabelText;
    
    self.placeholderLabel.text = placeholderLabelText;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    
    _placeholderTextColor = placeholderTextColor;
    self.placeholderLabel.textColor = placeholderTextColor;
    self.defaultPlaceholderAnimatedTextColor = placeholderTextColor;
}

- (void)setPlaceholderTextFont:(UIFont *)placeholderTextFont {
    
    _placeholderTextFont = placeholderTextFont;
    self.placeholderLabel.font = placeholderTextFont;
    self.defaultPlaceholderAnimatedTextFont = placeholderTextFont;
}

- (void)setPlaceholderAnimatedTextColor:(UIColor *)placeholderAnimatedTextColor {
    
    _placeholderAnimatedTextColor = placeholderAnimatedTextColor;
}

- (void)setPlaceholderAnimatedTextFont:(UIFont *)placeholderAnimatedTextFont {
    
    _placeholderAnimatedTextFont = placeholderAnimatedTextFont;
}

- (void)setLeftPadding:(CGFloat)leftPadding {
    
    _leftPadding = leftPadding;
    self.placeholderLeftPaddingConstraint.constant = leftPadding;
}

- (void)setRightPadding:(CGFloat)rightPadding {
    
    _rightPadding = rightPadding;
    self.placeholderRightPaddingConstraint.constant = rightPadding;
}


#pragma mark - Setup

- (void)setup {
    
    self.inputText = @"";
    
    if (!self.placeholder) {
        self.placeholderLabel = [UILabel new];
        self.placeholderLabel.font = self.placeholderTextFont;
        self.placeholderLabel.textColor = self.placeholderTextColor;
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.placeholderLabel];
        
        [self setEnablesReturnKeyAutomatically:YES];
        
        _animationType = LOComponentAnimateUpwards;
        
        self.placeholderCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
        [self addConstraint:self.placeholderCenterYConstraint];
        
        self.placeholderLeftPaddingConstraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:self.leftPadding];
        [self addConstraint:self.placeholderLeftPaddingConstraint];
        
        self.placeholderRightPaddingConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.placeholderLabel
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:self.rightPadding];
        [self addConstraint:self.placeholderRightPaddingConstraint];
        
        
        Notification_Observe_Object(UITextFieldTextDidChangeNotification, textDidChange, self);
    }
}

- (void)setText:(NSString *)someText {
    
    [super setText:someText];
    [self textDidChange:NO];
}

#pragma mark - Layout Methods

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    if ([self.text length] == 0 || self.placeholderLabelText.length == 0) {
        return CGRectMake(bounds.origin.x + self.placeholderLabel.frame.origin.x, bounds.origin.y +10,
                          self.frame.size.width - self.leftPadding -  self.rightPadding  , bounds.size.height - placeholderHeightPadding);
    }
    else {
        
        CGRect placeholderRect = self.placeholderLabel.bounds;
        float heightToAdd = MIN(CGRectGetHeight(placeholderRect), maxHeight);
        
        if (_animationType == LOComponentAnimateUpwards) {
            return CGRectMake(bounds.origin.x + self.leftPadding,
                              bounds.origin.y + heightToAdd,
                              self.frame.size.width - self.leftPadding - self.rightPadding,
                              bounds.size.height - placeholderHeightPadding);
        }
        else {
            return CGRectMake(bounds.origin.x + self.placeholderLabel.frame.origin.x,
                              bounds.origin.y - heightToAdd/3,
                              self.frame.size.width - self.leftPadding - self.rightPadding,
                              bounds.size.height - placeholderHeightPadding);
        }
    }
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)textDidChange {
    [self textDidChange:YES];
}

- (void)textDidChange:(BOOL)animated {
    [self animatePlaceholder:animated animationDirection:_animationType];
}

- (void)animatePlaceholder:(BOOL)animated animationDirection:(LOComponentAnimate)animationDirection {
    
    BOOL hasText = self.text.length > 0;
    
    if (hasText) {
        
        CGSize textSize2 = [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(self.placeholderLabel.frame.size.width, maxHeight)
                                                                    options:NSStringDrawingUsesDeviceMetrics
                                                                 attributes:@{NSFontAttributeName:self.placeholderLabel.font}
                                                                    context:nil].size;
        float heightToAdd2 = MIN(textSize2.height, maxHeight);
        
        self.placeholderCenterYConstraint.constant = animationDirection == LOComponentAnimateUpwards? - heightToAdd2 : heightToAdd2;
        self.placeholderLabel.font = self.placeholderAnimatedTextFont;
        self.placeholderLabel.textColor = self.placeholderAnimatedTextColor;
        
        
    } else {
        
        self.placeholderCenterYConstraint.constant = 0.0f;
        self.placeholderLabel.font = self.defaultPlaceholderAnimatedTextFont;
        self.placeholderLabel.textColor = self.defaultPlaceholderAnimatedTextColor;
    }
    
    __block BOOL togglePlaceholderLabel = (self.text.length >= 1 && self.inputText.length == 0 ) || (self.text.length == 0 && self.inputText.length >= 1);
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        if (togglePlaceholderLabel) {
            self.placeholderLabel.alpha = 0;
            self.placeholderLabel.alpha = 1;
        }
        
        self.inputText = self.text;
        
        [self layoutIfNeeded];
    }];
}

@end
