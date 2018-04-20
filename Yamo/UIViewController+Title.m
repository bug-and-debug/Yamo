//
//  UIViewController+Title.m
//  Yamo
//
//  Created by Hungju Lu on 19/09/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIViewController+Title.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "NSNumber+Yamo.h"

@implementation UIViewController (Title)

- (void)setAttributedTitle:(NSString *)title {
    
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0]};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

@end
