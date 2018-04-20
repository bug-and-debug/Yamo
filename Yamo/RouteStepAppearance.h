//
//  RouteStepAppearance.h
//  Yamo
//
//  Created by Peter Su on 01/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteStep.h"

@interface RouteStepAppearance : NSObject

+ (NSString *)stepLetterForStep:(RouteStep *)step;

+ (UIColor *)stepColorForSequence:(RouteStep *)step;

+ (UIColor *)textColorForBackgroundColor:(UIColor *)backgroundColor;

+ (BOOL)prefersDarkContentForColor:(UIColor *)backgroundColor;

@end
