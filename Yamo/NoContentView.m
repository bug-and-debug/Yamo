//
//  NoContentView.m
//  Yamo
//
//  Created by Peter Su on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NoContentView.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"
@import UIView_LOCExtensions;

static CGFloat NoContentViewDefaultContentLabelYOffset = 0.0f;

@interface NoContentView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelYConstraint;

@end

@implementation NoContentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self addXibLayoutToSelf];
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addXibLayoutToSelf];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithWithNoContentType:(NoContentViewType)type {

    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (void)addXibLayoutToSelf {
    
    self.view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(NoContentView.class) owner:self options:nil] firstObject];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.view];
    [self pinView:self.view];
    
    [self updateAppearance];
}

#pragma mark - Setters

- (void)setType:(NoContentViewType)type {
    _type = type;
    
    [self updateTitleForContentViewType];
}

#pragma mark - Appearance

- (void)updateAppearance {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)updateTitleForContentViewType {
    
    CGFloat defaultCenterY = NoContentViewDefaultContentLabelYOffset;
    switch (self.type) {
        case NoContentViewTypeNotifications: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No Notifications", nil)];
            break;
        }
        case NoContentViewTypeOtherProfileNoContentForVenues: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No saved places", nil)];
            break;
        }
        case NoContentViewTypeOtherProfileNoContentForRoutes: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No saved routes", nil)];
            break;
        }
        case NoContentViewTypeOtherProfileNoContentForFriendsFollowing: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"Following no one", nil)];
            break;
        }
        case NoContentViewTypeOtherProfileNoContentForFriendsFollowers: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No followers", nil)];
            break;
        }
        case NoContentViewTypeOtherProfileNoContentForGetToKnowMe: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No Data", nil)];
            break;
        }
        case NoContentViewTypeOtherProfilePrivate: {
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"This account is private", nil)];
            break;
        }
        default:
            [self setContentLabelWithDefaultAppearanceForString:NSLocalizedString(@"No Data", nil)];
            break;
    }
    
    self.contentLabelYConstraint.constant = defaultCenterY;
}

- (void)setContentLabelWithDefaultAppearanceForString:(NSString *)string {
    
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                       attributes:[self defaultAttributesForContentLabel]];
}

- (void)setAttributedText:(NSAttributedString *)text {
    
    self.contentLabel.attributedText = text;
}

- (NSDictionary *)defaultAttributesForContentLabel {
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0],
              NSForegroundColorAttributeName : [UIColor yamoTextGray] };;
}

@end
