//
//  Created by Danny Bravo a.k.a. Rockstar Developer.
//  Copyright (c) 2014 Locassa Ltd. All rights reserved.
//


#import "LOCConnectivityManager.h"
@import Reachability;

NSString * const LOCConnectivityStatusDidChangeNotification = @"LOCConnectivityStatusDidChangeNotification";

@interface LOCConnectivityManager ()
@property (nonatomic, strong) Reachability *currentConnectivity;
@property (nonatomic, readwrite) LOCNetworkStatus previousConnectivityStatus;
@end


@implementation LOCConnectivityManager


#pragma mark - Initialization

+ (LOCConnectivityManager *)sharedInstance {
    
    static LOCConnectivityManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LOCConnectivityManager new];
    });
    
    return sharedInstance;
}


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.previousConnectivityStatus = LOCNetworkStatusUnknown;
    }
    
    return self;
}


- (void) dealloc {

    [self stopTrackingConnectivity];
}


#pragma mark - Tracking

- (void)startTrackingConnectivity {

    if (!self.currentConnectivity){
        
        self.currentConnectivity = [Reachability reachabilityForInternetConnection];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(connectivityChanged)
                                                     name:kReachabilityChangedNotification
                                                   object:self.currentConnectivity];
        
        [self.currentConnectivity startNotifier];
        [self connectivityChanged];
    }
}


- (void)stopTrackingConnectivity {

    if (self.currentConnectivity) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.currentConnectivity stopNotifier];
        self.currentConnectivity = nil;
    }
}


#pragma mark - Connectivity Status

- (LOCNetworkStatus) currentConnectivityStatus {

    return (LOCNetworkStatus)[self.currentConnectivity currentReachabilityStatus];
}


- (BOOL)isConnected {

    switch (self.currentConnectivityStatus) {
    
        case LOCNetworkStatusReachableViaWiFi:
        case LOCNetworkStatusReachableViaWWAN:
            return YES;

        default:
            return NO;
    }
}


- (void)connectivityChanged {
  
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCConnectivityStatusDidChangeNotification object:nil];
    
    self.previousConnectivityStatus = [self currentConnectivityStatus];
}

- (void)showNoConnectivity
{
    
}


@end
