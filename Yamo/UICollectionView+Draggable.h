//
//  UICollectionView+Draggable.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//
//  Based off Luke Scott - DraggableCollection
//  https://github.com/lukescott/DraggableCollectionView
//

#import <UIKit/UIKit.h>
#import "UICollectionViewDataSource_Draggable.h"

@interface UICollectionView (Draggable)

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;
@end
