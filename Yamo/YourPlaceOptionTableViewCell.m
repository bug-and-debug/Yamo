//
//  YourPlaceOptionTableViewCell.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceOptionTableViewCell.h"
#import "YourPlaceOption.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "NSNumber+Yamo.h"

@interface YourPlaceOptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *editTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation YourPlaceOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor yamoLightGray];
    self.selectedBackgroundView.backgroundColor = [UIColor yamoLightGray];
    
    self.separator.backgroundColor = [UIColor yamoSeparatorGray];
}

#pragma mark - Public

- (void)populateCellForData:(YourPlaceOption *)option {
    
    NSString *stringForOption = [YourPlaceOption stringForOptionType:option.type];
        
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"Edit %@", nil), [stringForOption lowercaseString]];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoDarkGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    self.editTitleLabel.attributedText = attributedString;
}

@end
