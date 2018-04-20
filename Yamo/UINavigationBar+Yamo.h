//
//  UINavigationBar+Yamo.h
//  Yamo
//
//  Created by Hungju Lu on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Yamo)

- (void)setNavigationBarStyleTranslucent;
- (void)setNavigationBarStyleOpaque;
- (void)setNavigationBarShadowWithColor:(UIColor *)color height:(CGFloat)height;
- (void)removeNavigationBarShadow;

@end
