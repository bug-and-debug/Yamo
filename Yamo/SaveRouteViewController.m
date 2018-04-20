//
//  SaveRouteViewController.m
//  Yamo
//
//  Created by Peter Su on 16/06/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SaveRouteViewController.h"
#import "RouteDTO.h"
#import "Route.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "TextField.h"
#import "APIClient+Venue.h"
#import "LOCMacros.h"
#import "NSNumber+Yamo.h"
#import "UIViewController+Title.h"

@import UIAlertController_LOCExtensions;

static NSInteger RouteNameMaxLength = 255;

@interface SaveRouteViewController () <UIToolbarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (weak, nonatomic) IBOutlet UILabel *toolBarTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet TextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightConstraint;

@property (nonatomic, strong) Route *savedRoute;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentViewConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *whiteshadowImageView;

@end

@implementation SaveRouteViewController

- (instancetype)initWithRoute:(Route *)route {
    
    self = [SaveRouteViewController new];
    
    if (self) {
        _savedRoute = route;
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Save route", nil);
    [self setAttributedTitle:self.title];
    [self setupAppearance];
    [self registerForKeyboardNotifications];
}

- (void)setTitle:(NSString *)title {
    
    [super setTitle:title];
    self.toolBarTitleLabel.text = title;
}

#pragma mark - Setup

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)setupAppearance {
    
    [self setupAppearanceForToolBar];
    [self setupContentView];
    
    // Name Text Field
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.layer.borderColor = [UIColor yamoBorderGray].CGColor;
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.placeholder = NSLocalizedString(@"Enter route name", nil);
    self.nameTextField.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    self.nameTextField.textColor = [UIColor yamoDarkGray];
    
    // Save Button
    NSDictionary *saveAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14],
                                  NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *saveAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Save", nil) attributes:saveAttributes];
    
    [self.saveButton setAttributedTitle:saveAttributedString forState:UIControlStateNormal];
    
    [self.saveButton addTarget:self action:@selector(handleDidPressSaveButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateSaveButtonEnabledForTextString:self.nameTextField.text];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapView)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupAppearanceForToolBar {
    
    self.topToolBar.translucent = NO;
    self.topToolBar.delegate = self;
    
    UIImage *closeImage = [[UIImage imageNamed:@"IcondarkXdisabled 1 1 1 1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(handleDidPressCloseButton)];
    [self.topToolBar setItems:@[closeBarButtonItem]];
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:15.0f],
                                      NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:15.0f],
                                      NSForegroundColorAttributeName: [UIColor blackColor] };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
    
    self.toolBarTitleLabel.attributedText = attributedString;
}

- (void)setupContentView {
    
    NSDictionary *titleAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:19.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:19.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoDimGray] };
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Save route", nil) attributes:titleAttributes];
    self.titleLabel.attributedText = attributedTitle;
    
    NSParagraphStyle *style = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f],
                                  NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0f],
                                  NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                  NSParagraphStyleAttributeName: style };
    NSString *content = NSLocalizedString(@"You can save this route so that it’s easily accessible from your profile if you wish to use it again in the future.", nil);
    NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    self.contentLabel.attributedText = attributedContent;
}

- (void)updateSaveButtonEnabledForTextString:(NSString *)textString {
    
    [self.saveButton setEnabled:textString.length > 0];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    NSNumber *animationDuration = info[UIKeyboardAnimationDurationUserInfoKey];
    
    self.keyboardHeightConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    __weak typeof(self) weakSelf = self;
    
    if (IS_IPHONE_4_OR_LESS) {
        self.topContentViewConstraint.constant = 54;
    }
    
    [UIView animateWithDuration:[animationDuration floatValue]
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }];
  
    
}

- (void)keyboardWillChangeFrame:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *animationDuration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    if (self.keyboardHeightConstraint.constant != kbSize.height) {
        self.keyboardHeightConstraint.constant = kbSize.height;
        [self.view setNeedsUpdateConstraints];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:[animationDuration floatValue]
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                         }];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    if (IS_IPHONE_4_OR_LESS) {
        NSDictionary* info = [notification userInfo];
        NSNumber *animationDuration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        
        [self.view bringSubviewToFront:self.whiteshadowImageView];
        [self.view bringSubviewToFront:self.topToolBar];
        
         self.topContentViewConstraint.constant = -5;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:[animationDuration floatValue] animations:^{
           [weakSelf.view layoutIfNeeded];
        } ];
    }
    
}

#pragma mark - Actions

- (void)handleDidPressSaveButton {
    
    if (self.nameTextField.text.length > 0) {
        
        [self.view endEditing:YES];
        
        RouteDTO *saveRouteDTO = [[RouteDTO alloc] initWithRouteName:self.nameTextField.text
                                                               route:self.savedRoute];
        
        [[APIClient sharedInstance] venueSaveRoute:saveRouteDTO
                                      successBlock:^(id  _Nullable element) {
                                          
                                          if ([element isKindOfClass:Route.class] && [self.delegate respondsToSelector:@selector(saveRouteViewController:didSaveNewRoute:)]) {
                                              
                                              [self.delegate saveRouteViewController:self didSaveNewRoute:element];
                                          }
                                          
                                      } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                          
                                          NSLog(@"failed: %@", context);
                                          
                                          [UIAlertController showAlertInViewController:self
                                                                             withTitle:nil
                                                                               message:NSLocalizedString(@"Failed to save route, please try again", nil)
                                                                     cancelButtonTitle:nil
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                                                              tapBlock:nil];
                                      }];
    }
}

- (void)handleDidPressCloseButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDidTapView {
    
    [self.view endEditing:YES];
}

#pragma mark - UIToolBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *combinedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateSaveButtonEnabledForTextString:combinedString];
    
    return (combinedString.length <= RouteNameMaxLength);
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    textField.text = @"";
    [self updateSaveButtonEnabledForTextString:textField.text];
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}



@end
