//
//  LOCCameraNoPermissionOverlay.m
//  LOCCameraView
//
//  Created by Peter Su on 10/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCameraNoPermissionOverlay.h"

@interface LOCCameraNoPermissionOverlay ()

@end

@implementation LOCCameraNoPermissionOverlay

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.accessDeniedLabel = [UILabel new];
    self.accessDeniedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.accessDeniedLabel.text = NSLocalizedString(@"You do not have permissions for the camera", @"LOCCameraView: No persmission for camera access");
    self.accessDeniedLabel.numberOfLines = 0;
    self.accessDeniedLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.accessDeniedLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.accessDeniedLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.accessDeniedLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.accessDeniedLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.accessDeniedLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}


@end
