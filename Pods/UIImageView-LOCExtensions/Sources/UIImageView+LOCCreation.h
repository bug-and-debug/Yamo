//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LOCCreation)

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName;
+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName origin:(CGPoint)origin addToView:(UIView *)parentView;
+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName origin:(CGPoint)origin addToView:(UIView *)parentView;
+ (UIImageView *)emptyImageViewWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode addToView:(UIView *)parentView;

@end