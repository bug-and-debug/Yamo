//
//  UIFont+Yamo.h
//  Yamo
//
//  Created by Mo Moosa on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, FontStyle) {
    FontStyleGraphikMedium,
    FontStyleGraphikRegular,
    FontStyleTrianonCaptionExtraLight
};

@interface UIFont (Yamo)

+ (UIFont * _Nonnull)preferredFontForStyle:(FontStyle)style size:(CGFloat)size;

@end
