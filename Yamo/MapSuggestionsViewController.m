//
//  MapSuggestionsViewController.m
//  Yamo
//
//  Created by Dario Langella on 22/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapSuggestionsViewController.h"
#import "LaunchNavigationViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "Yamo-Swift.h"
#import "UIViewController+Title.h"

static double VenueSearchSummaryRelevanceThreshold = 50;

@interface MapSuggestionsViewController () <LaunchNavigationViewController>

@property (nonatomic) UIButton *showMeButton;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;

@end

@implementation MapSuggestionsViewController

+ (NSInteger)numberOfMatchingVenueSummaries:(NSArray <VenueSearchSummary *> *)venueSummaries {
    
    return [self numberOfMatchingVenueSummaries:venueSummaries forThreshold:VenueSearchSummaryRelevanceThreshold];
}

+ (NSInteger)numberOfMatchingVenueSummaries:(NSArray <VenueSearchSummary *> *)venueSummaries forThreshold:(double)threshold {

    NSInteger count = 0;
    
    for (VenueSearchSummary *summary in venueSummaries) {
        
        if (summary.mapRelevance > threshold) {
            
            count++;
        }
    }
    
    return count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%lu",(unsigned long)self.venueSummaries.count);

    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IcondarkXdisabled 1 1 1 1"] style:UIBarButtonItemStylePlain target:self action:@selector(showMeButtonAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self setAttributedTitle:NSLocalizedString(@"My Map", nil)];
    
    NSUInteger numberOfMatchedInterests = [[self class] numberOfMatchingVenueSummaries:self.venueSummaries];

    [self setTitleLabelWithNumber:numberOfMatchedInterests];
    [self setDescriptionLabel];
    [self setShowMeButtonWithMatches:numberOfMatchedInterests];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitleLabelWithNumber:(NSUInteger)numberOfMatchedInterests {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    
    NSString *matches = numberOfMatchedInterests == 1 ? NSLocalizedString(@"match!", nil) : NSLocalizedString(@"matches!", nil);
    NSString *titleText = [NSString stringWithFormat:NSLocalizedString(@"We’ve found %lu %@", nil), (unsigned long)numberOfMatchedInterests, matches];
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:23],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:23],
                                  NSForegroundColorAttributeName: [UIColor yamoBlack] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleText attributes:attributes];
    
    self.titleLabel.attributedText = attributedString;
    
    [self.view addSubview:self.titleLabel];
    [self setupConstraintsForTitleLabelInView:self.view];
}

- (void)setDescriptionLabel {
    
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    NSMutableAttributedString *detailAttributedText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Based on your answers, we’ve found a few locations we think you’ll love!", nil)];
    [detailAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:17] range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:17] range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor yamoGray] range:NSMakeRange(0, [detailAttributedText length])];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.attributedText = detailAttributedText;
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    
    [self.view addSubview:self.detailLabel];
    [self setupConstraintsForDetailLabelInView:self.view];
}

- (void)setShowMeButtonWithMatches:(NSUInteger)numberOfMatchedInterests {
    
    UIFont *graphikRegular14 = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    
    NSAttributedString *buttonTitleEnabled = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Done", nil)
                                                                           attributes:@{ NSFontAttributeName : graphikRegular14,
                                                                                         NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                                                                         NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:1.0]  }];
    NSAttributedString *buttonTitleDisabled = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Done", nil)
                                                                              attributes:@{ NSFontAttributeName : graphikRegular14,
                                                                                            NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                                                                           NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.2],
                                                                                           }];
    self.showMeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showMeButton.frame = CGRectZero;
    self.showMeButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.showMeButton setAttributedTitle:buttonTitleEnabled forState:UIControlStateNormal];
    [self.showMeButton setAttributedTitle:buttonTitleDisabled forState:UIControlStateDisabled];
    //
    [self.showMeButton setBackgroundImage:[UIImage imageNamed:@"Buttonyellowactive"] forState:UIControlStateNormal];
    [self.showMeButton setBackgroundImage:[UIImage imageNamed:@"Buttonyellowdisabled"] forState:UIControlStateDisabled];
    //
    self.showMeButton.contentMode = UIViewContentModeRedraw;
    
    [self.showMeButton addTarget:self action:@selector(showMeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showMeButton];
    [self setConstraintsForButton];

}


- (void) setConstraintsForButton {

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.showMeButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:48.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.showMeButton
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1.0
                                                           constant:5.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMeButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1.0
                                                           constant:5.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottomMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMeButton
                                                          attribute:NSLayoutAttributeBottomMargin
                                                         multiplier:1.0
                                                           constant:50.0f]];
}

- (void) setupConstraintsForTitleLabelInView:(UIView *) view {
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:50.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self.titleLabel
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:30.0f]];
    
}

- (void) setupConstraintsForDetailLabelInView:(UIView *) view {
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.detailLabel
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:12.0f]];
    
}



#pragma mark - Navigation

- (void)showMeButtonAction:(id)sender{
    
    if ([self.onboardingDelegate respondsToSelector:@selector(viewControllerDidFinish:)]) {
        [self.onboardingDelegate viewControllerDidFinish:self];
    } else {
        SubscriptionFlowCoordinator *coordinator = [SubscriptionFlowCoordinator new];
        UIViewController *nextViewController = [coordinator nextViewForCurrentViewController:self];
        
        if (nextViewController) {
            [self.navigationController pushViewController:nextViewController animated:YES];
        } else {
            
            if (self.presentingViewController) {
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

@end
