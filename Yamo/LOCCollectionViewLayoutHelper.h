//
//  LOCCollectionViewLayoutHelper.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLayout_Warpable.h"

@interface LOCCollectionViewLayoutHelper : NSObject

@property (nonatomic, weak, readonly) UICollectionViewLayout<UICollectionViewLayout_Warpable> *collectionViewLayout;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;
@property (nonatomic, strong) NSIndexPath *hideIndexPath;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout<UICollectionViewLayout_Warpable> *)collectionViewLayout;

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements;

@end
