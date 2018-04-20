//
//  ExploreMapAnnotationView.m
//  Annotation
//
//  Created by Simon Lee on 16/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

#import "ExploreMapAnnotationView.h"
#import "ExploreMapCircleStackView.h"

@implementation ExploreMapAnnotationView

@synthesize selected;
@synthesize annotation;
@synthesize clustered;
@synthesize count;
@synthesize colours;

#define kSelectionWidth 15.0
#define kBaseSize 60.0

//#define kSelectionWidth 20.0
//#define kBaseSize 75.0

- (instancetype)initWithAnnotation:(id<ExploreMapAnnotation>)anAnnotation shouldResizeBasedOnRelevance:(BOOL)shouldResizeBasedOnRelevance {
    self.shouldBaseSizeOnRelevance = shouldResizeBasedOnRelevance;
    
    viewSize = [self sizeForAnnotation:anAnnotation];
    
    self = [super initWithFrame:CGRectMake(0, 0, viewSize, viewSize)];
    
    if(self != nil) {
        
        annotation = anAnnotation;
        
        contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        
        CGRect selectionFrame = CGRectInset(self.bounds, -kSelectionWidth, -kSelectionWidth);
        selectionView = [[UIView alloc] initWithFrame:selectionFrame];
        selectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        selectionView.layer.cornerRadius = selectionFrame.size.width * 0.5;
        [contentView addSubview:selectionView];
        [self hideSelection];
    
        stackView = [[ExploreMapCircleStackView alloc] init];
        [stackView setSize:self.bounds.size.width];
        [stackView setColours:anAnnotation.colors];
        [stackView setCount:1];
        [contentView addSubview:stackView];
        
        self.clipsToBounds = FALSE;
        
        contentView.userInteractionEnabled = FALSE;
        selectionView.userInteractionEnabled = FALSE;
        stackView.userInteractionEnabled = FALSE;
        
        [self repareForReuse];
        
        self.frame = CGRectMake(0, 0, viewSize, viewSize);

    }
    
    return self;
}


- (NSUInteger)count {
    return stackView.count;
}

- (void)setCount:(NSUInteger)aCount {
    stackView.count = aCount;
}

- (NSArray *)colours {
    return stackView.colours;
}

- (void)setColours:(NSArray *)someColours {
    stackView.colours = someColours;
}

- (void)clusterWithAnnotationView:(ExploreMapAnnotationView *)anAnnotationView animated:(BOOL)animated {
    if(clustered) {
        return;
    }
    
    clustered = TRUE;
    [self setUserInteractionEnabled:FALSE];
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        stackView.center = [self convertPoint:anAnnotationView.center fromView:anAnnotationView.superview];
        stackView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        stackView.alpha = 0.0;
        
        if(selected) {
            [self hideSelection];
        }
    }];
}

- (void)unClusterAnimated:(BOOL)animated {
    if(!clustered) {
        return;
    }
    
    clustered = FALSE;
    [self setUserInteractionEnabled:TRUE];
    
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        [self resetStackPosition];
    }];
}

- (void)resetStackPosition {
    stackView.transform = CGAffineTransformIdentity;
    stackView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    stackView.alpha = 1.0;
    selectionView.center = stackView.center;
}

- (void)repareForReuse {
    [stackView setCount:1];
    [self resetStackPosition];
    [self setUserInteractionEnabled:TRUE];
    clustered = FALSE;
}

- (CGFloat)sizeForAnnotation:(id<ExploreMapAnnotation>)anAnnotation{

    CGFloat const baseSize = kBaseSize;
        
    if (self.shouldBaseSizeOnRelevance) {
        
        return baseSize + ((anAnnotation.mapRelevance / 100) * baseSize);
    }
    else {
        
        return baseSize;
    }
}

- (void)setAnnotation:(id<ExploreMapAnnotation>)anAnnotation {
    annotation = anAnnotation;
    CGFloat size = [self sizeForAnnotation:anAnnotation];
    CGRect frame = self.frame;
    frame.size.width = size;
    frame.size.height = size;
    [self setFrame:frame];
    
    [stackView setSize:size colours:anAnnotation.colors];
    selectionView.frame = self.bounds;
}

#pragma mark -
#pragma mark Selection Methods

- (void)setSelected:(BOOL)aValue {
    if(selected == aValue) {
        return;
    }
    
    selected = aValue;
    
    CGRect selectionFrame = CGRectMake(-kSelectionWidth, -kSelectionWidth, viewSize + 2 * kSelectionWidth, viewSize + 2 * kSelectionWidth);
    
    CGFloat scale = selectionView.transform.a;
    selectionView.frame = CGRectMake(0, 0, selectionFrame.size.height * scale, selectionFrame.size.width * scale);
    selectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    selectionView.layer.cornerRadius = selectionFrame.size.width * 0.5;
    selectionView.center = stackView.center;
    
    if(selected) {
        self.frame = CGRectMake(0, 0, viewSize + 2 * kSelectionWidth, viewSize + 2 * kSelectionWidth);
        contentView.center = CGPointMake(contentView.center.x + kSelectionWidth, contentView.center.y + kSelectionWidth);
        
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
            selectionView.alpha = 1.0;
            selectionView.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        self.frame = CGRectMake(0, 0, viewSize, viewSize);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self hideSelection];
        }];
    }
    
}

- (void)hideSelection {
    selectionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    selectionView.alpha = 0.0;
}

@end
