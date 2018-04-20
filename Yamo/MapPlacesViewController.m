//
//  MapPlacesViewController.m
//  Yamo
//
//  Created by Mo Moosa on 28/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MapPlacesViewController.h"
#import "MapPlacesDataController.h"
#import "UIViewController+Title.h"

@interface MapPlacesViewController () <MapPlacesDataControllerDelegate>

@property (nonatomic, strong) MapPlacesDataController *dataController;
@property (nonatomic, copy) NSString *previousSearchText;
@property (nonatomic) id <RoutePlannerInterface> selectedItem;

@end

@implementation MapPlacesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"PlacesViewController" bundle:nil];

    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataController = [[MapPlacesDataController alloc] initWithParentViewController:self
                                                                              tableView:self.aTableView];
    self.dataController.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setupAppearance {
    
    [super setupAppearance];
    
    [self setAttributedTitle:NSLocalizedString(@"Change Location", nil)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                           target:self 
                                                                                           action:@selector(handleDoneButtonTap:)];
}

#pragma mark - Actions

- (void)handleDoneButtonTap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDataControllerWithSearchText:(NSString *)searchText {
    
    [self.dataController updateSearchResultsForString:searchText];
}


- (void)updateDataControllerWithDelayForSearchText:(NSString *)searchText {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(updateDataControllerWithSearchText:)
                                               object:self.previousSearchText];
    
    [self performSelector:@selector(updateDataControllerWithSearchText:) withObject:searchText afterDelay:0.3];
    self.previousSearchText = searchText;
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

#pragma mark - MapPlacesDataControllerDelegate

- (void)placesDataControllerHasContent:(BOOL)hasContent {
    
    // Show / Hide no content view
    [self noContentViewSetVisible:hasContent];
}

- (void)mapPlacesDataController:(MapPlacesDataController *)mapPlacesDataController didSelectLocation:(id<RoutePlannerInterface>)item {
    
    self.selectedItem = item;
    
    if ([self.delegate respondsToSelector:@selector(mapPlacesViewController:didSelectLocation:)] && self.selectedItem) {
        
        [self.delegate mapPlacesViewController:self didSelectLocation:self.selectedItem];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
