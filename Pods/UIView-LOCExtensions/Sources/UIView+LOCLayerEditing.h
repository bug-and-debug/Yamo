//
//  UIView+LOCLayerEditing.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCLayerEditing)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - layerEditing
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addShadowWithColor:(UIColor *)shadowColor
                    offset:(CGSize)offset
                    radius:(float)radius
                andOpacity:(float)opacity;
- (void)addBorderWithColor:(UIColor *)borderColor
                  andWidth:(float)radius;
- (void)addRoundEdgesWithRadius:(float)radius;
- (void)removeAllSubviews;
- (id)cloneView;
- (BOOL)isOpaqueAtPoint:(CGPoint)point;

@end
