//
//  EditPlaceViewController.m
//  Yamo
//
//  Created by Peter Su on 07/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "EditPlaceViewController.h"
#import "EditPlacesDataController.h"
#import "APIClient+Venue.h"
#import "SavePlaceDTO.h"
#import "TempPlace.h"
#import "NSNumber+Yamo.h"

@import UIAlertController_LOCExtensions;

@interface EditPlaceViewController () <UIToolbarDelegate, EditPlacesDataControllerDelegate>

@property (nonatomic) PlaceType editPlaceType;
@property (nonatomic) SavePlaceDTO *savePlaceDTO;
@property (nonatomic) TempPlace *tempPlace;
@property (nonatomic, strong) EditPlacesDataController *dataController;
@property (nonatomic, copy) NSString *previousSearchText;


@end

@implementation EditPlaceViewController

+ (_Nonnull instancetype)editPlacesViewControllerEditingType:(PlaceType)placeType {
    
    EditPlaceViewController *viewController = [[EditPlaceViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
    viewController.editPlaceType = placeType;
    
    SavePlaceDTO *savePlaceDTO = [SavePlaceDTO new];
    savePlaceDTO.type = placeType;
    viewController.savePlaceDTO = savePlaceDTO;
    
    return viewController;
}

#pragma mark - Override

- (void)setupDataController {
    
    self.dataController = [[EditPlacesDataController alloc] initWithParentViewController:self tableView:self.aTableView];
}

- (void)locationWasUpdated:(CLLocation *)location {
    
    [self.dataController setCurrentLocation:location];
}

- (UIView *)topView {
    
    UIView *placeholderTopView = [UIView new];
//    placeholderTopView.backgroundColor = [UIColor cyanColor];
    placeholderTopView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.delegate = self;
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImage *closeImage = [[UIImage imageNamed:@"IcondarkXdisabled 1 1 1 1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(handleDidPressClose)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIImage *saveImage = [[UIImage imageNamed:@"Icondarktickdisabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithImage:saveImage style:UIBarButtonItemStylePlain target:self action:@selector(handleDidPressSave)];
    
    [toolbar setItems:@[ dismissBarButtonItem, flexSpace, saveBarButtonItem ]];
    
    CGFloat statusBarHeight = 20.0f;
    
    [placeholderTopView addSubview:toolbar];
    [placeholderTopView pinView:toolbar toEdges:LOCPinnedEdgeBottom|LOCPinnedEdgeLeading|LOCPinnedEdgeTrailing];
    [placeholderTopView pinView:toolbar toEdges:LOCPinnedEdgeTop margin:statusBarHeight];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSAttributedString *attributesString = [[NSAttributedString alloc] initWithString:[self stringForCurrentContext]
                                                                           attributes:@{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
                                                                                         NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0]}];
    titleLabel.attributedText = attributesString;
    
    [placeholderTopView addSubview:titleLabel];
    [placeholderTopView pinView:titleLabel toEdges:LOCPinnedEdgeLeading|LOCPinnedEdgeTrailing margin:60];
    [placeholderTopView addConstraint:[NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return placeholderTopView;
}

#pragma mark - Helper

- (void)updateDataControllerWithDelayForSearchText:(NSString *)searchText {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(updateDataControllerWithSearchText:)
                                               object:self.previousSearchText];
    
    [self performSelector:@selector(updateDataControllerWithSearchText:) withObject:searchText afterDelay:0.3];
    self.previousSearchText = searchText;
}

- (void)updateDataControllerWithSearchText:(NSString *)searchText {
    
    [self.dataController updateSearchResultsForAddressWithString:searchText];
}

#pragma mark - Setup

- (NSString *)stringForCurrentContext {
    
    switch (self.editPlaceType) {
        case PlaceTypeHome:
            return [NSLocalizedString(@"Home", nil) lowercaseString];
        case PlaceTypeWork:
            return [NSLocalizedString(@"Work", nil) lowercaseString];
        case PlaceTypeUnspecified:
            return [NSLocalizedString(@"Unspecified", nil) lowercaseString];
    }
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)placesDataControllerHasContent:(BOOL)hasContent {
    
    // Show / Hide no content view
    [self noContentViewSetVisible:hasContent];
}

#pragma mark - Action

- (void)handleDidPressClose {
    
    [self.view endEditing:YES];
    
    if (self.savePlaceDTO.locationName) {
        
        [UIAlertController showAlertInViewController:self
                                           withTitle:nil
                                             message:NSLocalizedString(@"You are about to discard your changes", nil)
                                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle:NSLocalizedString(@"Discard", nil)
                                   otherButtonTitles:nil
                                            tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger index) {
                                                
                                                if (action.style == UIAlertActionStyleDestructive) {
                                                    
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                }
                                            }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleDidPressSave {
    
    if (self.savePlaceDTO.locationName) {
        
        if (self.tempPlace) {
            [self persistTempPlace:self.tempPlace];
        }
        
        [[APIClient sharedInstance] venueSavePlace:self.savePlaceDTO successBlock:^(id  _Nullable element) {
            
            NSLog(@"element: %@", element);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            
            NSLog(@"Failed to save place: %@", context);
        }];
    } else {
        [self showErrorWithTitle:NSLocalizedString(@"Could not save", nil)
                    errorMessage:NSLocalizedString(@"You must select a place", nil)];
    }
}

#pragma mark - Error handling

- (void)showErrorWithTitle:(NSString *)errorTitle errorMessage:(NSString *)errorMessage {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:errorTitle
                                         message:errorMessage
                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *query = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [self updateDataControllerWithDelayForSearchText:query];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self updateDataControllerWithDelayForSearchText:@""];
    
    return YES;
}

#pragma mark - EditPlacesDataControllerDelegate

- (void)editPlacesDataControllerDidSelectPlace:(TempPlace *)tempPlace {
    
    self.tempPlace = tempPlace;
    
    self.savePlaceDTO.locationName = tempPlace.locationName;
    self.savePlaceDTO.latitude = tempPlace.latitude;
    self.savePlaceDTO.longitude = tempPlace.longitude;
}

@end
