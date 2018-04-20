//
//  RouteStepAppearance.m
//  Yamo
//
//  Created by Peter Su on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "RouteStepAppearance.h"
#import "Venue.h"
#import "UIColor+Yamo.h"
@import UIColor_LOCExtensions;

@implementation RouteStepAppearance

+ (NSString *)stepLetterForStep:(RouteStep *)step {
    
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *letterToReturn = @"?";
    NSInteger index = step.sequenceOrder.integerValue;
    
    if (index >= 0 && index <= 25) {
        letterToReturn = [alphabet substringWithRange:NSMakeRange(index, 1)];
    }
    
    return letterToReturn;
}

+ (UIColor *)stepColorForSequence:(RouteStep *)step {
    
    Venue *venue = step.venue;
    
    NSSortDescriptor *orderSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
    NSSortDescriptor *updateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSString *hexStringForColor = @"000000"; // Default to black color
    
    NSArray<Tag *> *sortedTags = [venue.tags sortedArrayUsingDescriptors:@[orderSortDescriptor, updateSortDescriptor]];
    
    for (Tag *tag in sortedTags) {
        
        if (tag.hexColour && tag.hexColour.length > 0) {
            hexStringForColor = tag.hexColour;
            break;
        }
    }
    
    return [[UIColor alloc] initWithHexString:hexStringForColor];
}

/*
 *  http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
 */
+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor {
    
    if ([RouteStepAppearance prefersDarkContentForColor:backgroundColor]) {
        return [UIColor blackColor];
    } else {
        return [UIColor whiteColor];
    }
}

+ (BOOL)prefersDarkContentForColor:(UIColor *)backgroundColor {
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(backgroundColor.CGColor);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB) {
        
        size_t count = CGColorGetNumberOfComponents(backgroundColor.CGColor);
        const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);
        
        CGFloat darknessScore = 0;
        if (count == 2) {
            darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
        } else if (count == 4) {
            darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
        }
        
        // We want to priorize the white color
        // We might need to toggle this value
        if (darknessScore <= 175) {
            return NO;
        } else {
            return YES;
        }
        
    } else {
        
        CGFloat brightnessScore = 0;
        [backgroundColor getWhite:&brightnessScore alpha:0];
        if (brightnessScore <= 0.5) {
            return NO;
        }
        return YES;
    }
}

@end
