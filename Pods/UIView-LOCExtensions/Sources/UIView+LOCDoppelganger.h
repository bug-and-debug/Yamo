//
//  UIView+LOCDoppelganger.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LOCDoppelganger)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - doppelganger
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView *)getImageView;
- (UIImage *)getImage;
- (NSData *)getPdf;
- (UIImage *)getBlurredImageWithRadius:(CGFloat)blurRadius;
- (void)getImageAndAddToImageView:(UIImageView *)imageView;
- (void)getImageAndAddToButton:(UIButton *)button;
- (void)getBlurredImageWithRadius:(CGFloat)blurRadius
                andAddToImageView:(UIImageView *)imageView;
- (void)getBlurredImageWithRadius:(CGFloat)blurRadius
                   andAddToButton:(UIButton *)button;

@end
