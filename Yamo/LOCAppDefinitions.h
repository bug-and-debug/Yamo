//
//  LOCAppDefinitions.h
//  Yamo
//
//  Created by Vlad Buhaescu on 19/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#define kAppId @"770299866440328"
#define kHockeyClientKey @""
#define kHockeyDebugKey @""
#define kFacebookSharedSecret @"taMaF7bBT6j3u8JtBns9rQBHVCHfMLTL"
#define kAppStoreUrl [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", kAppId]
#define kAppWebsiteUrl @""
#define kGuestUserSharedSecret @"nVcnbpx2UE65TTb9Er4yCcPjdTHPFAyp"

#pragma mark - OAUTH

static NSString * const OAUTH_CLIENT_SECRET = @"a4PqNmXHP482ZK89";
static NSString * const OAUTH_CLIENT_ID = @"LXUYc4zd2AaBVbEr";

/*
 *  These are used if user tries to call an end point which don't require the
 *  user to have an account and not logged in
 */
static NSString * const NO_AUTH_USERNAME = @"v4p2Qj7EYswDuTSk";
static NSString * const NO_AUTH_PASSWORD = @"ts4aD4uhAJxz5zUX";

#pragma mark - User Defaults

static NSString * const kUserDefaultsOwnUserProfilePictureURL = @"kUserDefaultsOwnUserProfilePictureURL";
static NSString * const kUserDefaultsCachedUserLastUpdated = @"kUserDefaultsCachedUserTypeLastUpdated";