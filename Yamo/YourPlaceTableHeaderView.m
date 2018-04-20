//
//  YourPlaceTableHeaderView.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "YourPlaceTableHeaderView.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "NSNumber+Yamo.h"

@interface YourPlaceTableHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;

@end

@implementation YourPlaceTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainTitleLabel.text = @"";
}

- (void)populateWithData:(NSString *)data {
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoTextDarkGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:data attributes:attributes];
    
    self.mainTitleLabel.attributedText = attributedString;
}

@end
