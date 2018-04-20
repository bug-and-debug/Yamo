//
//  UIView+Autolayout.h
//
//  Created by Jose Fernandez on 06/08/2015.
//  Copyright (c) 2015 Locassa Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, LOCPinnedEdge) {
    LOCPinnedEdgeAll      = 0,
    LOCPinnedEdgeLeading  = 1 << 1,
    LOCPinnedEdgeTrailing = 1 << 2,
    LOCPinnedEdgeTop      = 1 << 3,
    LOCPinnedEdgeBottom   = 1 << 4
};

@interface UIView (LOCAutolayout)

// pins view to all edges of the receiver
- (NSArray *)pinView:(UIView *)view;

// pins view to edges of the receiver view as defined in edges bitmask
- (NSArray *)pinView:(UIView *)view toEdges:(LOCPinnedEdge)edges;
- (NSArray *)pinView:(UIView *)view toEdges:(LOCPinnedEdge)edges margin:(CGFloat)margin;

// pin viewA to viewB
- (NSLayoutConstraint *)pinView:(UIView *)viewA withAttribute:(NSLayoutAttribute)attribute toView:(UIView *)viewB;
- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing;
- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority;
- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint *)pinSameWidth:(UIView *)viewA toView:(UIView *)viewB;
- (NSLayoutConstraint *)pinLessThenOrEqualWidth:(UIView *)viewA toView:(UIView *)viewB;
- (NSLayoutConstraint *)pinSameHeight:(UIView *)viewA toView:(UIView *)viewB;
- (NSLayoutConstraint *)pinSameWidth:(UIView *)viewA toView:(UIView *)viewB multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (NSLayoutConstraint *)pinSameHeight:(UIView *)viewA toView:(UIView *)viewB multiplier:(CGFloat)multiplier constant:(CGFloat)constant;;

// pin views height/width
- (NSLayoutConstraint *)pinWidth:(CGFloat)width;
- (NSLayoutConstraint *)pinHeight:(CGFloat)height;
- (NSLayoutConstraint *)pinHeight:(CGFloat)height priority:(UILayoutPriority)priority;
- (void)pinWidth:(CGFloat)width height:(CGFloat)height;

- (void)pinToCenterWithView:(UIView *)view;
- (NSLayoutConstraint *)pinToVerticalCenterWithView:(UIView *)view;
- (NSLayoutConstraint *)pinToVerticalCenterWithView:(UIView *)view multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint *)pinToHorizontalCenterWithView:(UIView *)view;
- (NSLayoutConstraint *)pinToHorizontalCenterWithView:(UIView *)view multiplier:(CGFloat)multiplier;

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options;
-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options flexibleFirstItem:(BOOL)flexibleFirstItem;
-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options flexibleFirstItem:(BOOL)flexibleFirstItem applySpacingToEdges:(BOOL)spaceEdges;
-(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis;
@end
