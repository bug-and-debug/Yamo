//
//  PlacesTableViewCell.m
//  Yamo
//
//  Created by Dario Langella on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesTableViewCell.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"

@implementation PlacesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.numberOfLines = 0;
}

@end
