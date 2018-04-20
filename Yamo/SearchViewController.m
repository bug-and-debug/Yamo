//
//  SearchViewController.m
//  Yamo
//
//  Created by Dario Langella on 04/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SearchViewController.h"
#import "FilterDataController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "APIClient+Venue.h"
#import "UserService.h"
#import "FilterHelper.h"
#import "NSNumber+Yamo.h"
#import "UIViewController+Title.h"
@import LOCSearchBar;
@import UIAlertController_LOCExtensions;

@interface SearchViewController () <UITextFieldDelegate, CLLocationManagerDelegate>

//UIViews
@property (weak, nonatomic) IBOutlet UIView *searchBarView;
@property (weak, nonatomic) IBOutlet UIView *refineResearchView;

//Buttons
@property (weak, nonatomic) IBOutlet UIButton *researchButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

//Label
@property (weak, nonatomic) IBOutlet UILabel *labelTableTitle;

@property (weak, nonatomic) IBOutlet LOCSearchTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@property (nonatomic, strong) FilterDataController *dataController;
@property (nonatomic, strong) NSString *searchText;

@end

@implementation SearchViewController

+ (instancetype)searchViewControllerWithCurrentSearchText:(NSString *)searchText {
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchViewController.searchText = searchText;
    
    return searchViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setting Edges
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupFilterDataController];
    [self setupUI];
    
    [self setAttributedTitle:NSLocalizedString(@"Search", nil)];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoBlack],
                                            NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15],
                                            NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15]};
    self.labelTableTitle.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refine results", nil) attributes:attributes];
    
    if (self.searchText) {
        self.searchTextField.text = self.searchText;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Custom the back button
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icondarkdisabled 2"]
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(handleBackButtonPressed:)]];
    
    [self.dataController reloadData];
}

#pragma mark - UI

- (void)setupFilterDataController {
    
    self.dataController = [[FilterDataController alloc] initWithTableView:self.filterTableView];
    
    // Setup scroll view content edge insets
    UIEdgeInsets edgeInsets = self.filterTableView.contentInset;
    edgeInsets.bottom = 143.0;
    self.filterTableView.contentInset = edgeInsets;
}

- (void)setupUI {
    
    // reset button
    NSDictionary *attributes = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                  NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14],
                                  NSForegroundColorAttributeName: [UIColor yamoDarkGray] };
    NSAttributedString *attributedResetTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Reset filters", nil) attributes:attributes];
    [self.resetButton setAttributedTitle:attributedResetTitle forState:UIControlStateNormal];
    
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                            NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                            NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    
    self.searchTextField.accessoryImage = [UIImage imageNamed:@"LegacyIconlightlistsearch"];
    self.searchTextField.accessoryImagePosition = LOCSearchBarAccessoryImagePositionRight;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeyDone;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", nil) attributes:placeholderAttributes];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.dataController.userChangedFilterItems = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)sender {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],//yamoDarkGray
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sender.text attributes:attributes];
    
    sender.attributedText = attributedString;
}

#pragma mark - Buttons Actions

- (IBAction)searchActionButton:(id)sender {
    
    [self.dataController cacheFilterItems];
    
    FilterSearchDTO *dto = [self.dataController currentFilterSearchDTO];
    dto.search = self.searchTextField.text;
    [FilterHelper cacheFilterSearchDTO:dto];
    
    // Get current location
    [[UserService sharedInstance] currentLocationForUser:^(CLLocation *location, NSError *error) {
        
        dto.latitude = location.coordinate.latitude;
        dto.longitude = location.coordinate.longitude;
        dto.miles = UserServiceDefaultSearchMilesRadius;
        
        if ([self.delegate respondsToSelector:@selector(searchViewController:currentFilter:didModify:)]) {
            [self.delegate searchViewController:self currentFilter:dto didModify:self.dataController.userChangedFilterItems];
        }
        //hans modified
        [[Utility sharedObject] flurryTrackEvent:@"Search"];
        //
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)resetActionButton:(id)sender {
    
    [self.dataController resetFilter];
    
    FilterSearchDTO *dto = [[FilterSearchDTO alloc] init];
    [FilterHelper cacheFilterSearchDTO:dto];
    
    // Get current location
    [[UserService sharedInstance] currentLocationForUser:^(CLLocation *location, NSError *error) {
        
        dto.latitude = location.coordinate.latitude;
        dto.longitude = location.coordinate.longitude;
        dto.miles = UserServiceDefaultSearchMilesRadius;
        
        if ([self.delegate respondsToSelector:@selector(searchViewController:currentFilter:didModify:)]) {
            [self.delegate searchViewController:self currentFilter:dto didModify:self.dataController.userChangedFilterItems];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)handleBackButtonPressed:(id)sender {
    
    if (self.dataController.userChangedFilterItems) {

        [UIAlertController showAlertInViewController:self
                                           withTitle:NSLocalizedString(@"Discard changed", nil)
                                             message:NSLocalizedString(@"Do you want to discard all the changes you made?", nil)
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:NSLocalizedString(@"Discard", nil)
                                   otherButtonTitles:@[NSLocalizedString(@"Keep Editing", nil)]
                                            tapBlock:^(UIAlertController * controller, UIAlertAction * action, NSInteger idx) {
                                               
                                                if (action.style == UIAlertActionStyleDestructive) {
                                                    
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }
                                            }];

    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
