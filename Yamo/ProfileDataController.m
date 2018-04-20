//
//  MyProfileDataController.m
//  Yamo
//
//  Created by Hungju Lu on 09/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ProfileDataController.h"
#import "APIClient+MyProfile.h"
#import "ScrollingChildTabViewController.h"

@interface ProfileDataController ()

@property (nonatomic, strong) ProfileDTO *cachedProfile;

@end

@implementation ProfileDataController

- (instancetype)initWithChildTabViewControllers:(NSArray *)controllers {
    self = [super init];
    if (self) {
        self.childViewControllers = controllers;
    }
    return self;
}

#pragma mark - Data

- (void)reloadData {
    
    [[APIClient sharedInstance] getUserProfileWithSuccessBlock:^(id  _Nullable element) {
        
        if (![element isKindOfClass:[ProfileDTO class]]) {
            return;
        }
        
        ProfileDTO *profile = (ProfileDTO *)element;
        
        [self setupDataWithProfile:profile];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        NSLog(@"ERROR %@", error);
        
        [self delegateCallBackForError:error statusCode:statusCode context:context endpoint:@"/user/profile"];
    }];
}

- (void)getUserWithID:(NSNumber*)userID {
    
    [[APIClient sharedInstance] getUserProfileWithUserID:userID
                                            successBlock:^(id  _Nullable element) {
       
                                                if (![element isKindOfClass:[ProfileDTO class]]) {
                                                    return;
                                                }
                                                
                                                ProfileDTO *profile = (ProfileDTO *)element;
                                                
                                                [self setupDataWithProfile:profile];
                                                
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        NSLog(@"ERROR %@", error);
        
        [self delegateCallBackForError:error statusCode:statusCode context:context endpoint:@"/user/%@/profile"];
    }];
}

- (void)delegateCallBackForError:(NSError *)error statusCode:(NSInteger)statusCode context:(NSString *)context endpoint:(NSString *)endpoint {
    
    
    NSString *errorMessage = [NSString stringWithFormat:@"Endpoint: %@\nStatus: %ld", endpoint, (long)statusCode];
    if (context && context.length > 0) {
        errorMessage = [NSString stringWithFormat:@"Endpoint: %@\nStatus: %ld\nContext: %@", endpoint, (long)statusCode, context];
    }
    
    if ([self.delegate respondsToSelector:@selector(profileDataControllerDidFailedFetchProfile:)]) {
        [self.delegate profileDataControllerDidFailedFetchProfile:errorMessage];
    }
}

- (void)setupDataWithProfile:(ProfileDTO *)profile {
    
    self.cachedProfile = profile;
    
    if ([self.delegate respondsToSelector:@selector(profileDataControllerDidFetchedProfile:)]) {
        [self.delegate profileDataControllerDidFetchedProfile:profile];
    }
    
    for (ScrollingChildTabViewController *controller in self.childViewControllers) {
        switch (controller.type) {
            case ScrollingChildTabViewTypePlaces:
                [controller reloadWithDataSource:profile.places];
                break;
            case ScrollingChildTabViewTypeVenues:
                [controller reloadWithDataSource:profile.venues];
                break;
            case ScrollingChildTabViewTypeFriendsFollowing:
                [controller reloadWithDataSource:profile.following];
                break;
            case ScrollingChildTabViewTypeFriendsFollowers:
                [controller reloadWithDataSource:profile.followers];
                break;
            case ScrollingChildTabViewTypeRoutes:
                [controller reloadWithDataSource:[profile.routes mutableCopy]];
                break;
            default:
                break;
        }
    }
}

