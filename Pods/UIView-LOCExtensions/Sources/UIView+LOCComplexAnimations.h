//
//  UIView+LOCComplexAnimations.h
//  UIView-LOCExtensions
//
//  Created by Hungju Lu on 17/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LOCViewDirection)  {
    LOCViewDirectionUp,
    LOCViewDirectionDown,
    LOCViewDirectionLeft,
    LOCViewDirectionRight,
};

@interface UIView (LOCComplexAnimations)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - complex animations
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deny;
- (void)flipWithView:(UIView *)toView
      usingDirection:(LOCViewDirection)direction
          completion:(void(^)(BOOL finished))completionBlock;
- (void)rotateViewIndefinitely;
- (void)bounceIn;

@end
