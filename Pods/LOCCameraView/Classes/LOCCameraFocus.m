//
//  LOCCameraFocus.m
//  LOCCameraView
//
//  Created by Peter Su on 15/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCameraFocus.h"

@interface LOCCameraFocus ()

@end

@implementation LOCCameraFocus

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    
    CGContextSetLineWidth(context, self.strokeWidth);
    
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    
    CGContextAddLineToPoint(context, 0.0f, self.guideLength);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.bounds) - self.guideLength);
    
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds));
    
    CGContextAddLineToPoint(context, self.guideLength, CGRectGetHeight(self.bounds));
    
    CGContextMoveToPoint(context, CGRectGetWidth(self.bounds) - self.guideLength, CGRectGetHeight(self.bounds));
    
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.guideLength);
    
    CGContextMoveToPoint(context, CGRectGetWidth(self.bounds), self.guideLength);
    
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), 0.0f);
    
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) - self.guideLength, 0.0f);
    
    CGContextMoveToPoint(context, self.guideLength, 0.0f);
    
    CGContextAddLineToPoint(context, 0.0f, 0.0f);
    
    CGContextStrokePath(context);
}

@end
