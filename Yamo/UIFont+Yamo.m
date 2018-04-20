//
//  UIFont+Yamo.m
//  Yamo
//
//  Created by Mo Moosa on 18/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "UIFont+Yamo.h"

@implementation UIFont (Yamo)

+ (UIFont *)preferredFontForStyle:(FontStyle)style size:(CGFloat)size {
    
    switch (style) {
            
        case FontStyleGraphikMedium:
            return [UIFont fontWithName:@"Graphik-Medium" size:size];
        
        case FontStyleGraphikRegular:
            return [UIFont fontWithName:@"Graphik-Regular" size:size];
            
        case FontStyleTrianonCaptionExtraLight:
            return [UIFont fontWithName:@"TrianonCaption-ExtraLight" size:size];
            
    }
    
    return [UIFont systemFontOfSize:size];
}

@end
