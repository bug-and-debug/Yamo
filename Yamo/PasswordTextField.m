//
//  PasswordTextField.m
//  Yamo
//
//  Created by Mo Moosa on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PasswordTextField.h"

@interface PasswordTextField ()
@property (nonatomic, readwrite) UIButton *toggleButton;
@end

@implementation PasswordTextField
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialise];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialise];
}

- (void)initialise {
    [super initialise];
    
    self.hiddenImage = [UIImage imageNamed:@"Iconlighteye"];
    self.revealImage = [UIImage imageNamed:@"Iconlighteyeactive"];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10.0f, 10.0f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10.0f, 10.0f);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    UIImage *image = [UIImage imageNamed:@"Iconlighteye"];
    CGRect newRect = CGRectMake(bounds.size.width - image.size.width, bounds.size.height / 2, image.size.width, image.size.height);
    return newRect;
}

@end
