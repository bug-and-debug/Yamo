//
//  UIView+LOCLayout.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCLayout)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

#pragma mark - layout
- (double)width;
- (void)setWidth:(double)width;

/*-----------------------------------------------------------------------------------------------------*/

- (double)height;
- (void)setHeight:(double)height;

/*-----------------------------------------------------------------------------------------------------*/

- (CGSize)size;
- (void)setSize:(CGSize)size;

/*-----------------------------------------------------------------------------------------------------*/

- (CGPoint) origin;
- (void)setOrigin:(CGPoint)origin;

/*-----------------------------------------------------------------------------------------------------*/

- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;

/*-----------------------------------------------------------------------------------------------------*/

- (void)setLeft:(CGFloat)value;
- (void)setRight:(CGFloat)value;
- (void)setTop:(CGFloat)value;
- (void)setBottom:(CGFloat)value;

/*-----------------------------------------------------------------------------------------------------*/

- (void)removeSubviews;
- (void)centerInSuperView;
- (void)centerHorizontallyInSuperView;
- (void)centerVerticallyInSuperView;

/*-----------------------------------------------------------------------------------------------------*/

- (void)bringToFront;
- (void)sendToBack;

/*-----------------------------------------------------------------------------------------------------*/

- (void)verticalAlignToView:(UIView *)aView;
- (void)horizontalAlignToView:(UIView *)aView;

/*-----------------------------------------------------------------------------------------------------*/

- (void)setOriginX:(float)originX;
- (void)setOriginY:(float)originY;
- (void)setOriginX:(float)originX
              andY:(float)originY;
- (void)setWidth:(float)width
       andHeight:(float)height;

/*-----------------------------------------------------------------------------------------------------*/

- (void)setCenterX:(float)centerX;
- (void)setCenterY:(float)centerY;
- (void)setCenterX:(float)centerX
              andY:(float)centerY;

/*-----------------------------------------------------------------------------------------------------*/

- (void)moveX:(float)xShift;
- (void)moveY:(float)yShift;
- (void)moveX:(float)xShift
         andY:(float)yShift;

@end
