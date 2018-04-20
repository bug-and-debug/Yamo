//
//  UIView+Autolayout.m
//
//  Created by Jose Fernandez on 06/08/2015.
//  Copyright (c) 2015 Locassa Ltd. All rights reserved.
//

#import "UIView+LOCAutolayout.h"

@implementation UIView (LOCAutolayout)

# pragma mark -
# pragma mark Pinning

- (NSArray *)pinView:(UIView *)view
{
    return [self pinView:view toEdges:LOCPinnedEdgeAll];
}


- (NSArray *)pinView:(UIView *)view toEdges:(LOCPinnedEdge)edges
{
    return [self pinView:view toEdges:edges margin:0];
}


- (NSArray *)pinView:(UIView *)view toEdges:(LOCPinnedEdge)edges margin:(CGFloat)margin
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    // leading
    if (edges == LOCPinnedEdgeAll || edges & LOCPinnedEdgeLeading) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0f
                                                             constant:margin]];
    }
    
    // trailing
    if (edges == LOCPinnedEdgeAll || edges & LOCPinnedEdgeTrailing) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0f
                                                             constant:-margin]];
    }
    
    // top
    if (edges == LOCPinnedEdgeAll || edges & LOCPinnedEdgeTop) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:margin]];
    }
        
    // top
    if (edges == LOCPinnedEdgeAll || edges & LOCPinnedEdgeBottom) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:-margin]];
    }
    
    [self addConstraints:constraints];
    
    return constraints;
}


- (NSLayoutConstraint *)pinView:(UIView *)viewA withAttribute:(NSLayoutAttribute)attribute toView:(UIView *)viewB
{
    return [self pinView:viewA toEdge:attribute ofView:viewB edge:attribute withSpacing:0 priority:UILayoutPriorityRequired];
}


- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing
{
    return [self pinView:viewA toEdge:firstAttribute ofView:viewB edge:secondAttribute withSpacing:spacing priority:UILayoutPriorityRequired];
}

- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority {
    return [self pinView:viewA toEdge:firstAttribute ofView:viewB edge:secondAttribute withSpacing:spacing priority:priority multiplier:1.0f];
}

- (NSLayoutConstraint *)pinView:(UIView *)viewA toEdge:(NSLayoutAttribute)firstAttribute ofView:(UIView *)viewB edge:(NSLayoutAttribute)secondAttribute withSpacing:(CGFloat)spacing priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier
{
    UIView *ancestor = viewA;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = viewB;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewA
                                                                  attribute:firstAttribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewB
                                                                  attribute:secondAttribute
                                                                 multiplier:multiplier
                                                                   constant:spacing];
    constraint.priority = priority;
    [self addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)pinSameWidth:(UIView *)viewA toView:(UIView *)viewB
{
    return [self pinSameWidth:viewA toView:viewB multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)pinSameWidth:(UIView *)viewA toView:(UIView *)viewB multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewA
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewB
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:multiplier
                                                                   constant:constant];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)pinLessThenOrEqualWidth:(UIView *)viewA toView:(UIView *)viewB
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewA
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:viewB
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)pinSameHeight:(UIView *)viewA toView:(UIView *)viewB
{
    return [self pinSameWidth:viewA toView:viewB multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)pinSameHeight:(UIView *)viewA toView:(UIView *)viewB multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewA
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewB
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:multiplier
                                                                   constant:constant];
    [self addConstraint:constraint];
    return constraint;
}


- (NSLayoutConstraint *)pinWidth:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:width];
    [self addConstraint:constraint];
    return constraint;
}


- (NSLayoutConstraint *)pinHeight:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)pinHeight:(CGFloat)height priority:(UILayoutPriority)priority
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    constraint.priority = priority;
    [self addConstraint:constraint];
    return constraint;
}

- (void)pinWidth:(CGFloat)width height:(CGFloat)height
{
    [self pinWidth:width];
    [self pinHeight:height];
}


- (void)pinToCenterWithView:(UIView *)view
{
    [self pinToHorizontalCenterWithView:view];
    [self pinToVerticalCenterWithView:view];
}

- (NSLayoutConstraint *)pinToVerticalCenterWithView:(UIView *)view
{
    return [self pinToVerticalCenterWithView:view multiplier:1.0f];
}

- (NSLayoutConstraint *)pinToVerticalCenterWithView:(UIView *)view multiplier:(CGFloat)multiplier
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:multiplier
                                                                   constant:0];
    [self addConstraint:constraint];
    
    return constraint;
}

- (NSLayoutConstraint *)pinToHorizontalCenterWithView:(UIView *)view
{
    return [self pinToHorizontalCenterWithView:view multiplier:1.0f];
}

- (NSLayoutConstraint *)pinToHorizontalCenterWithView:(UIView *)view multiplier:(CGFloat)multiplier
{
    UIView *ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"pinned view must be a decendent of the receiver view");
    
    ancestor = view;
    while (ancestor != nil && ancestor != self) {
        ancestor = ancestor.superview;
    }
    NSAssert(ancestor == self, @"view to pin-to must be a decendent of the receiver view");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:multiplier
                                                                   constant:0];
    [self addConstraint:constraint];
    
    return constraint;
}

