//
//  UIView+LOCLayout.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCLayout.h"

@implementation UIView (LOCLayout)

#pragma mark - layout
- (void)removeSubviews {
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (double)width {
    CGRect frame = [self frame];
    return frame.size.width;
}

- (void)setWidth:(double)value {
    CGRect frame = [self frame];
    frame.size.width = round(value);
    [self setFrame:frame];
}

- (double)height {
    CGRect frame = [self frame];
    return frame.size.height;
}

- (void)setHeight:(double)value {
    CGRect frame = [self frame];
    frame.size.height = round(value);
    [self setFrame:frame];
}

- (void)setSize:(CGSize)size {
    CGRect frame = [self frame];
    frame.size.width = round(size.width);
    frame.size.height = round(size.height);
    [self setFrame:frame];
}

- (CGSize)size {
    CGRect frame = [self frame];
    return frame.size;
}

- (CGPoint)origin {
    CGRect frame = [self frame];
    return frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = [self frame];
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    [self setFrame:frame];
}

- (CGFloat)left {
    return self.origin.x;
}

- (CGFloat)right {
    return self.origin.x + self.size.width;
}

- (CGFloat)top {
    return self.origin.y;
}

- (CGFloat)bottom {
    return self.origin.y + self.size.height;
}

- (void)setLeft:(CGFloat)value {
    CGRect frame = [self frame];
    frame.origin.x = value;
    [self setFrame:frame];
}

- (void)setRight:(CGFloat)value {
    CGRect frame = [self frame];
    frame.origin.x = value - frame.size.width;
    [self setFrame:frame];
}

- (void)setTop:(CGFloat)value {
    CGRect frame = [self frame];
    frame.origin.y = value;
    [self setFrame:frame];
}

- (void)setBottom:(CGFloat)value {
    CGRect frame = [self frame];
    frame.origin.y = value - frame.size.height;
    [self setFrame:frame];
}

- (void)centerInSuperView {
    double xPos = round(([self.superview width] - [self width]) / 2.0);
    double yPos = round(([self.superview height] - [self height]) / 2.0);
    [self setOrigin:CGPointMake(xPos, yPos)];
}

- (void)centerHorizontallyInSuperView {
    double xPos = round(([self.superview width] - [self width]) / 2.0);
    self.left = xPos;
}

- (void)centerVerticallyInSuperView {
    double yPos = round(([self.superview height] - [self height]) / 2.0);
    self.top  = yPos;
}

- (void)bringToFront {
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack {
    [self.superview sendSubviewToBack:self];
}

- (void)verticalAlignToView:(UIView *)aView {
    self.top = roundf(aView.top + ((aView.size.height - self.size.height) * 0.5));
}

- (void)horizontalAlignToView:(UIView *)aView {
    self.left = roundf(aView.left + ((aView.size.width - self.size.width) * 0.5));
}

- (void)setOriginX:(float)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)setOriginY:(float)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setOriginX:(float)originX
              andY:(float)originY
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setWidth:(float)width
       andHeight:(float)height
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCenterX:(float)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(float)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setCenterX:(float)centerX
              andY:(float)centerY
{
    CGPoint center = self.center;
    center.x = centerX;
    center.y = centerY;
    self.center = center;
}

- (void)moveX:(float)xShift
{
    CGPoint center = self.center;
    center.x += xShift;
    self.center = center;
}

- (void)moveY:(float)yShift
{
    CGPoint center = self.center;
    center.y += yShift;
    self.center = center;
}

- (void)moveX:(float)xShift
         andY:(float)yShift
{
    CGPoint center = self.center;
    center.x += xShift;
    center.y += yShift;
    self.center = center;
}

@end
