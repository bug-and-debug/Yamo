//
//  RoutePlannerCollectionViewCell.h
//  Yamo
//
//  Created by Peter Su on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"

static CGFloat const RoutePlannerVenueCollectionViewCellTopBottomSpace = 24.0f;
static CGFloat const RoutePlannerVenueCollectionViewCellLeadingTrailingSpace = 90.0f;

@protocol RoutePlannerCollectionViewCellDelegate;

@interface RoutePlannerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *annotationContainerView;

@property (nonatomic, weak) id<RoutePlannerCollectionViewCellDelegate> delegate;

@end

@protocol RoutePlannerCollectionViewCellDelegate <NSObject>

- (void)routePlannerCollectionViewCellDidPressAnnotationForCell:(RoutePlannerCollectionViewCell *)cell;
- (void)routePlannerCollectionViewCellDidPressChangeLocation:(RoutePlannerCollectionViewCell *)cell isSource:(BOOL)isSource;

@end
