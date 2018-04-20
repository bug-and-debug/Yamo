//
//  RoutePlannerCollectionViewLayout.h
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLayout_Warpable.h"
#import "LOCCollectionViewLayoutHelper.h"

@interface RoutePlannerCollectionViewLayout : UICollectionViewFlowLayout <UICollectionViewLayout_Warpable>

@property (nonatomic) BOOL deleteMode;

@property (readonly, nonatomic) LOCCollectionViewLayoutHelper *layoutHelper;

@end
