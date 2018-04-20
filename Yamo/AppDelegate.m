//
//  AppDelegate.m
//  Yamo
//
//  Created by Vlad Buhaescu on 30/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HockeySDK/HockeySDK.h>
#import "ActivityViewController.h"
#import "Yamo-Swift.h"
#import "MyProfileViewController.h"
#import "CoreDataStore.h"
#import "APIClient+User.h"
#import "UserService.h"
#import "Flurry.h"
#import "FilterDataController.h"
#import "LoginViewController.h"

@import StoreKit;
@import LOCPermissions_Swift;
@import LOCSubscription;
@import GoogleMaps;
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Flurry startSession:@"WTB23J592Y995BVVRBTT"];
    
    
//    FlurrySessionBuilder* builder = [[[[[FlurrySessionBuilder new]
//                                        withLogLevel:FlurryLogLevelAll]
//                                       withCrashReporting:YES]
//                                      withSessionContinueSeconds:10]
//                                     withAppVersion:@"1.1.1"];
//    
//    [Flurry startSession:@"WTB23J592Y995BVVRBTT" withSessionBuilder:builder];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{UserServiceShouldPurgeKeychain: @(YES)}];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BOOL shouldPurgeKeychain = [[NSUserDefaults standardUserDefaults] boolForKey:UserServiceShouldPurgeKeychain];
    
    if (shouldPurgeKeychain) {
        
        [[UserService sharedInstance] purgeCredentials];
    }
    
    [self setupHockeyApp];
    [self removeFilterCacheFiles];
    
    //Google Map
    [GMSServices provideAPIKey:@"AIzaSyAHzE5uTWowuE67C-u1mVTIL1Bm82xRAiA"];
    
    //Firebase
    [FIRApp configure];
    
    // setup in app purchase
    [StoreObserver sharedInstance].delegate = [UserService sharedInstance];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
//    AuthenticationViewController *authVC = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:authVC];
//    self.window.rootViewController = nav;
    
    //hans modified
    
    /*
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
     */
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil]];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataStorePurgeUserDataNotification object:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:[StoreObserver sharedInstance]];
}

- (void)removeFilterCacheFiles {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    NSString *filterSearchPath = [applicationSupportDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", FilterSearchCacheFileName]];
    NSString *filterItemsPath = [applicationSupportDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", FilterItemsCacheFileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:filterSearchPath error:&error];
    [fileManager removeItemAtPath:filterItemsPath error:&error];
    
}

#pragma mark - HockeyApp

- (void)setupHockeyApp {

    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"7536f4cd48354e25b5566c8d042d19c0"];
    [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:YES];
    [[[BITHockeyManager sharedHockeyManager] crashManager] setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[PermissionRequestNotification sharedInstance] application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if !TARGET_IPHONE_SIMULATOR
    NSLog(@"Failed to get token, error: %@", error);
#else
    NSLog(@"Notifications don't work on the simulator");
#endif
}

@end
