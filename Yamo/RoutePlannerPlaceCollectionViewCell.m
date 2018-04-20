//
//  RoutePlannerPlaceCollectionViewCell.m
//  Yamo
//
//  Created by Peter Su on 02/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerPlaceCollectionViewCell.h"
#import "NSNumber+Yamo.h"

@interface RoutePlannerPlaceCollectionViewCell ()

@property (nonatomic) BOOL isSource;

@end

@implementation RoutePlannerPlaceCollectionViewCell

- (void)updateLayoutForDeleteMode {
    
    self.mainTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@""
                                                                         attributes:[RoutePlannerPlaceCollectionViewCell titleAttributes]];
    self.annotationContainerView.hidden = YES;
    
}

- (void)populateCollectionCellForLocation:(NSString *)location isSource:(BOOL)isSource {
    
    NSString *mainText = location ? location : @"";

    self.mainTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:mainText
                                                                         attributes:[RoutePlannerPlaceCollectionViewCell titleAttributes]];
    
    self.annotationContainerView.hidden = NO;
    
    _isSource = isSource;
    
}

+ (CGFloat)calculateCellHeightForLocation:(NSString *)location {
    
    return 60.0f;
}

- (IBAction)handleDidPressEditSource:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerCollectionViewCellDidPressChangeLocation:isSource:)]) {
        [self.delegate routePlannerCollectionViewCellDidPressChangeLocation:self isSource:self.isSource];
    }
}

#pragma mark - Helpers

+ (NSDictionary *)titleAttributes {
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
              NSForegroundColorAttributeName : [UIColor yamoTextGray] };
}

@end
