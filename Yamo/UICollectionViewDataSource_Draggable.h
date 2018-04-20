//
//  UICollectionViewDataSource_Draggable.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//
//  Based off Luke Scott - DraggableCollectionView
//  https://github.com/lukescott/DraggableCollectionView
//

#import <Foundation/Foundation.h>

@class LOCCollectionViewHelper;

@protocol UICollectionViewDataSource_Draggable <UICollectionViewDataSource>
@required

- (void)draggableCollectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (BOOL)draggableCollectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (BOOL)draggableCollectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)draggableCollectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end
