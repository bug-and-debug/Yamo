//
//  ExploreMapCircleStackView.m
//  Annotation
//
//  Created by Simon Lee on 13/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

#import "ExploreMapCircleStackView.h"
#import "UIColor+Tools.h"

@implementation ExploreMapCircleStackView

@synthesize size;
@synthesize colours;
@synthesize count;

#define kEndFactor          0.9

#define kShadowFactor       0.85
#define kShadowSize         2
#define kShadowRadius       7
#define kShadowOffset       5
#define kShadowOpacity      0.2

#define kCentreDotSize      12
#define kCentreClusterSize  28
#define kCentreColour       @"dfdfdf"
#define kCentreTextColour   @"333333"
#define kCentreFont         [UIFont boldSystemFontOfSize:10.0]

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if(self != nil) {
        self.userInteractionEnabled = FALSE;
        self.opaque = FALSE;
        self.clipsToBounds = FALSE;
        //self.layer.shadowColor = [UIColor blackColor].CGColor;
        //self.layer.shadowOffset = CGSizeMake(0, kShadowOffset);
        //self.layer.shadowRadius = kShadowRadius;
        //self.layer.shadowOpacity = kShadowOpacity;
        self.layer.shouldRasterize = TRUE;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)aFrame {
    @throw nil;
    return [super initWithFrame:aFrame];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    @throw nil;
    return [super initWithCoder:aDecoder];
}

#pragma mark -
#pragma mark Properties

- (void)setSize:(CGFloat)aSize colours:(NSArray *)someColours {
    size = aSize;
    [self setFrame:CGRectMake(0, 0, aSize, aSize)];
    colours = someColours;
    [self setNeedsDisplay];
}

- (void)setSize:(CGFloat)aSize {
    if(size == aSize) {
        return;
    }
    
    [self setSize:aSize colours:colours];
}

- (void)setColours:(NSArray *)someColours {
    colours = someColours;
    [self setNeedsDisplay];
}

- (void)setCount:(NSUInteger)aCount {
    if(count == aCount) {
        return;
    }
    
    count = aCount;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Drawing Methods

- (void)drawRect:(CGRect)rect {
    CGFloat centreSize = count > 1 ? kCentreClusterSize : kCentreDotSize;
    CGFloat offset = 0;
    CGFloat increment = round(((rect.size.width - centreSize) * 0.5) / colours.count);
    
    for(UIColor *colour in colours) {
        [self drawCircle:CGRectInset(rect, offset, offset) colour:colour];
        offset += increment;
    }
    
    UIColor *centreColor = [UIColor colorWithHexString:kCentreColour];
    CGRect centreRect = CGRectInset(rect, ((rect.size.width - centreSize) * 0.5), ((rect.size.height - centreSize) * 0.5));
    [self drawCircle:centreRect colour:centreColor shade:FALSE];
    
    if(count > 1) {
        NSString *labelText = [NSString stringWithFormat:@"%lu", (unsigned long)self.count];
        CGSize textSize = [labelText sizeWithAttributes:@{ NSFontAttributeName : kCentreFont }];
        
        if (textSize.width < rect.size.width) {
            CGRect r = CGRectMake(rect.origin.x,
                                  rect.origin.y + (rect.size.height - textSize.height)/2,
                                  rect.size.width,
                                  (rect.size.height - textSize.height)/2);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{ NSFontAttributeName: kCentreFont,
                                          NSParagraphStyleAttributeName: paragraphStyle,
                                          NSForegroundColorAttributeName: [UIColor colorWithHexString:kCentreTextColour] };
            [labelText drawInRect:r withAttributes:attributes];
        }
    }
}

- (void)drawCircle:(CGRect)aRect colour:(UIColor *)aColour {
    [self drawCircle:aRect colour:aColour shade:TRUE];
}

- (void)drawCircle:(CGRect)aRect colour:(UIColor *)aColour shade:(BOOL)shade {
    UIColor *endColour = shade ? [aColour adjustColour:kEndFactor] : aColour;
    UIColor *shadowColour = shade ? [aColour adjustColour:kShadowFactor] : aColour;
    
    CFArrayRef gradientColours = (__bridge CFArrayRef)@[(id)aColour.CGColor, (id)aColour.CGColor, (id)endColour.CGColor];
    
    aRect = CGRectInset(aRect, kShadowSize + 1, kShadowSize + 1);
    CGRect shadowRect = CGRectOffset(aRect, 0, kShadowSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(shade) {
        CGContextAddEllipseInRect(context, shadowRect);
        CGContextSetFillColor(context, CGColorGetComponents(shadowColour.CGColor));
        CGContextFillPath(context);
    }
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, gradientColours, NULL);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, aRect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(aRect), CGRectGetMinY(aRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(aRect), CGRectGetMaxY(aRect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
}

@end
