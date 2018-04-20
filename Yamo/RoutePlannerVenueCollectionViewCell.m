//
//  RoutePlannerVenueCollectionViewCell.m
//  YamoRouteCollectionPrototype
//
//  Created by Peter Su on 26/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RoutePlannerVenueCollectionViewCell.h"
#import "RouteStepAppearance.h"
#import "RouteStep.h"
#import "Venue.h"
#import "NSParagraphStyle+Yamo.h"
#import "NSNumber+Yamo.h"

static CGFloat const RoutePlannerVenueCollectionViewCellAnnotationSize = 34.0f;

@interface RoutePlannerVenueCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *annotationButton;

@end

@implementation RoutePlannerVenueCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.subtitleLabel.text = @"";
    
    [self.annotationButton setTitle:@"" forState:UIControlStateNormal];
    [self.annotationButton addTarget:self action:@selector(handleDidPressAnnotationButton) forControlEvents:UIControlEventTouchUpInside];
    self.annotationButton.userInteractionEnabled = NO;
}

#pragma mark - Public

- (void)populateCollectionCellForStep:(RouteStep *)step canDelete:(BOOL)canDelete {
    
    Venue *venueForStep = step.venue;
    NSString *mainText = venueForStep.name ? venueForStep.name : @"";
    NSString *subtitleText = venueForStep.galleryName ? venueForStep.galleryName : @"";
    self.mainTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:mainText
                                                                         attributes:[RoutePlannerVenueCollectionViewCell mainTitleAttributes]];
    self.subtitleLabel.attributedText = [[NSAttributedString alloc] initWithString:subtitleText
                                                                        attributes:[RoutePlannerVenueCollectionViewCell subtitleAttributes]];
    
    UIColor *backgroundColor = [UIColor redColor];
    UIColor *titleColor = [UIColor whiteColor];
    if (canDelete) {
        
        [self.annotationButton setImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateNormal];
        [self.annotationButton setTitle:@"" forState:UIControlStateNormal];
        titleColor = [RouteStepAppearance textColorForBackgroundColor:backgroundColor];
        
    } else {
        
        [self.annotationButton setImage:nil forState:UIControlStateNormal];
        
        NSAttributedString *attributedNormalTitle = [[NSAttributedString alloc] initWithString:[RouteStepAppearance stepLetterForStep:step]
                                                                                    attributes:[RoutePlannerVenueCollectionViewCell annotationTitleNormalAttributes]];
        NSAttributedString *attributedHighlightedTitle = [[NSAttributedString alloc] initWithString:[RouteStepAppearance stepLetterForStep:step]
                                                                                         attributes:[RoutePlannerVenueCollectionViewCell annotationTitleHighlightedAttributes]];
        
        [self.annotationButton setAttributedTitle:attributedNormalTitle forState:UIControlStateNormal];
        [self.annotationButton setAttributedTitle:attributedHighlightedTitle forState:UIControlStateHighlighted];
        
        backgroundColor = [RouteStepAppearance stepColorForSequence:step];
        titleColor = [RouteStepAppearance textColorForBackgroundColor:backgroundColor];
    }
    
    [self.annotationButton setTitleColor:titleColor forState:UIControlStateNormal];
    self.annotationContainerView.backgroundColor = backgroundColor;
    
    BOOL prefersBlackContent = [RouteStepAppearance prefersDarkContentForColor:backgroundColor];
    self.annotationContainerView.layer.borderWidth = prefersBlackContent ? 1.0 : 0.0;
    self.annotationContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.annotationButton.userInteractionEnabled = canDelete;
}

+ (CGFloat)calculateCellHeightForStep:(RouteStep *)step {
    
    Venue *venueForStep = step.venue;
    
    CGSize boundingSize = [self boundingSize];
    
    CGSize mainTitleSize = [venueForStep.name boundingRectWithSize:boundingSize
                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                        attributes:[self mainTitleAttributes]
                                                           context:nil].size;
    
    NSString *venueGalleryName = venueForStep.galleryName ? venueForStep.galleryName : @"";
    CGSize subtitleSize = [venueGalleryName boundingRectWithSize:boundingSize
                                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                      attributes:[self subtitleAttributes]
                                                         context:nil].size;
    
    CGFloat totalLabelHeight = mainTitleSize.height + subtitleSize.height;
    if (totalLabelHeight <= RoutePlannerVenueCollectionViewCellAnnotationSize) {
        totalLabelHeight = RoutePlannerVenueCollectionViewCellAnnotationSize;
    }
    
    return totalLabelHeight + RoutePlannerVenueCollectionViewCellTopBottomSpace;
}


#pragma mark - Helpers

+ (NSDictionary *)mainTitleAttributes {
    
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForHeader];
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:17.5f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:17.5f],
              NSForegroundColorAttributeName : [UIColor yamoTextGray],
              NSParagraphStyleAttributeName: style };
}

+ (NSDictionary *)subtitleAttributes {
    
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f],
              NSForegroundColorAttributeName : [UIColor yamoTextLightGray],
              NSParagraphStyleAttributeName: style };
}

+ (NSDictionary *)annotationTitleNormalAttributes {
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
              NSForegroundColorAttributeName : [UIColor whiteColor] };
}

+ (NSDictionary *)annotationTitleHighlightedAttributes {
    
    return @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
              NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
              NSForegroundColorAttributeName : [UIColor redColor] };
}

+ (CGSize)boundingSize {
    
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - RoutePlannerVenueCollectionViewCellLeadingTrailingSpace, CGFLOAT_MAX);
}

#pragma mark - Actions

- (void)handleDidPressAnnotationButton {
    
    if ([self.delegate respondsToSelector:@selector(routePlannerCollectionViewCellDidPressAnnotationForCell:)]) {
        [self.delegate routePlannerCollectionViewCellDidPressAnnotationForCell:self];
    }
}

@end
