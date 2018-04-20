//
//  LOCSocialButton.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SocialActionBlock)();

typedef NS_ENUM(NSUInteger, AllowedSocialMediaType) {
    AllowedSocialMediaTypeFacebook,
    AllowedSocialMediaTypeTwitter,
    AllowedSocialMediaTypeGooglePlus
};

@interface LOCSocialButton : UIButton

@property (nonatomic) AllowedSocialMediaType socialMediaType;
@property (nonatomic, copy) SocialActionBlock action;

+ (LOCSocialButton *)facebookButtonWithAction:(SocialActionBlock)action;
+ (LOCSocialButton *)twitterButtonWithAction:(SocialActionBlock)action;
+ (LOCSocialButton *)googlePlusButtonWithAction:(SocialActionBlock)action;

@end
