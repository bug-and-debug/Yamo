//
//  RatingStarsMembers.h
//  TestBackBtn
//
//  Created by Vlad Buhaescu on 10/05/2016.
//  Copyright © 2016 Vlad Buhaescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RatingsViewDelegate <NSObject>

- (void)ratingsViewDidSelectedStar:(NSInteger)selectedStar;

@end

@interface RatingsView : UIView

@property (nonatomic, weak) id<RatingsViewDelegate> delegate;

@property NSUInteger starsCount;
@property NSUInteger initialFilledStars;
@property NSUInteger starHeight;

- (void)resetEmptyStars;
- (void)evenlySpaceStars;
- (NSInteger)getSelectedRating;

@end
