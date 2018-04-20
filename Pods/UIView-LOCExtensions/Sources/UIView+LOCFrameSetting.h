//
//  UIView+FrameSetting.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCFrameSetting)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - frame setting
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveXAnimated:(float)xShift;
- (void)moveYAnimated:(float)yShift;
- (void)moveX:(float)xShift
 andYAnimated:(float)yShift;
- (void)setWidthAnimated:(float)width;
- (void)setHeightAnimated:(float)height;
- (void)setWidth:(float)width
andHeightAnimated:(float)height;

@end
