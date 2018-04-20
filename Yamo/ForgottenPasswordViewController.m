//
//  ForgottenPasswordViewController.m
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ForgottenPasswordViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "APIClient+Authentication.h"
#import "ChangePasswordViewController.h"
#import "UINavigationBar+Yamo.h"
#import "UIViewController+Network.h"
#import "NSNumber+Yamo.h"
#import "UIViewController+Title.h"
@import NSString_LOCExtensions;
@import UIAlertController_LOCExtensions;

@interface ForgottenPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic) IBOutlet UIButton *sendCodeButton;
@property (nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgottenPasswordViewController

@synthesize onboardingDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setAttributedTitle:NSLocalizedString(@"Forgotten Password", nil)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *header = NSLocalizedString(@"Have you forgotten your password?", nil);
    NSMutableParagraphStyle *headerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    headerParagraphStyle.lineHeightMultiple = ParagraphStyleLineHeightMultipleForHeader;
    NSDictionary *headerAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:19.0],
                                        NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:19.0],
                                        NSForegroundColorAttributeName: [UIColor yamoDimGray],
                                        NSParagraphStyleAttributeName: headerParagraphStyle };
    NSAttributedString *attributedHeader = [[NSAttributedString alloc] initWithString:header attributes:headerAttributes];
    self.headerLabel.attributedText = attributedHeader;
    
    NSString *description = NSLocalizedString(@"Please enter the email which you have registered at Yamo. A verification code will be sent to the entered email address.", nil);
    NSParagraphStyle *descriptionParagraphStyle = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    NSDictionary *descriptionAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0],
                                             NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                             NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                             NSParagraphStyleAttributeName: descriptionParagraphStyle };
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:description attributes:descriptionAttributes];
    self.descriptionLabel.attributedText = attributedDescription;
    
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.layer.borderColor = [[UIColor yamoGray] CGColor];
    
    [[self.navigationController navigationBar] setNavigationBarStyleOpaque];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    // Configure the back button for next screen
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    // Configure the current back button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IcondarkXdisabled"] style:UIBarButtonItemStylePlain target:self action:@selector(handleDismissButtonTap:)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleDismissButtonTap:(id)sender {
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleChangePasswordButtonTap:(id)sender {
    
    if ([self.emailTextField isFirstResponder]) {
        [self.emailTextField resignFirstResponder];
    }
    
    __weak __typeof__(self) weakSelf = self;

    [self showIndicator:YES];
    [self enableUIUserInteraction:NO];
    
    [[APIClient sharedInstance] authenticationRecoverPasswordForEmail:self.emailTextField.text beforeLoad:^{
       
    } afterLoad:^{
        
        [self showIndicator:NO];
        [self enableUIUserInteraction:YES];
    } successBlock:^{
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;

        [UIAlertController showAlertInViewController:strongSelf
                                           withTitle:NSLocalizedString(@"Code Sent", nil)
                                             message:NSLocalizedString(@"Please check your inbox for the verification code.", nil)
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                            tapBlock:^(UIAlertController * controller, UIAlertAction * action, NSInteger idx) {
                                                
                                                ChangePasswordViewController *changePasswordViewController = [ChangePasswordViewController new];
                                                changePasswordViewController.delegate = self;
                                                [self.navigationController pushViewController:changePasswordViewController animated:YES];
                                            }];
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        [UIAlertController showAlertInViewController:strongSelf
                                           withTitle:NSLocalizedString(@"Failed", nil)
                                             message:NSLocalizedString(context, nil)
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                            tapBlock:nil];
    }];
}

- (void)handleNotification:(NSNotification *)notification {
    
    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGFloat viewHeight = self.view.bounds.size.height;
    
    if (self.navigationController) {
        
        // If the ForgottenPasswordViewController is embedded in a UINavigationController then we should
        // compare the navigationController's height instead, as the ForgottenPasswordViewController's height
        // will not include the navigation bar.

        viewHeight = self.navigationController.view.bounds.size.height;
    }
    
    CGFloat bottomConstraintValue = (keyboardFrame.CGRectValue.origin.y == viewHeight) ? 8.0 : keyboardFrame.CGRectValue.size.height + 8.0;
    
    self.bottomConstraint.constant = bottomConstraintValue;

    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.emailTextField) {
        
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        self.sendCodeButton.enabled = [newText isValidEmailAddress];
    }
    
    return YES;
}

#pragma mark - ChangePasswordViewDelegate

- (NSString *)currentEmailForChangingPassword {
    return self.emailTextField.text;
}

- (void)changePasswordViewControllerDidChangePassword:(ChangePasswordViewController *)viewController withUsername:(NSString *)username password:(NSString *)password {
    
    if ([self.delegate respondsToSelector:@selector(forgotPasswordViewControllerDidChangePassword:withUsername:password:)]) {
        [self.delegate forgotPasswordViewControllerDidChangePassword:self withUsername:username password:password];
    }
}

#pragma mark - UI

- (void)enableUIUserInteraction:(BOOL)enable {
    
    self.view.userInteractionEnabled = enable;
}

@end