#pragma mark - Spacing Views

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options
{
    return [self spaceViews:views onAxis:axis withSpacing:spacing alignmentOptions:options flexibleFirstItem:NO];
}

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options flexibleFirstItem:(BOOL)flexibleFirstItem
{
    return [self spaceViews:views onAxis:axis withSpacing:spacing alignmentOptions:options flexibleFirstItem:flexibleFirstItem applySpacingToEdges:YES];
}

-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options flexibleFirstItem:(BOOL)flexibleFirstItem applySpacingToEdges:(BOOL)spaceEdges
{
    NSAssert([views count] > 1,@"Can only distribute 2 or more views");
    NSString *direction = nil;
    NSLayoutAttribute attribute;
    switch (axis) {
        case UILayoutConstraintAxisHorizontal:
            direction = @"H:";
            attribute = NSLayoutAttributeWidth;
            break;
        case UILayoutConstraintAxisVertical:
            direction = @"V:";
            attribute = NSLayoutAttributeHeight;
            break;
        default:
            return @[];
    }
    
    UIView *previousView = nil;
    UIView *firstView = views[0];
    NSDictionary *metrics = @{@"spacing":@(spacing)};
    NSString *vfl = nil;
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in views)
    {
        vfl = nil;
        NSDictionary *views = nil;
        if (previousView)
        {
            if (previousView == firstView && flexibleFirstItem)
            {
                vfl = [NSString stringWithFormat:@"%@[previousView(>=view)]-spacing-[view]",direction];
            }
            else
            {
                vfl = [NSString stringWithFormat:@"%@[previousView(==view)]-spacing-[view]",direction];
            }
            views = NSDictionaryOfVariableBindings(previousView,view);
        }
        else
        {
            vfl = [NSString stringWithFormat:@"%@|%@[view]",direction, spaceEdges ? @"-spacing-" : @""];
            views = NSDictionaryOfVariableBindings(view);
        }
        
        NSLog(@"adding %@",vfl );
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:views]];
        if (previousView == firstView && flexibleFirstItem)
        {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:firstView attribute:attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:view attribute:attribute multiplier:1.0 constant:2.0]];
        }
        previousView = view;
    }
    
    vfl = [NSString stringWithFormat:@"%@[previousView]%@|",direction, spaceEdges ? @"-spacing-" : @""];
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:metrics views:NSDictionaryOfVariableBindings(previousView)]];

    [self addConstraints:constraints];
    return [constraints copy];
}

#pragma mark - Centering Views

-(NSArray *)centerInView:(UIView*)view
{
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObject:[self centerInView:view onAxis:NSLayoutAttributeCenterX]];
    [constraints addObject:[self centerInView:view onAxis:NSLayoutAttributeCenterY]];
    
    return [constraints copy];
}


-(NSArray *)centerInContainer
{
    return [self centerInView:self.superview];
}

-(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis
{
    return [self centerInView:self.superview onAxis:axis];
}

-(NSLayoutConstraint *)centerInView:(UIView *)view onAxis:(NSLayoutAttribute)axis
{
    NSParameterAssert(axis == NSLayoutAttributeCenterX || axis == NSLayoutAttributeCenterY);
    return [self pinAttribute:axis toSameAttributeOfItem:view];
}


-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem
{
    return [self pinAttribute:attribute toAttribute:attribute ofItem:peerItem withConstant:0];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem withConstant:(CGFloat)constant
{
    return [self pinAttribute:attribute toAttribute:attribute ofItem:peerItem withConstant:constant];
}

-(NSArray *)pinEdges:(LOCPinnedEdge)edges toSameEdgesOfView:(UIView *)peerView
{
    return [self pinEdges:edges toSameEdgesOfView:peerView inset:0];
}

-(NSArray *)pinEdges:(LOCPinnedEdge)edges toSameEdgesOfView:(UIView *)peerView inset:(CGFloat)inset
{
    UIView *superview = [self commonSuperviewWithView:peerView];
    NSAssert(superview,@"Can't create constraints without a common superview");
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:4];
    
    if (edges & LOCPinnedEdgeTop)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:peerView withConstant:inset]];
    }
    if (edges & LOCPinnedEdgeLeading)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeLeft ofItem:peerView withConstant:inset]];
    }
    if (edges & LOCPinnedEdgeTrailing)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeRight ofItem:peerView withConstant:-inset]];
    }
    if (edges & LOCPinnedEdgeBottom)
    {
        [constraints addObject:[self pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:peerView withConstant:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}


- (NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant
{
    return [self pinAttribute:attribute toAttribute:toAttribute ofItem:peerItem withConstant:constant relation:NSLayoutRelationEqual];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem
{
    return [self pinAttribute:attribute toAttribute:toAttribute ofItem:peerItem withConstant:0];
}

-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant relation:(NSLayoutRelation)relation
{
    NSParameterAssert(peerItem);
    
    UIView *superview;
    if ([peerItem isKindOfClass:[UIView class]])
    {
        superview = [self commonSuperviewWithView:peerItem];
        NSAssert(superview,@"Can't create constraints without a common superview");
    }
    else
    {
        superview = self.superview;
    }
    NSAssert(superview,@"Can't create constraints without a common superview");
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:relation toItem:peerItem attribute:toAttribute multiplier:1.0 constant:constant];
    [superview addConstraint:constraint];
    return constraint;
}

-(UIView*)commonSuperviewWithView:(UIView*)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView])
        {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    
    return commonSuperview;
}


@end
