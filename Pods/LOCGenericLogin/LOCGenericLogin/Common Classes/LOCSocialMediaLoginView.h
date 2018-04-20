//
//  LOCSocialMediaLoginView.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCBaseView.h"
#import "LOCSocialButton.h"

@interface LOCSocialMediaLoginView : LOCBaseView

@property (nonatomic, strong) NSArray<NSNumber *> *allowedSocialMediaButtonTypes;
@property (nonatomic, strong, readonly) NSMutableArray<LOCSocialButton *> *currentButtonsArray;
@property (nonatomic, strong, readonly) NSLayoutConstraint *viewHeightConstraint;

- (void)action:(SocialActionBlock)action forSocialButtonType:(AllowedSocialMediaType)socialButtonType;

#pragma mark - Layout

/*
 *  Override this
 */
- (void)updateAllowedMediaButtons:(NSArray<LOCSocialButton *> *)allowedMediaButtons;

@end
