//
//  ExploreMapAnnotationView.h
//  Annotation
//
//  Created by Simon Lee on 16/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

@import UIKit;
#import "ExploreMapAnnotation.h"

@class ExploreMapCircleStackView;

@interface ExploreMapAnnotationView : UIView {
    ExploreMapCircleStackView *stackView;
    UIView *selectionView;
    UIView *contentView;
    CGFloat viewSize;
}

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, weak) id<ExploreMapAnnotation> annotation;
@property (nonatomic) NSUInteger count;
@property (nonatomic, readonly) BOOL clustered;
@property (nonatomic) NSArray *colours;
@property (nonatomic) BOOL shouldBaseSizeOnRelevance;

- (instancetype)initWithAnnotation:(id<ExploreMapAnnotation>)anAnnotation shouldResizeBasedOnRelevance:(BOOL)shouldResizeBasedOnRelevance;
- (void)repareForReuse;
- (void)clusterWithAnnotationView:(ExploreMapAnnotationView *)anAnnotationView animated:(BOOL)animated;
- (void)unClusterAnimated:(BOOL)animated;

@end
