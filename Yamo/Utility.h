//
//  Utility.h
//  Yamo
//
//  Created by Jin on 7/11/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Flurry.h"

#define ICON_NONE         0
#define ICON_SUCCESS      1
#define ICON_FAIL         2


@interface Utility : NSObject
{
    MBProgressHUD *mbProgress;
}

- (id) init;
+ (Utility *)sharedObject;

- (void) showMBProgress:(UIView *)view message:(NSString *)message;
- (void) hideMBProgress;
+ (void) showToast:(NSString *)message icon:(int)icon toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

- (void) setDefaultObject:(NSObject *)object forKey:(NSString *)key;
- (NSObject*) getDefaultObject:(NSString*)key;

+(BOOL) isValidEmail:(NSString *)checkString;
- (void) flurryLogEvent:(NSString*)event param:(NSDictionary*)value;
- (void) flurryTrackEvent:(NSString*)event;
@end
