//
//  Created by Danny Bravo
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

#import "UIImageView+LOCCreation.h"

@implementation UIImageView (LOCCreation)

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName origin:(CGPoint)origin addToView:(UIView *)parentView
{
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
    [parentView addSubview:view];
    return view;
}

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName origin:(CGPoint)origin addToView:(UIView *)parentView
{
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
    view.highlightedImage = [UIImage imageNamed:highlightedImageName];
    [parentView addSubview:view];
    return view;
}

+ (UIImageView *)emptyImageViewWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode addToView:(UIView *)parentView {
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.contentMode = contentMode;
    view.clipsToBounds = YES;
    [parentView addSubview:view];
    return view;
}

@end
