//
//  YourPlaceActionSheet.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceActionSheet.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"
@import UIImage_LOCExtensions;

@interface YourPlaceActionSheet () <YourPlaceActionSheetControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomShadow;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) YourPlaceActionSheetController *dataController;

@end

@implementation YourPlaceActionSheet

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(YourPlaceActionSheet.class) owner:self options:nil] firstObject];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.view];
        
        NSDictionary *metrics = @{@"spacing" : @(0) };
        NSDictionary *views = @{ @"view" : self.view };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self setupController];
        return self;
    }
    
    return nil;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupAppearance];
}

#pragma mark - Setup

- (void)setupController {
    
    self.dataController = [[YourPlaceActionSheetController alloc] initWithTableView:self.optionsTableView];
    self.dataController.delegate = self;
}

- (void)setupAppearance {
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoTextDarkGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Edit your places", nil) attributes:attributes];
    
    self.titleLabel.attributedText = attributedString;
    
    self.bottomShadow.image = [self shadowImage];
    
    
    NSDictionary *cancelAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *cancelAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Cancel", nil) attributes:cancelAttributes];
    
    [self.cancelButton setAttributedTitle:cancelAttributedString forState:UIControlStateNormal];
    
    [self.cancelButton addTarget:self action:@selector(handleDidPressCancel) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Helpers

- (UIImage *)shadowImage {
    UIImage *shadowImage = [UIImage imageNamed:@"whiteshadow button 1 1 1 1 1"];
    CGFloat imageHeight = shadowImage.size.height * [UIScreen mainScreen].scale;
    CGFloat heightToCrop = 64.0 * [UIScreen mainScreen].scale;
    UIImage *croppedShadowImage = [shadowImage croppedImage:CGRectMake(10.0, heightToCrop, 1.0, imageHeight - heightToCrop)];
    croppedShadowImage = [croppedShadowImage resizedImage:CGSizeMake(1.0, croppedShadowImage.size.height / [UIScreen mainScreen].scale)];
    return croppedShadowImage;
}

#pragma mark - Actions

- (void)handleDidPressCancel {
    
    if ([self.delegate respondsToSelector:@selector(actionSheetDidPressCancel:)]) {
        [self.delegate actionSheetDidPressCancel:self];
    }
}

#pragma mark - YourPlaceActionSheetControllerDelegate

- (void)yourPlaceActionSheetController:(YourPlaceActionSheetController *)controller
               didSelectEditOptionType:(YourPlaceOptionType)type {
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:didPressEditOptionType:)]) {
        [self.delegate actionSheet:self didPressEditOptionType:type];
    }
}

@end
