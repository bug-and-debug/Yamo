//
//  PlacesViewController.m
//  Yamo
//
//  Created by Peter Su on 13/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlacesViewController.h"
#import "NoContentView.h"
#import "CoreDataStore.h"
#import "TempPlace.h"
#import "UIViewController+Network.h"
#import "UserService.h"
#import "NSNumber+Yamo.h"

@interface PlacesViewController ()

@property (nonatomic, strong) NoContentView *noContentView;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupDataController];
    [self setupKeyboardNotification];
    [self setupLocationPermission];
    
    UIView *placeholderView = [self topView];
    [self.topPlaceholderView addSubview:placeholderView];
    [self.topPlaceholderView pinView:placeholderView];
    
    [self setupAppearance];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    self.tableViewBottomConstraint.constant = 0.0f;
}

#pragma mark - Keyboard

- (void)setupKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)handleKeyboardNotification:(NSNotification *)notification {
    
    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGFloat viewHeight = self.view.bounds.size.height;
    
    if (self.navigationController) {
        
        // If the ForgottenPasswordViewController is embedded in a UINavigationController then we should
        // compare the navigationController's height instead, as the ForgottenPasswordViewController's height
        // will not include the navigation bar.
        
        viewHeight = self.navigationController.view.bounds.size.height;
    }
    
    CGFloat bottomConstraintValue = (keyboardFrame.CGRectValue.origin.y == viewHeight) ? 0.0f : keyboardFrame.CGRectValue.size.height;
    
    self.tableViewBottomConstraint.constant = bottomConstraintValue;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}

- (void)setupAppearance {
    
    [self setupSearchBar];
    [self setupNoContentView];
}

- (void)setupSearchBar {

    self.searchTextField.placeholder = nil;
    self.searchTextField.backgroundColor = [UIColor yamoLightGray];
    self.searchTextField.accessoryImage = [UIImage imageNamed:@"IconDarkSearch"];
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                            NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                            NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", nil) attributes:placeholderAttributes];
}

- (void)setupNoContentView {
    
    self.noContentView = [[NoContentView alloc] initWithWithNoContentType:NoContentViewTypeNotSpecified];
    
    NSDictionary *attributeDictionary = @{ NSFontAttributeName : [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0],
                                           NSKernAttributeName : [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0],
                                           NSForegroundColorAttributeName : [UIColor yamoTextGray] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"No content", nil)
                                                                           attributes:attributeDictionary];
    [self.noContentView setAttributedText:attributedString];
    
    self.noContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.noContentView];
    
    [self.view pinView:self.noContentView toEdge:NSLayoutAttributeTop ofView:self.aTableView edge:NSLayoutAttributeTop withSpacing:0];
    [self.view pinView:self.noContentView toEdge:NSLayoutAttributeLeading ofView:self.aTableView edge:NSLayoutAttributeLeading withSpacing:0];
    [self.view pinView:self.noContentView toEdge:NSLayoutAttributeTrailing ofView:self.aTableView edge:NSLayoutAttributeTrailing withSpacing:0];
    [self.view pinView:self.noContentView toEdge:NSLayoutAttributeBottom ofView:self.aTableView edge:NSLayoutAttributeBottom withSpacing:0];
}

- (void)setupLocationPermission {
    
    if ([PermissionRequestLocation sharedInstance].currentStatus != PermissionRequestStatusSystemPromptAllowed) {
        
        [[PermissionRequestLocation sharedInstance] requestPermissionInViewController:self completion:^(enum PermissionRequestStatus outcome, NSDictionary<NSString *,id> * _Nullable userInfo) {
            
            if (outcome == PermissionRequestStatusSystemPromptAllowed) {
                
                [self setupUserCurrentLocation];
            }
            else {
                
                NSLog(@"Permission denied or restricted or not determined");
            }
        }];
    }
    else {
        
        [self setupUserCurrentLocation];
    }
}

- (void)setupUserCurrentLocation {
    
    [[UserService sharedInstance] currentLocationForUser:^(CLLocation *location, NSError *error) {
        
        [self locationWasUpdated:location];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)sender {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sender.text attributes:attributes];
    
    sender.attributedText = attributedString;
}

#pragma mark - Override

- (void)setupDataController {
    // Override
}

- (UIView *)topView {
    
    UIView *emptyView = [UIView new];
    emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    [emptyView pinHeight:0];
    
    return emptyView;
}

- (void)locationWasUpdated:(CLLocation *)location {
    // Override
}

- (void)noContentViewSetVisible:(BOOL)visible {
    
    self.noContentView.hidden = visible;
}

#pragma mark - PlacesDataControllerDelegate

- (void)placesDataControllerHasContent:(BOOL)hasContent {
    
    [self noContentViewSetVisible:hasContent];
}

- (void)persistTempPlace:(TempPlace *)tempPlace {
    
    NSManagedObjectContext *bmoc = [CoreDataStore sharedInstance].backgroundManagedObjectContext;
    
    NSSortDescriptor *tempPlaceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(uuid))
                                                                              ascending:NO];
    
    [[CoreDataStore sharedInstance] fetchEntriesForEntityName:NSStringFromClass([TempPlace class])
                                                withPredicate:nil
                                              sortDescriptors:@[tempPlaceSortDescriptor]
                                         managedObjectContext:bmoc
                                                 asynchronous:NO
                                                   fetchLimit:1
                                              completionBlock:^(NSArray *results) {
                                                  
                                                  NSInteger newId = 0;
                                                  
                                                  if (results.count > 0) {
                                                      NSManagedObject *resultObject = [results firstObject];
                                                      TempPlace *place = [MTLManagedObjectAdapter modelOfClass:TempPlace.class fromManagedObject:resultObject error:nil];
                                                      
                                                      newId = place.uuid.integerValue + 1;
                                                  }
                                                  
                                                  // Store the store data as now
                                                  tempPlace.uuid = [NSNumber numberWithInteger:newId];
                                                  tempPlace.storeDate = [NSDate date];
                                                  
                                                  
                                                  // Map the Mantle model to Core Data,
                                                  // MTLManagedObjectAdapter will handle the duplication based on the unique key we specified
                                                  [MTLManagedObjectAdapter managedObjectFromModel:tempPlace insertingIntoContext:bmoc error:NULL];
                                                  
                                                  [[CoreDataStore sharedInstance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
                                                      
                                                      if (saved) {
                                                          NSLog(@"tempPlace persisted");
                                                      } else {
                                                          NSLog(@"Error: %@", error.localizedDescription);
                                                      }
                                                  }];
                                              }];
    
    
    
}

- (void)placesDataControllerDidStartFetchingPlaces {
    
    [self showIndicator:YES];
}

- (void)placesDataControllerDidEndFetchingPlaces {
    
    [self showIndicator:NO];
}

@end
