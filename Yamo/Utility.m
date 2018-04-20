//
//  Utility.m
//  Yamo
//
//  Created by Jin on 7/11/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark - Instance
-(id) init
{
    if((self = [super init]))
    {
        
    }
    return self;
}

+ (Utility *)sharedObject
{
    static Utility *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[Utility alloc] init];
    });
    return objUtility;
}

#pragma mark - MBProgress
- (void) showMBProgress:(UIView *)view message:(NSString *)message
{
    mbProgress = [[MBProgressHUD alloc] initWithView:view];
    mbProgress.detailsLabel.text = message;
    [view addSubview:mbProgress];
    [mbProgress showAnimated:YES];
}

- (void) hideMBProgress
{
    if(mbProgress)
        [mbProgress hideAnimated:YES];
}

+ (void) showToast:(NSString *)message icon:(int)icon toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    
    if(icon == ICON_SUCCESS)
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    else if(icon == ICON_FAIL)
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

#pragma mark - NSUserDefault
- (void) setDefaultObject:(NSObject *)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (NSObject*) getDefaultObject:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Validation
+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void) flurryLogEvent:(NSString*)event param:(NSDictionary*)value
{
    [Flurry logEvent:event withParameters:value];
}

- (void) flurryTrackEvent:(NSString*)event
{
    [Flurry logEvent:event];
}

@end
