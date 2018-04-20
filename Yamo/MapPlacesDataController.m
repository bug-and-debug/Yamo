//
//  MapPlacesDataController.m
//  Yamo
//
//  Created by Mo Moosa on 28/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapPlacesDataController.h"
#import "TempPlace.h"

@interface MapPlacesDataController ()

@property (nonatomic) TempPlace *selectedPlace;

@end

@implementation MapPlacesDataController

@synthesize delegate;

- (instancetype)initWithParentViewController:(UIViewController<PlacesDataControllerDelegate> *)viewController
                                   tableView:(UITableView *)tableView {
    
    if (self = [super initWithParentViewController:viewController tableView:tableView]) {
        [self initialSetup];
    }
    return self;
}


- (void)updateSearchResultsForString:(NSString *)string {
    
    [self updateSearchResultsForAddressWithString:string];
}

- (NSInteger)countForTableViewForSection:(NSInteger)section {
    
    if ([self.delegate respondsToSelector:@selector(placesDataControllerHasContent:)]) {
        [self.delegate placesDataControllerHasContent:(self.searchResultsArray.count > 0)];
    }
    
    return self.searchResultsArray.count;
}

- (id<RoutePlannerInterface>)dataForTableViewAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.searchResultsArray[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(mapPlacesDataController:didSelectLocation :)]) {
        
        id<RoutePlannerInterface> item = [self dataForTableViewAtIndexPath:indexPath];
        
        if ([item isKindOfClass:TempPlace.class]) {
            
            if (self.selectedPlace == item) {
                
                self.selectedPlace = nil;
            }
            else {
                
                self.selectedPlace = (TempPlace *)item;
            }

            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            // Persist for recent location if it's a temp place
            if ([self.delegate respondsToSelector:@selector(persistTempPlace:)]) {
                [self.delegate persistTempPlace:(TempPlace *)item];
            }
        }

        [self.delegate mapPlacesDataController:self didSelectLocation:self.selectedPlace];
    }
}

- (BOOL)dataIsCurrentlySelected:(id<RoutePlannerInterface>)data {
    
    if (self.selectedPlace) {
     
        if (self.selectedPlace == data) {
            
            return YES;
        }
    }
    
    return NO;
}


@end
