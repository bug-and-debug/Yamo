//
//  EditPlacesDataController.m
//  Yamo
//
//  Created by Peter Su on 14/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "EditPlacesDataController.h"
#import "YourPlaceTableHeaderView.h"
#import "APIClient+Venue.h"
#import "TempPlace.h"

@interface EditPlacesDataController ()

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) TempPlace *selectedPlace;

@end

@implementation EditPlacesDataController

@dynamic delegate;

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView {
    
    if (self = [super initWithParentViewController:viewController tableView:tableView]) {
        [self initialSetup];
    }
    return self;
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(YourPlaceTableHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(YourPlaceTableHeaderView.class)];
    
    [super setupTableView];
}

#pragma mark - Override

- (void)updateDataSource {
    
    if ([self.delegate respondsToSelector:@selector(placesDataControllerDidStartFetchingPlaces)]) {
        [self.delegate placesDataControllerDidStartFetchingPlaces];
    }
    
    [self loadRecentPlaces];
}

- (BOOL)dataIsCurrentlySelected:(id<RoutePlannerInterface>)data {
    
    if (self.selectedPlace) {
        if ([data coordinate].latitude == self.selectedPlace.latitude &&
            [data coordinate].longitude == self.selectedPlace.longitude) {
            
            return YES;
        }
    }
    return NO;
}

- (NSInteger)countForTableViewForSection:(NSInteger)section {
    
    NSInteger countForTableView = 0;
    NSInteger totalCountForTableView = [self totalNumberOfRowsInAllSections];
    
    if (section == 0) {
        
        if (self.currentUserLocationPlace) {
            countForTableView = self.placesArray.count + 1;
        } else {
            countForTableView = self.placesArray.count;
        }
        
    } else {
        countForTableView = self.searchResultsArray.count;
    }
    
    if ([self.delegate respondsToSelector:@selector(placesDataControllerHasContent:)]) {
        [self.delegate placesDataControllerHasContent:(totalCountForTableView > 0)];
    }
    
    return countForTableView;
}

- (NSInteger)totalNumberOfRowsInAllSections {
    
    NSInteger totalCountForTableView = 0;
    
    if (self.currentUserLocationPlace) {
        totalCountForTableView += self.placesArray.count + 1;
    } else {
        totalCountForTableView += self.placesArray.count;
    }
    
    totalCountForTableView += self.searchResultsArray.count;
    
    return totalCountForTableView;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1f;
    } else {
        return 30.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YourPlaceTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(YourPlaceTableHeaderView.class)];
    
    NSString *sectionTitleString = @"";
    
    if (section == 1) {
        if (self.searchResultsArray.count > 0) {
            sectionTitleString = NSLocalizedString(@"Search results", nil);
        }
    }
    
    [headerView populateWithData:sectionTitleString];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(editPlacesDataControllerDidSelectPlace:)]) {
        
        id<RoutePlannerInterface> item = [self dataForTableViewAtIndexPath:indexPath];
        
        if ([item isKindOfClass:TempPlace.class]) {
            
            self.selectedPlace = (TempPlace *)item;
            [self.delegate editPlacesDataControllerDidSelectPlace:self.selectedPlace];
            
            if (self.currentIndexPath) {
                if (![self.currentIndexPath isEqual: indexPath]) {
                    [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } else {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            self.currentIndexPath = indexPath;
        }
    }
}

@end
