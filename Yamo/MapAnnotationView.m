//
//  MapAnnotationView.m
//  mapPlaying
//
//  Created by Dario Langella on 06/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapAnnotationView.h"
#import "MapAnnotationObject.h"


@interface MapAnnotationView ()

@property (retain, nonatomic) UILabel *letterlLabel;
@property (retain, nonatomic) UIView *contentView;


@end

@implementation MapAnnotationView

- (instancetype)initWithAnnotation:(MapAnnotationObject <MKAnnotation> *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
   
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.enabled = YES;
        self.canShowCallout=YES;
        
        self.frame = annotation.pinFrame;
        
        self.contentView = [[UIView alloc] initWithFrame:self.frame];
        self.contentView.backgroundColor = annotation.pinColor;
        self.contentView.layer.cornerRadius = self.contentView.frame.size.height / 2;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = annotation.preferDark ? 1.0f : 0.0f;
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;

        self.letterlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        self.letterlLabel.textAlignment = NSTextAlignmentCenter;
        self.letterlLabel.font = [UIFont systemFontOfSize:20.0f];
        self.letterlLabel.textColor = annotation.preferDark ? [UIColor blackColor] : [UIColor whiteColor];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.letterlLabel];

    }
    
    return self;
}

- (void)setAnnotation:(MapAnnotationObject <MKAnnotation> *)annotation {
    
    [super setAnnotation:annotation];
 
    self.letterlLabel.text= annotation.pinTitle;
    self.letterlLabel.textColor = annotation.preferDark ? [UIColor blackColor] : [UIColor whiteColor];
    
    self.contentView.backgroundColor = annotation.pinColor;
    self.contentView.layer.borderWidth = annotation.preferDark ? 1.0f : 0.0f;
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
