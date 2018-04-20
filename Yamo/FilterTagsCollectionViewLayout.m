//
//  FilterTagsCollectionViewLayout.m
//  Yamo
//
//  Created by Hungju Lu on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterTagsCollectionViewLayout.h"

@implementation FilterTagsCollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *originalAttribtues = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributesForElementsInRect = [[NSArray alloc] initWithArray:originalAttribtues copyItems:YES];
    NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attributesForElementsInRect.count];
    
    CGFloat leftMargin = self.sectionInset.left;
    
    for (UICollectionViewLayoutAttributes *attributes in attributesForElementsInRect) {
        if (attributes.frame.origin.x == self.sectionInset.left) {
            leftMargin = self.sectionInset.left;
        } else {
            CGRect newLeftAlignedFrame = attributes.frame;
            newLeftAlignedFrame.origin.x = leftMargin;
            attributes.frame = newLeftAlignedFrame;
        }
        
        leftMargin += attributes.frame.size.width + 10.0;
        [newAttributesForElementsInRect addObject:attributes];
    }
    
    return newAttributesForElementsInRect;
}

@end
