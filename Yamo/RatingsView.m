//
//  RatingStarsMembers.m
//  TestBackBtn
//
//  Created by Vlad Buhaescu on 10/05/2016.
//  Copyright © 2016 Vlad Buhaescu. All rights reserved.
//

#import "RatingsView.h"

@import UIImageView_LOCExtensions;
@import UIView_LOCExtensions;

NSString * const emptyStar = @"emptyStar";
NSString * const fullStar = @"fullStar";
NSInteger const spaceBetweenStars = 10;

@interface RatingsView ()

@property (nonatomic, strong) NSMutableArray *starsArray;
@property NSUInteger lastSelectedStarCount;
@property NSUInteger filledStarsAfterTouch;

@end

@implementation RatingsView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:letterTapRecognizer];
        self.lastSelectedStarCount = INT_MAX;
        self.initialFilledStars = 0;
        self.starHeight = 26;
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender {
    
    CGPoint touchPoint = [sender locationInView: self];
    NSUInteger selectedIndex = 0;
    
    for (UIImageView *imageView in self.starsArray) {
        
        CGRect newRect = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width + spaceBetweenStars, imageView.frame.size.height);
        if (CGRectContainsPoint(newRect, touchPoint)) {
            
            selectedIndex = [self.starsArray indexOfObject:imageView];
            break;
        }
    }
    
    for (UIImageView *imageView in self.starsArray) {
        
        if ([self.starsArray indexOfObject:imageView] <= selectedIndex) {
            imageView.image = [UIImage imageNamed:fullStar];
        }
        else {
            imageView.image = [UIImage imageNamed:emptyStar];
        }
    }
    
    _lastSelectedStarCount = selectedIndex + 1;

    if ([self.delegate respondsToSelector:@selector(ratingsViewDidSelectedStar:)]) {
        [self.delegate ratingsViewDidSelectedStar:self.getSelectedRating];
    }
}

- (void)resetEmptyStars {
    
    for (UIImageView *imageView in self.starsArray) {
        imageView.image = [UIImage imageNamed:emptyStar];
    }
}

- (UIImageView *)starImageView {
    
    //Create a view
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:emptyStar];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Add the view to the superview
    [self addSubview:imageView];
    
    //Constrain the width and center on the x axis
    [imageView pinHeight:self.starHeight];
    [imageView centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    //Return the view
    return imageView;
}

- (void)evenlySpaceStars {
    
    NSMutableArray *arrayOfViews = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<self.starsCount; i++) {
        [arrayOfViews addObject:[self starImageView]];
    }
    
    self.starsArray = [NSMutableArray arrayWithArray: arrayOfViews];
    [self spaceViews:self.starsArray onAxis:UILayoutConstraintAxisHorizontal withSpacing:spaceBetweenStars alignmentOptions:0];
}

- (NSInteger)getSelectedRating {
    
    NSInteger stars = _lastSelectedStarCount > 5 ? 0 : _lastSelectedStarCount;
    
    if (_lastSelectedStarCount == INT_MAX) {
        stars = 5;
    }
    
    return stars;
}

@end