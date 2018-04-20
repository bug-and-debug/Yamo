//
//  PlaceTableViewCell.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"

@interface PlaceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIImageView *tickIconImageView;

@end

@implementation PlaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupAppearance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.separator.backgroundColor = [UIColor yamoSeparatorGray];
}

- (void)prepareForReuse {
    
    self.mainTitleLabel.text = @"";
}

#pragma mark - Setup

- (void)setupAppearance {
    
    self.separator.backgroundColor = [UIColor yamoSeparatorGray];
}

#pragma mark - Public

- (void)populateCellWithData:(NSString *)data
                  isSelected:(BOOL)isSelected {
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoDarkGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:data attributes:attributes];
    
    self.mainTitleLabel.attributedText = attributedString;
    self.tickIconImageView.hidden = !isSelected;
}

@end
