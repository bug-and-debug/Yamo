//
//  ExploreMapMarkerContainerView.m
//  Yamo
//
//  Created by Mo on 07/07/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ExploreMapMarkerContainerView.h"

@implementation ExploreMapMarkerContainerView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    for (UIView *view in self.subviews) {
        
        BOOL test = [view pointInside:[self convertPoint:point toView:view] withEvent:event];
       
        if (test) {
            
            return YES;
        }
        
    }
    return NO;
}


/* You may want to use this to debug any missing taps etc.
 
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    UIView *view = touch.view;
}
 */

@end
