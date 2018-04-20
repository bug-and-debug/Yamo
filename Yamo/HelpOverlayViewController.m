//
//  HelpOverlayViewController.m
//  Yamo
//
//  Created by Dario Langella on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "HelpOverlayViewController.h"
#import "UIFont+Yamo.h"
#import "Yamo-Swift.h"
#import "UIColor+Yamo.h"
#import "UIFont+Yamo.h"

@interface HelpOverlayViewController ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIButton *skipButton;


@end

@implementation HelpOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces=NO;
    [self.view addSubview:self.scrollView];
    
    [self setSkipButtonInView];
    [self setPageControlInView];
    
    [self reloadInputViews];

}

- (void) updateViewConstraints {

    [super updateViewConstraints];
    
    [self setupConstraintsForSkipButton];
    [self setupConstraintsForPageControl];
}

#pragma mark - Data Source

- (void)setCutouts:(NSArray *)cutouts {
    _cutouts = cutouts;
    
    NSArray *viewArray = [NSArray arrayWithArray:_cutouts];
    
    for (UIView *view in _cutouts) {
        
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * [_cutouts indexOfObject:view];
        frame.origin.y = 0;
        frame.size = [UIScreen mainScreen].bounds.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [subview addSubview:view];
        [self.scrollView addSubview:subview];

    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * viewArray.count, self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = viewArray.count;
    
    if ([self respondsToSelector:@selector(loadViewIfNeeded)]) {
        [self loadViewIfNeeded];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Skip Button

- (void) setSkipButtonInView {
    
    self.skipButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipButton.tintColor= [UIColor whiteColor];
    self.skipButton.titleLabel.textColor= [UIColor whiteColor];
    NSMutableAttributedString *titleSkipButtonAttributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Finish", nil) ];
    [titleSkipButtonAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleSkipButtonAttributedString length])];
    [titleSkipButtonAttributedString addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f] range:NSMakeRange(0, [titleSkipButtonAttributedString length])];
    [titleSkipButtonAttributedString addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0f] range:NSMakeRange(0, [titleSkipButtonAttributedString length])];
    [self.skipButton.titleLabel setFont:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f]];
    [self.skipButton setAttributedTitle:titleSkipButtonAttributedString forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipButton];
}

- (void) setPageControlInView {
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.currentPageIndicatorTintColor= [UIColor yamoYellow];
    self.pageControl.pageIndicatorTintColor= [UIColor whiteColor];
    self.pageControl.userInteractionEnabled=NO;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];

}

#pragma mark - Cutout Creation

- (UIView *)cutOutView:(CGRect)sourceFrame withCornerRadius:(CGFloat)cornerRadius title:(NSString *) title detail:(NSString *)detail {
    
    return [self cutOutViews:@[[NSValue valueWithCGRect:sourceFrame]] withCornerRadius:cornerRadius title:title detail:detail];
}

- (UIView *)cutOutViews:(NSArray <NSValue *> *)sourceValues withCornerRadius:(CGFloat)cornerRadius title:(NSString *) title detail:(NSString *)detail {
    
    // Setting View
    UIView  *viewToReturn = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    
    NSDictionary *titleAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:23.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:23.0f],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:title attributes:titleAttributes];
    self.titleLabel.attributedText = titleAttributedString;
    
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    NSMutableAttributedString *detailAttributedText = [[NSMutableAttributedString alloc] initWithString:detail];
    [detailAttributedText addAttribute:NSKernAttributeName value:[NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:17.0] range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSFontAttributeName value:[UIFont preferredFontForStyle:FontStyleGraphikRegular size:17.0f] range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:212/255.0 green:210/255.0 blue:204/255.0 alpha:255/255.0] range:NSMakeRange(0, [detailAttributedText length])];
    [detailAttributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [detailAttributedText length])];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.attributedText = detailAttributedText;
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    
    // Setting Mask
    [viewToReturn.layer addSublayer:[self setCutToRectFromArray:sourceValues withCornerRadius:cornerRadius]];
    
    // Setting AddSubviews
    [viewToReturn addSubview:self.titleLabel];
    [viewToReturn addSubview:self.detailLabel];

    // Setting Constraints
    [self setupConstraintsForTitleLabelInView:viewToReturn];
    [self setupConstraintsForDetailLabelInView:viewToReturn];
    
    return viewToReturn;
}

#pragma mark - Cut Mask

- (CAShapeLayer *)setCutToRectFromArray:(NSArray *)arrayOfFrames withCornerRadius:(CGFloat)cornerRadius {
    // Define shape
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    [ mask setFillRule:kCAFillRuleEvenOdd];
    [ mask setFillColor:[[UIColor yamoGoldenBrownWithTransparency] CGColor]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *cutoutPath;
    
    for (NSValue *valueOfObject in arrayOfFrames) {
        CGRect centerZero = [valueOfObject CGRectValue];
        cutoutPath = [UIBezierPath bezierPathWithRoundedRect:centerZero cornerRadius:cornerRadius];
        [maskPath appendPath:cutoutPath];
    }
    
    // Set the new path
    mask.path = maskPath.CGPath;
    
    return mask;
    
}

#pragma mark - Constraints
- (void) skipAction:(id) sender{
    
    if ([self.delegate respondsToSelector:@selector(dimissHelp:)]) {
        [self.delegate dimissHelp:self];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Constraints

- (void) setupConstraintsForPageControl {
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:50]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1.0
                                                           constant:-8.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1.0
                                                           constant:8.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.skipButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
}

- (void) setupConstraintsForSkipButton {
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.skipButton
                                                          attribute:NSLayoutAttributeBottomMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottomMargin
                                                         multiplier:1.0
                                                           constant:-30.0]];
    
}

- (void) setupConstraintsForTitleLabelInView:(UIView *) view {
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeTopMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1.0f
                                                      constant:120.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:-16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:24.0f]];
    
}

- (void) setupConstraintsForDetailLabelInView:(UIView *) view {
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:16.0f]];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:-16.0f]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:8.0f]];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
}


@end
