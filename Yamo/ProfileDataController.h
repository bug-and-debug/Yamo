//
//  MyProfileDataController.h
//  Yamo
//
//  Created by Hungju Lu on 09/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileDTO.h"
#import "ScrollingChildTabViewController.h"

@protocol ProfileDataControllerDelegate <NSObject>

@optional
- (void)profileDataControllerDidFetchedProfile:(ProfileDTO *)profile;
- (void)profileDataControllerDidFailedFetchProfile:(NSString *)message;

@end

@interface ProfileDataController : NSObject

@property (weak) id<ProfileDataControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *childViewControllers;

- (instancetype)initWithChildTabViewControllers:(NSArray *)controllers;
- (void)reloadData;
- (void)getUserWithID:(NSNumber*)userID;

- (void)updateData:(id)data forChildTabType:(ScrollingChildTabViewType)type;
- (void)appendData:(id)data forChildTabType:(ScrollingChildTabViewType)type;
- (void)removeData:(id)data forChildTabType:(ScrollingChildTabViewType)type;

@end
