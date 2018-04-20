//
//  TextField.m
//  Yamo
//
//  Created by Mo Moosa on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "TextField.h"

@implementation TextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10.0f, 10.0f);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10.0f, 10.0f);
}

@end
