//
//  SearchViewController.m
//  Yamo
//
//  Created by Dario Langella on 04/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSearchDTO.h"

@class SearchViewController;

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchViewController:(SearchViewController *)controller currentFilter:(FilterSearchDTO *)filterSearchDTO didModify:(BOOL)didModify;

@end

@interface SearchViewController : UIViewController

+ (instancetype)searchViewControllerWithCurrentSearchText:(NSString *)searchText;
- (IBAction)back:(id)sender;

@property (weak) id<SearchViewControllerDelegate> delegate;

@end