- (void)updateData:(id)data forChildTabType:(ScrollingChildTabViewType)type {
    
    ScrollingChildTabViewController *controllerToUpdate;
    for (ScrollingChildTabViewController *controller in self.childViewControllers) {
        if (controller.type == type) {
            controllerToUpdate = controller;
            break;
        }
    }
    
    if (!controllerToUpdate) {
        return;
    }
    
    switch (controllerToUpdate.type) {
        case ScrollingChildTabViewTypePlaces: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.places mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *dataToUpdate = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:dataToUpdate];
            [newDataSource addObject:data];
            
            self.cachedProfile.places = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeVenues: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.venues mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *dataToUpdate = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:dataToUpdate];
            [newDataSource addObject:data];
            
            self.cachedProfile.venues = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowing: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.following mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *dataToUpdate = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:dataToUpdate];
            [newDataSource addObject:data];
            
            self.cachedProfile.following = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowers:{
            
            NSMutableArray *newDataSource = [self.cachedProfile.followers mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *dataToUpdate = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:dataToUpdate];
            [newDataSource addObject:data];
            
            self.cachedProfile.followers = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeRoutes:{
            
            NSMutableArray *newDataSource = [self.cachedProfile.routes mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *dataToUpdate = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:dataToUpdate];
            [newDataSource addObject:data];
            
            self.cachedProfile.routes = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        default:
            break;
    }
}

- (void)appendData:(id)data forChildTabType:(ScrollingChildTabViewType)type {
    
    ScrollingChildTabViewController *controllerToUpdate;
    for (ScrollingChildTabViewController *controller in self.childViewControllers) {
        if (controller.type == type) {
            controllerToUpdate = controller;
            break;
        }
    }
    
    if (!controllerToUpdate) {
        return;
    }
    
    switch (controllerToUpdate.type) {
        case ScrollingChildTabViewTypePlaces: {
            self.cachedProfile.places = [self.cachedProfile.places arrayByAddingObject:data];
            [controllerToUpdate reloadWithDataSource:self.cachedProfile.places];
            break;
        }
        case ScrollingChildTabViewTypeVenues: {
            self.cachedProfile.venues = [self.cachedProfile.venues arrayByAddingObject:data];
            [controllerToUpdate reloadWithDataSource:self.cachedProfile.venues];
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowing: {
            self.cachedProfile.following = [self.cachedProfile.following arrayByAddingObject:data];
            [controllerToUpdate reloadWithDataSource:self.cachedProfile.following];
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowers:{
            self.cachedProfile.followers = [self.cachedProfile.followers arrayByAddingObject:data];
            [controllerToUpdate reloadWithDataSource:self.cachedProfile.followers];
            break;
        }
        case ScrollingChildTabViewTypeRoutes:{
            self.cachedProfile.routes = [self.cachedProfile.routes arrayByAddingObject:data];
            [controllerToUpdate reloadWithDataSource:self.cachedProfile.routes];
            break;
        }
        default:
            break;
    }
}

- (void)removeData:(id)data forChildTabType:(ScrollingChildTabViewType)type {
    
    ScrollingChildTabViewController *controllerToUpdate;
    for (ScrollingChildTabViewController *controller in self.childViewControllers) {
        if (controller.type == type) {
            controllerToUpdate = controller;
            break;
        }
    }
    
    if (!controllerToUpdate) {
        return;
    }
    
    switch (controllerToUpdate.type) {
        case ScrollingChildTabViewTypePlaces: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.places mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *usersToRemove = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:usersToRemove];
            
            self.cachedProfile.places = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeVenues: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.venues mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *usersToRemove = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:usersToRemove];
            
            self.cachedProfile.venues = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowing: {
            
            NSMutableArray *newDataSource = [self.cachedProfile.following mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *usersToRemove = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:usersToRemove];
            
            self.cachedProfile.following = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeFriendsFollowers:{
            
            NSMutableArray *newDataSource = [self.cachedProfile.followers mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *usersToRemove = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:usersToRemove];
            
            self.cachedProfile.followers = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        case ScrollingChildTabViewTypeRoutes:{
            
            NSMutableArray *newDataSource = [self.cachedProfile.routes mutableCopy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(uuid)), [data uuid]];
            NSArray *usersToRemove = [newDataSource filteredArrayUsingPredicate:predicate];
            [newDataSource removeObjectsInArray:usersToRemove];
            
            self.cachedProfile.routes = newDataSource;
            [controllerToUpdate reloadWithDataSource:newDataSource];
            
            break;
        }
        default:
            break;
    }
}

@end
