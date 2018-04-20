//
//  ExploreMapCircleStackView.h
//  Annotation
//
//  Created by Simon Lee on 13/06/2016.
//  Copyright © 2016 Simon Lee. All rights reserved.
//

@import UIKit;

@interface ExploreMapCircleStackView : UIView

@property (nonatomic) CGFloat size;
@property (nonatomic, strong) NSArray *colours;
@property (nonatomic) NSUInteger count;

- (void)setSize:(CGFloat)size colours:(NSArray *)colours;

@end
