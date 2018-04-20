//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "LOCDeviceManager.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation LOCDeviceManager
@synthesize isRetina;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (LOCDeviceManager *)sharedInstance
{
    static LOCDeviceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LOCDeviceManager alloc] init];
    });
    return sharedInstance;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - lifecycle
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self)
    {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (screenHeight == 568)
        {
            deviceType = LOCDeviceType_iPhone568;
        }
        else if (screenHeight == 480)
        {
            deviceType = LOCDeviceType_iPhone480;
        }
        else
        {
            deviceType = LOCDeviceType_iPad;
        }
        isRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isIpad
{
    return deviceType == LOCDeviceType_iPad;
}

-(BOOL)isIphone480
{
    return deviceType == LOCDeviceType_iPhone480;
}

- (BOOL)isIphone568
{
    return deviceType == LOCDeviceType_iPhone568;
}

@end
