//
//  LOCSocialMediaLoginView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSocialMediaLoginView.h"

@interface LOCSocialMediaLoginView ()

@property (nonatomic, strong, readwrite) NSMutableArray *currentButtonsArray;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *viewHeightConstraint;

@end

@implementation LOCSocialMediaLoginView

#pragma mark - Setup

- (void)setup {
    [super setup];
    
    self.currentButtonsArray = [NSMutableArray new];
    
    self.viewHeightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:0];
    [self addConstraint:self.viewHeightConstraint];
    
    self.allowedSocialMediaButtonTypes = @[ @(AllowedSocialMediaTypeFacebook),
                                            @(AllowedSocialMediaTypeGooglePlus),
                                            @(AllowedSocialMediaTypeTwitter) ];
}

#pragma mark - Setters

- (void)setAllowedSocialMediaButtonTypes:(NSArray<NSNumber *> *)allowedSocialMediaButtonTypes {
    
    // Remove duplicates
    NSMutableArray *cleanArray = [NSMutableArray new];
    for (NSNumber *allowedType in allowedSocialMediaButtonTypes) {
        if (![cleanArray containsObject:allowedType]) {
            [cleanArray addObject:allowedType];
        }
    }
    _allowedSocialMediaButtonTypes = cleanArray;
    
    [self updateAllowedMediaButtons:[self buttonForTypes:_allowedSocialMediaButtonTypes]];
}

#pragma mark - Helpers

- (NSArray<LOCSocialButton *> *)buttonForTypes:(NSArray<NSNumber *> *)allowedSocialMediaTypes {
    
    NSMutableArray *socialButtons = [NSMutableArray new];
    
    for (NSNumber *buttonType in allowedSocialMediaTypes) {
        
        LOCSocialButton *button = [self buttonForType:[buttonType integerValue]];
        [socialButtons addObject:button];
    }
    
    return socialButtons;
}

- (void)updateAllowedMediaButtons:(NSArray<LOCSocialButton *> *)allowedMediaButtons {
    
    for (LOCSocialButton *socialButton in self.currentButtonsArray) {
        [socialButton removeFromSuperview];
    }
    self.currentButtonsArray = [NSMutableArray new];
    
    for (NSInteger mediaButtonIndex = 0; mediaButtonIndex < allowedMediaButtons.count; mediaButtonIndex++) {
        
        LOCSocialButton *socialButton = allowedMediaButtons[mediaButtonIndex];
        if (socialButton) {
            
            [self addSubview:socialButton];
            [self.currentButtonsArray addObject:socialButton];
            
            if (self.currentButtonsArray.count == 1) {
                // First button
                
                [self addConstraint:[self constraintForView:socialButton toView:self
                                                  attribute:NSLayoutAttributeLeading]];
                [self addConstraint:[self constraintForView:self toView:socialButton
                                                  attribute:NSLayoutAttributeTrailing]];
                [self addConstraint:[self constraintForView:socialButton
                                                     toView:self attribute:NSLayoutAttributeTop]];
                [self pinView:socialButton forHeight:44];
                
            } else if (self.currentButtonsArray.count == allowedMediaButtons.count) {
                
                // Last button
                LOCSocialButton *prevButton = self.currentButtonsArray[mediaButtonIndex - 1];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:socialButton
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual toItem:prevButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
                [self addConstraint:[self constraintForView:socialButton
                                                     toView:self
                                                  attribute:NSLayoutAttributeLeading]];
                [self addConstraint:[self constraintForView:self
                                                     toView:socialButton
                                                  attribute:NSLayoutAttributeTrailing]];
                [self pinView:socialButton forHeight:44];
                
            } else {
                // Intermediate button
                
                LOCSocialButton *prevButton = self.currentButtonsArray[mediaButtonIndex - 1];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:socialButton
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:prevButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
                [self addConstraint:[self constraintForView:socialButton
                                                     toView:self
                                                  attribute:NSLayoutAttributeLeading]];
                [self addConstraint:[self constraintForView:self
                                                     toView:socialButton
                                                  attribute:NSLayoutAttributeTrailing]];
                [self pinView:socialButton forHeight:44];
            }
        } else {
            NSAssert(NO, @"Not a valid social media button type");
        }
    }
    
    self.viewHeightConstraint.constant = 44 * self.currentButtonsArray.count;
    
}

#pragma mark - Helpers

- (LOCSocialButton *)buttonForType:(AllowedSocialMediaType)socialMediaType {
    
    switch (socialMediaType) {
        case AllowedSocialMediaTypeFacebook: {
            return [LOCSocialButton facebookButtonWithAction:nil];
        }
        case AllowedSocialMediaTypeGooglePlus: {
            return [LOCSocialButton googlePlusButtonWithAction:nil];
        }
        case AllowedSocialMediaTypeTwitter: {
            return [LOCSocialButton twitterButtonWithAction:nil];
        }
        default:
            return nil;
    }
}

- (void)action:(SocialActionBlock)action forSocialButtonType:(AllowedSocialMediaType)socialButtonType {
    
    for (LOCSocialButton *socialButton in self.currentButtonsArray) {
        
        if (socialButton.socialMediaType == socialButtonType) {
            socialButton.action = action;
        }
    }
}

@end
