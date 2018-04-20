//
//  LOCCollectionViewHelper.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOCCollectionViewHelper : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UIGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, readonly) UIGestureRecognizer *panPressGestureRecognizer;
@property (nonatomic) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic) CGFloat scrollingSpeed;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL dragging;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
