//
//  FilterSliderCell.m
//  Yamo
//
//  Created by Hungju Lu on 21/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "FilterSliderTableViewCell.h" 
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"
#import "NSNumber+Yamo.h"

const CGFloat FilterSliderTableViewCellExpandedHeight = 105.0f;
const CGFloat FilterSliderTableViewCellDefaultHeight = 45.0f;

@interface FilterSliderTableViewCell ()
@property (weak, nonatomic) IBOutlet UISlider *sliderControl;
@property (weak, nonatomic) IBOutlet UILabel *indicatorMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *indicatorFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *indicatorSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *indicatorMaxLabel;
@end

@implementation FilterSliderTableViewCell

- (void)setFilterItem:(FilterItem *)filterItem {
    [super setFilterItem:filterItem];
    [self configureView];
}

- (void)configureView {
    
    self.sliderControl.thumbTintColor = [UIColor yamoYellow];
    self.sliderControl.minimumTrackTintColor = [UIColor yamoYellow];
    
    UIImage *image = [self thumbImageWithColor:[UIColor yamoYellow]];
    [self.sliderControl setThumbImage:image forState:UIControlStateNormal];
    [self.sliderControl setThumbImage:image forState:UIControlStateHighlighted];
    
    self.sliderControl.minimumValue = 0;
    self.sliderControl.maximumValue = 3;
    
    self.sliderControl.value = [self.filterItem.filterSelection.firstObject floatValue];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12]};
    
    self.indicatorMinLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Free", nil) attributes:attributes];
    self.indicatorFirstLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"£", nil) attributes:attributes];
    self.indicatorSecondLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"££", nil) attributes:attributes];
    self.indicatorMaxLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"£££", nil) attributes:attributes];
}

- (UIImage *)thumbImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // rounded corners
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10.0, 10.0), NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0] addClip];
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    float value = roundf(sender.value);
    
    // snap to the value
    sender.value = value;
    
    self.filterItem.filterSelection = @[@(value)];
    
    if ([self.delegate respondsToSelector:@selector(filterTableViewCellDidChangedSelection:)]) {
        [self.delegate filterTableViewCellDidChangedSelection:self];
    }    
}

@end
