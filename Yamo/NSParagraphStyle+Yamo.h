//
//  NSParagraphStyle+Yamo.h
//  Yamo
//
//  Created by Hungju Lu on 29/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const ParagraphStyleLineHeightMultipleForHeader = 1.2631578947; // From Sketch file (48 / 38)
static CGFloat const ParagraphStyleLineHeightMultipleForText = 1.2857142857; // Form Sketch file (36 / 28)

typedef NS_ENUM(NSUInteger, LineHeightMultipleStyle) {
    LineHeightMultipleStyleForHeader,
    LineHeightMultipleStyleForText
};

@interface NSParagraphStyle (Yamo)

+ (NSParagraphStyle *)preferredParagraphStyleForLineHeightMultipleStyle:(LineHeightMultipleStyle)style;

@end