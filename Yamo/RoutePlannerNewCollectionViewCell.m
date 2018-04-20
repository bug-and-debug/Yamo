//
//  RoutePlannerNewCollectionViewCell.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerNewCollectionViewCell.h"
#import "NSNumber+Yamo.h"

@implementation RoutePlannerNewCollectionViewCell

- (void)updateAppearanceForType:(RoutePlannerNewCellType)type {
    
    NSString *mainText = @"";
    switch (type) {
        case RoutePlannerNewCellTypeAddStart: {
            mainText = NSLocalizedString(@"Add start location", nil);
            break;
        }
        case RoutePlannerNewCellTypeAddNew: {
            mainText = NSLocalizedString(@"Add another exhibition", nil);
            
            break;
        }
        case RoutePlannerNewCellTypeAddReturn: {
            mainText = NSLocalizedString(@"Add return location", nil);
            break;
        }
        default: {
            
            mainText = @"";
            break;
        }
    }
    
    
    self.mainTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:mainText
                                                                         attributes:[RoutePlannerNewCollectionViewCell titleAttributes]];
}

#pragma mark - Helper

+ (NSDictionary *)titleAttributes {
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
              NSForegroundColorAttributeName : [UIColor yamoTextGray] };
}

@end
