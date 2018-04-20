//
//  NSParagraphStyle+Yamo.m
//  Yamo
//
//  Created by Hungju Lu on 29/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "NSParagraphStyle+Yamo.h"

@implementation NSParagraphStyle (Yamo)

+ (NSParagraphStyle *)preferredParagraphStyleForLineHeightMultipleStyle:(LineHeightMultipleStyle)style {
  
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    switch (style) {
        case LineHeightMultipleStyleForHeader:
            paragraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader;
            break;
            
        case LineHeightMultipleStyleForText:
            paragraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForText;
            break;
            
    }
    
    return paragraphStyle;
}

@end
