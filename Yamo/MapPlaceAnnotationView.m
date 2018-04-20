//
//  MapPlaceAnnotationView.m
//  Yamo
//
//  Created by Peter Su on 06/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapPlaceAnnotationView.h"

@interface MapPlaceAnnotationView ()

@property (retain, nonatomic) UILabel *letterlLabel;
@property (retain, nonatomic) UIView *contentView;

@end

@implementation MapPlaceAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.enabled = YES;
        self.canShowCallout=YES;
        
        self.frame = CGRectMake(0, 0, 20, 20);
        
        self.contentView = [[UIView alloc] initWithFrame:self.frame];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.contentView.layer.cornerRadius = self.contentView.frame.size.height / 2;
        self.contentView.layer.masksToBounds = YES;
        
        [self addSubview:self.contentView];
    }
    
    return self;
}

@end
