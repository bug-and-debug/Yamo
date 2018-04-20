//
//  UIImage+LOCAlpha.h
//  UIImage-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LOCAlpha)

#pragma mark - alpha
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

@end
