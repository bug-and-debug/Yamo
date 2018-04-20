//
//  ExploreMapAnnotationView.m
//  Yamo
//
//  Created by Mo Moosa on 28/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ExploreMapUserAnnotationView.h"
#import "UIColor+Yamo.h"

@implementation ExploreMapUserAnnotationView

- (instancetype)initWithSize:(CGFloat)size {
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, size, size)]) {
        
        self.userView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userView.backgroundColor = [UIColor yamoYellow];
        self.userView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userView.layer.borderWidth = 4.0f;
        self.userView.layer.cornerRadius = size * 0.5f;
        self.userView.frame = self.bounds;
        
        [self addSubview:self.userView];
        
//        self.userView.userInteractionEnabled = NO;
//        self.selectionView.userInteractionEnabled = NO;
        
        self.userView.layer.shadowRadius = 10.0f;
        self.userView.layer.shadowOpacity = 1.0f;
        self.userView.layer.shadowColor = [UIColor yamoYellow].CGColor;
    }
    
    return self;
}

@end
