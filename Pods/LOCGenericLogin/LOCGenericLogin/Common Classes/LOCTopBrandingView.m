//
//  LOCTopBrandingView.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCTopBrandingView.h"

@interface LOCTopBrandingView ()

@property (nonatomic, strong) UIImageView *brandLogoImageView;
@property (nonatomic, strong) NSLayoutConstraint *topImageConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomImageConstraint;

@end

@implementation LOCTopBrandingView

#pragma mark - Setup

- (void)setup {
    
    [super setup];
    
    self.brandLogoImageView = [UIImageView new];
    self.brandLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.brandLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.brandLogoImageView];
    
    [self addConstraint:[self constraintForView:self
                                         toView:self.brandLogoImageView
                                      attribute:NSLayoutAttributeCenterX]];
    
    self.topImageConstraint = [self constraintForView:self.brandLogoImageView
                                               toView:self
                                            attribute:NSLayoutAttributeTop
                                              padding:0];
    [self addConstraint:self.topImageConstraint];
    
    self.bottomImageConstraint = [self constraintForView:self
                                                  toView:self.brandLogoImageView
                                               attribute:NSLayoutAttributeBottom padding:0];
    [self addConstraint:self.bottomImageConstraint];
    
    // Default padding
    [self updateImageVerticalPadding:60];
}

#pragma mark - Public

- (void)setBrandLogoImage:(UIImage *)brandLogoImage {
    _brandLogoImage = brandLogoImage;
    
    self.brandLogoImageView.image = _brandLogoImage;
}


- (void)updateImageVerticalPadding:(CGFloat)padding {
    
    self.topImageConstraint.constant = padding;
    self.bottomImageConstraint.constant = padding;
}

@end
