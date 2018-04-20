//
//  Constant.h
//  Yamo
//
//  Created by Jin on 7/10/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark - COLOR
#define RGBCOLOR(r,g,b)                 [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define COLOR_LINE                      RGBCOLOR(221,221,221)
#define COLOR_GRAY                      RGBCOLOR(238,238,238)
#define COLOR_BLACK                     RGBCOLOR(0,0,0)
#define COLOR_E                         RGBCOLOR(238, 238, 238)

#pragma mark - TABBAR
#define TABBAR_CONTROLLER_ARRAY         @[@"RootViewController",@"FavoritesViewController", @"SettingsViewController"]
#define TABBAR_TITLE_ARRAY              @[@"Exhibitions",@"Favourites", @"Settings"]
#define TABBAR_NORMAL_IMAGE_ARRAY       @[@"icon-home",@"icon-favorites", @"icon-settings"]
#define TABBAR_SEL_IMAGE_ARRAY          @[@"icon-home-sel",@"icon-favorites-sel", @"icon-settings-sel"]
#define TABBAR_TITLE_NORMAL_COLOR       RGBCOLOR(26, 26, 26)
#define TABBAR_TITLE_SEL_COLOR          RGBCOLOR(26, 26, 26)
#define TABBAR_TITLE_FONT_SIZE          12.0

#pragma mark - SCREEN
#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height

#define FLURRY_EMAIL                    @"Email"
#define FLURRY_FB                       @"Facebook"

#define USER_SAVED                      @"user_saved"
#define USER_NAME                       @"user_name"
#define USER_PASSWORD                   @"user_password"
#endif /* Constant_h */
