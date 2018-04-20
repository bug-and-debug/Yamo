//
//  LegalMapView.m
//  Yamo
//
//  Created by Peter Su on 03/08/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LegalMapView.h"

@implementation LegalMapView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // move legal button
    UIView *legalLink = [self attributionView];
    legalLink.frame = CGRectMake(self.frame.size.width - legalLink.frame.size.width - 10,
                                 self.frame.size.height - legalLink.frame.size.height - 10 ,
                                 legalLink.frame.size.width,
                                 legalLink.frame.size.height);
    legalLink.translatesAutoresizingMaskIntoConstraints = YES;
    legalLink.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (UIView*)attributionView {
    Class class = ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) ? [UIImageView class] : [UILabel class];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[class class]]) {
            return subview;
        }
    }
    return nil;
}

@end
