//
//  UIColor+Tools.h
//  Annotation
//
//  Created by Simon Lee on 13/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

@import UIKit;

@interface UIColor (Tools)

+ (UIColor *)colorWithHexString:(NSString *)hex;
- (UIColor *)adjustColour:(CGFloat)amount;

@end
