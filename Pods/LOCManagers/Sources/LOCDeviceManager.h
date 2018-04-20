//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@import UIKit;

typedef NS_ENUM(NSInteger, LOCDeviceType)  {
    LOCDeviceType_iPhone480,
    LOCDeviceType_iPhone568,
    LOCDeviceType_iPad,
};

/*-----------------------------------------------------------------------------------------------------*/

#define systemVersion_Equals(versionString)              ([[[UIDevice currentDevice] systemVersion] compare:versionString options:NSNumericSearch] == NSOrderedSame)
#define systemVersion_GreaterThan(versionString)         ([[[UIDevice currentDevice] systemVersion] compare:versionString options:NSNumericSearch] == NSOrderedDescending)
#define systemVersion_GreaterOrEqualThan(versionString)  ([[[UIDevice currentDevice] systemVersion] compare:versionString options:NSNumericSearch] != NSOrderedAscending)
#define systemVersion_LessThan(versionString)            ([[[UIDevice currentDevice] systemVersion] compare:versionString options:NSNumericSearch] == NSOrderedAscending)
#define systemVersion_LessOrEqualThan(versionString)     ([[[UIDevice currentDevice] systemVersion] compare:versionString options:NSNumericSearch] != NSOrderedDescending)

/*-----------------------------------------------------------------------------------------------------*/

#define DeviceManager [LODeviceManager sharedInstance]

@interface LOCDeviceManager : NSObject {
    LOCDeviceType deviceType;
}
@property (nonatomic, unsafe_unretained, readonly) BOOL isRetina;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (LOCDeviceManager *)sharedInstance;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isIpad;
-(BOOL)isIphone480;
-(BOOL)isIphone568;

@end
