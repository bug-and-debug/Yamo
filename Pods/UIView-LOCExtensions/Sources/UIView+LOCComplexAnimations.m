//
//  UIView+LOCComplexAnimations.m
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIView+LOCComplexAnimations.h"

@implementation UIView (LOCComplexAnimations)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - complex animations
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deny
{
    [self.layer removeAllAnimations];
    [self shakeHorizontallyNumberOfTimes:5
                           originalFrame:self.frame
                                  isLeft:NO];
}

- (void)flipWithView:(UIView *)toView
      usingDirection:(LOCViewDirection)direction
          completion:(void(^)(BOOL finished))completionBlock
{
    self.layer.doubleSided = NO;
    toView.layer.doubleSided = NO;
    
    toView.hidden = YES;
    toView.frame = self.frame;
    [self.superview insertSubview:toView
                     belowSubview:self];
    
    self.layer.zPosition = self.layer.bounds.size.width / 2;
    toView.layer.zPosition = toView.layer.bounds.size.width / 2;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f/500.0f;
    
    CATransform3D rotation;
    switch (direction) {
        case LOCViewDirectionLeft: {
            rotation = CATransform3DRotate(transform, -0.999 * M_PI, 0.0f, 1.0f, 0.0f);
            break;
        }
        case LOCViewDirectionRight:{
            rotation = CATransform3DRotate(transform, 0.999 * M_PI, 0.0f, 1.0f, 0.0f);
            break;
        }
        case LOCViewDirectionUp:{
            rotation = CATransform3DRotate(transform, -0.999 * M_PI, 1.0f, 0.0f, 0.0f);
            break;
        }
        case LOCViewDirectionDown:{
            rotation = CATransform3DRotate(transform, 0.999 * M_PI, 1.0f, 0.0f, 0.0f);
            break;
        }
        default:
            break;
    }
    
    CATransform3D selfTransform = rotation;
    CATransform3D toViewTransform = CATransform3DInvert(rotation);
    
    toView.layer.transform = toViewTransform;
    self.hidden = NO;
    toView.hidden = NO;
    
    CATransform3D firstToTransform = selfTransform;
    CATransform3D secondToTransform = CATransform3DIdentity;
    
    [UIView animateWithDuration:0.75
                     animations:^(void){
                         self.layer.transform = firstToTransform;
                         toView.layer.transform = secondToTransform;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         toView.hidden = NO;
                         if (completionBlock)
                             completionBlock(finished);
                     }];
}

- (void)bounceIn
{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^(void){
        //Initial
    } completion:^(BOOL fin) {
        [UIView animateWithDuration:0.3 animations:^(void){
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL fin) {
            //Shrink
            [UIView animateWithDuration:0.3 animations:^(void){
                self.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL fin) {
                [UIView animateWithDuration:0.3 animations:^(void){
                    self.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL fin) {
                    [UIView animateWithDuration:0.3 animations:^(void){
                        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }];
            }];
        }];
    }];
    
}

- (void)rotateViewIndefinitely
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 2.0;
    rotation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotation
                      forKey:@"Spin"];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)shakeHorizontallyNumberOfTimes:(int)count
                         originalFrame:(CGRect)frame
                                isLeft:(BOOL)isLeft
{
    int xShift = 0;
    if (count != 0)
    {
        if (isLeft)
        {
            xShift = 5;
        }
        else
        {
            xShift = -5;
        }
    }
    
    CGRect newFrame = frame;
    newFrame.origin.x = frame.origin.x+xShift;
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if (count > 0)
                         {
                             int newCount = count - 1;
                             [self shakeHorizontallyNumberOfTimes:newCount
                                                    originalFrame:frame
                                                           isLeft:!isLeft];
                         }
                     }];
}

@end
