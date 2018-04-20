//
//  RoutePlannerCollectionViewCell.m
//  Yamo
//
//  Created by Peter Su on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerCollectionViewCell.h"

@implementation RoutePlannerCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.mainTitleLabel.text = @"";
    
    self.annotationContainerView.layer.cornerRadius = CGRectGetHeight(self.annotationContainerView.bounds) / 2;
}

@end
