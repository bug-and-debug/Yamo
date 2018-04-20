//
//  LOCSocialButton.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCSocialButton.h"

@interface LOCSocialButton ()

@end

@implementation LOCSocialButton

+ (LOCSocialButton *)facebookButtonWithAction:(SocialActionBlock)action {
    
    LOCSocialButton *button = [LOCSocialButton buttonWithType:UIButtonTypeSystem];
    [button setupWithTitle:NSLocalizedString(@"Log In with Facebook", nil)
                    buttonColor:[UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1.00]
                     titleColor:[UIColor whiteColor]
                    action:action];
    button.socialMediaType = AllowedSocialMediaTypeFacebook;
    return button;
}

+ (LOCSocialButton *)twitterButtonWithAction:(SocialActionBlock)action {
    
    LOCSocialButton *button = [LOCSocialButton buttonWithType:UIButtonTypeSystem];
    [button setupWithTitle:NSLocalizedString(@"Connect with Twitter", nil)
               buttonColor:[UIColor colorWithRed:0.314 green:0.671 blue:0.945 alpha:1.00]
                titleColor:[UIColor whiteColor]
                    action:action];
    button.socialMediaType = AllowedSocialMediaTypeTwitter;
    return button;
}

+ (LOCSocialButton *)googlePlusButtonWithAction:(SocialActionBlock)action {
    
    LOCSocialButton *button = [LOCSocialButton buttonWithType:UIButtonTypeSystem];
    [button setupWithTitle:NSLocalizedString(@"Connect with Google+", nil)
               buttonColor:[UIColor colorWithRed:0.863 green:0.306 blue:0.255 alpha:1.00]
                titleColor:[UIColor whiteColor]
                    action:action];
    button.socialMediaType = AllowedSocialMediaTypeGooglePlus;
    return button;
}


- (void)setupWithTitle:(NSString *)title
             buttonColor:(UIColor *)color
              titleColor:(UIColor *)titleColor
                  action:(SocialActionBlock)action {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundColor:color];
    self.action = action;
    
    [self addTarget:self action:@selector(actionTextButtonWasTapped) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)actionTextButtonWasTapped {
    
    if (self.action) {
        self.action();
    }
}

@end
