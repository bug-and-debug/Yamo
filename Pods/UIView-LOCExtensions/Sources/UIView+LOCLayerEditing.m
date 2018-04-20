//
//  UIView+LOCLayerEditing.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCLayerEditing.h"

@implementation UIView (LOCLayerEditing)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - layer editing
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addShadowWithColor:(UIColor *)shadowColor
                    offset:(CGSize)offset
                    radius:(float)radius
                andOpacity:(float)opacity
{
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void)addBorderWithColor:(UIColor *)borderColor
                  andWidth:(float)radius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = radius;
}

- (void)addRoundEdgesWithRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)removeAllSubviews
{
    for (UIView *view in [self.subviews copy]) {
        [view removeFromSuperview];
    }
}

- (id)cloneView {
    if([self conformsToProtocol:@protocol(NSCoding)]) {
        [self prepareViews:self];
        
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self];
        UIView *view = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        view.layer.shadowOffset = self.layer.shadowOffset;
        view.layer.shadowColor = self.layer.shadowColor;
        view.layer.shadowRadius = self.layer.shadowRadius;
        view.layer.shadowOpacity = self.layer.shadowOpacity;
        [self.superview addSubview:view];
        
        return view;
    }
    
    NSAssert(FALSE, @"%@ does not conform to NSCoding and can't be clones via archive.", NSStringFromClass([self class]));
    return nil;
}

- (void)prepareViews:(UIView *)aView {
    if([aView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)aView;
        if(label.text == nil) {
            label.text = @"";
        }
    }
    
    for(UIView *view in aView.subviews) {
        [self prepareViews:view];
    }
}

- (BOOL)isOpaqueAtPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return pixel[3] != 0.0;
}

@end
