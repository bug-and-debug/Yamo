//
//  RoutePlannerCollectionViewLayout.m
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionViewLayout.h"
#import "LOCCollectionViewLayoutHelper.h"
#import "RoutePlannerDecorationView.h"

@interface RoutePlannerCollectionViewLayout ()

@property (nonatomic, strong) LOCCollectionViewLayoutHelper *layoutHelper;

@end

@implementation RoutePlannerCollectionViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    [self registerClass:RoutePlannerDecorationView.class forDecorationViewOfKind:NSStringFromClass(RoutePlannerDecorationView.class)];
}

- (LOCCollectionViewLayoutHelper *)layoutHelper
{
    if(_layoutHelper == nil) {
        _layoutHelper = [[LOCCollectionViewLayoutHelper alloc] initWithCollectionViewLayout:self];
    }
    return _layoutHelper;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *modifiedAttributes = [self.layoutHelper modifiedLayoutAttributesForElements:[super layoutAttributesForElementsInRect:rect]];
    
    NSMutableArray *decoratorAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *attribute in modifiedAttributes) {
        
        if (attribute.representedElementKind == nil) {
            
            UICollectionViewLayoutAttributes *decoAttribute = [self layoutAttributesForDecorationViewOfKind:NSStringFromClass(RoutePlannerDecorationView.class) atIndexPath:attribute.indexPath];
            
            [decoratorAttributes addObject:decoAttribute];
        }
    }
    
    return [modifiedAttributes arrayByAddingObjectsFromArray:decoratorAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    
    if (!attr) {
        attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *cellAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
        attr.zIndex = -1;
        
        CGFloat leadingSpacingOffset = 41;
        CGFloat firstTopSpacingOffset = 23;
        CGFloat decoratorWidth = 2;
        
        
        if (indexPath.section == 0) {
            
            if (!self.deleteMode) {
                attr.frame = CGRectMake(leadingSpacingOffset, firstTopSpacingOffset, decoratorWidth, ceilf(CGRectGetHeight(cellAttr.frame) - firstTopSpacingOffset));
            }
        }
        else if (indexPath.section == 1) {
            
            if (!self.deleteMode) {
                attr.frame = CGRectMake(leadingSpacingOffset, CGRectGetMinY(cellAttr.frame), decoratorWidth, ceilf(CGRectGetHeight(cellAttr.frame)));
            }
        }
        else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                attr.frame = CGRectMake(leadingSpacingOffset, CGRectGetMinY(cellAttr.frame), decoratorWidth, ceilf(CGRectGetHeight(cellAttr.frame)));
            } else {
                attr.frame = CGRectMake(leadingSpacingOffset, CGRectGetMinY(cellAttr.frame), decoratorWidth, ceilf(CGRectGetHeight(cellAttr.frame) / 2));
            }
        }
    }
    
    return attr;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition {
    
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];

    return context;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.deleteMode) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        attributes.alpha = 0.0;
        return attributes;
    } else {
        return [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
    }
}

@end
