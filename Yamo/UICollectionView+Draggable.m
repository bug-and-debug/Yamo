//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "UICollectionView+Draggable.h"
#import "LOCCollectionViewHelper.h"
#import <objc/runtime.h>

@implementation UICollectionView (Draggable)

- (LOCCollectionViewHelper *)getHelper
{
    LOCCollectionViewHelper *helper = objc_getAssociatedObject(self, "LOCCollectionViewHelper");
    if(helper == nil) {
        helper = [[LOCCollectionViewHelper alloc] initWithCollectionView:self];
        objc_setAssociatedObject(self, "LOCCollectionViewHelper", helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

- (BOOL)isDragging {
    return [self getHelper].dragging;
}

- (void)setIsDragging:(BOOL)isDragging
{
    [self getHelper].dragging = isDragging;
}

- (BOOL)draggable
{
    return [self getHelper].enabled;
}

- (void)setDraggable:(BOOL)draggable
{
    [self getHelper].enabled = draggable;
}

- (UIEdgeInsets)scrollingEdgeInsets
{
    return [self getHelper].scrollingEdgeInsets;
}

- (void)setScrollingEdgeInsets:(UIEdgeInsets)scrollingEdgeInsets
{
    [self getHelper].scrollingEdgeInsets = scrollingEdgeInsets;
}

- (CGFloat)scrollingSpeed
{
    return [self getHelper].scrollingSpeed;
}

- (void)setScrollingSpeed:(CGFloat)scrollingSpeed
{
    [self getHelper].scrollingSpeed = scrollingSpeed;
}

@end