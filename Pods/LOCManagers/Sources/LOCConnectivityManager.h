//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, LOCNetworkStatus) {
    LOCNetworkStatusNotReachable = 0,
    LOCNetworkStatusReachableViaWiFi,
    LOCNetworkStatusReachableViaWWAN,
    LOCNetworkStatusUnknown,
};

extern NSString * const LOCConnectivityStatusDidChangeNotification;

@interface LOCConnectivityManager : NSObject
@property (nonatomic, readonly) LOCNetworkStatus previousConnectivityStatus;

#pragma mark - Initialization

+ (LOCConnectivityManager *)sharedInstance;

#pragma mark - Tracking

- (void)startTrackingConnectivity;

- (void)stopTrackingConnectivity;


#pragma mark - Status

- (LOCNetworkStatus) currentConnectivityStatus;

- (BOOL)isConnected;

- (void)showNoConnectivity;

@end
