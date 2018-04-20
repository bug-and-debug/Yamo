//
//  ChangePasswordViewController.m
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSParagraphStyle+Yamo.h"
#import "TextField.h"
#import "APIClient+Authentication.h"
#import "PasswordValidator.h"
#import "UINavigationBar+Yamo.h"
#import "UIViewController+Network.h"
#import "PasswordTextField.h"
#import "NSNumber+Yamo.h"
#import "UIViewController+Title.h"
@import UIAlertController_LOCExtensions;
@import UIColor_LOCExtensions;

static NSInteger NumberOfCharactersForSecretCode = 4;

@interface ChangePasswordViewController () <LOCPasswordTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet TextField *codeTextField;
@property (weak, nonatomic) IBOutlet PasswordTextField *passwordTextField;

@property (nonatomic) BOOL codeValidated;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAttributedTitle:NSLocalizedString(@"Change Password", nil)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *header = NSLocalizedString(@"Have you got your code?", nil);
    NSParagraphStyle *headerParagraphStyle = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForHeader];
    NSDictionary *headerAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleTrianonCaptionExtraLight size:19.0],
                                        NSForegroundColorAttributeName: [UIColor yamoDimGray],
                                        NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:19.0],
                                        NSParagraphStyleAttributeName: headerParagraphStyle };
    NSAttributedString *attributedHeader = [[NSAttributedString alloc] initWithString:header attributes:headerAttributes];
    self.headerLabel.attributedText = attributedHeader;
    
    NSString *description = NSLocalizedString(@"Please type in the code you have received and your new password below.", nil);
    NSParagraphStyle *descriptionParagraphStyle = [NSParagraphStyle preferredParagraphStyleForLineHeightMultipleStyle:LineHeightMultipleStyleForText];
    NSDictionary *descriptionAttributes = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0],
                                             NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                             NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0],
                                             NSParagraphStyleAttributeName: descriptionParagraphStyle };
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:description attributes:descriptionAttributes];
    self.descriptionLabel.attributedText = attributedDescription;
    
    self.codeTextField.layer.borderWidth = 1.0f;
    self.codeTextField.layer.borderColor = [[UIColor yamoGray] CGColor];
    self.codeTextField.delegate = self;
    
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor = [[UIColor yamoGray] CGColor];
    
    NSDictionary *descriptionAttributesPasswordTextField = @{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0],
                                                              NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14.0] };
    NSAttributedString *attributedDescriptionPasswordTextField = [[NSAttributedString alloc] initWithString:@"New password (at least 8 characters)" attributes:descriptionAttributesPasswordTextField];
    
    self.passwordTextField.attributedPlaceholder = attributedDescriptionPasswordTextField;
    self.passwordTextField.placeholderColor = [UIColor yamoTextLightGray];
    self.passwordTextField.delegate = self;
    
    NSMutableAttributedString *attributedResendTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Didn't receive your code? Send again", nil)
                                                                                              attributes:@{ NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0],
                                                                                                            NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:12.0],
                                                                                                            NSForegroundColorAttributeName: [UIColor yamoDarkGray] }];
    [attributedResendTitle addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(26, 10)];
    [self.resendCodeButton setAttributedTitle:attributedResendTitle forState:UIControlStateNormal];
    
    // If the ChangePasswordViewController is embedded in a UINavigationController,
    // we need to make sure the style matches the app
    [[self.navigationController navigationBar] setNavigationBarStyleOpaque];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleNotification:(NSNotification *)notification {
    
    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGFloat viewHeight = self.view.bounds.size.height;
    
    if (self.navigationController) {
        
        // If the ChangePasswordViewController is embedded in a UINavigationController then we should
        // compare the navigationController's height instead, as the ChangePasswordViewController height
        // will not include the navigation bar.
        
        viewHeight = self.navigationController.view.bounds.size.height;
    }
    
    CGFloat bottomConstraintValue = (keyboardFrame.CGRectValue.origin.y == viewHeight) ? 8.0 : keyboardFrame.CGRectValue.size.height + 8.0;
    
    self.bottomConstraint.constant = bottomConstraintValue;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)handleTextDidChanged:(id)sender {
    [self updateDoneButtonStatus:self.codeValidated password:self.passwordTextField.text];
}

- (IBAction)handleResendCodeButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    self.codeTextField.text = @"";
    [self resendCode];
}

- (IBAction)handleDoneButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    __weak __typeof__(self) weakSelf = self;
    
    NSString *email = [self.delegate currentEmailForChangingPassword];
    
    [[APIClient sharedInstance] authenticationResetPasswordForEmail:email
                                                        newPassword:self.passwordTextField.text
                                                         secretCode:self.codeTextField.text
                                                         beforeLoad:^{
                                                             
                                                             [self showIndicator:YES];
                                                             [self enableUIUserInteraction:NO];
                                                         } afterLoad:^{
                                                             
                                                             [self showIndicator:NO];
                                                             [self enableUIUserInteraction:YES];
                                                         } successBlock:^{
                                                             
                                                             __strong __typeof__(weakSelf) strongSelf = weakSelf;
                                                             
                                                             if ([strongSelf.delegate respondsToSelector:@selector(changePasswordViewControllerDidChangePassword:withUsername:password:)]) {
                                                                 [strongSelf.delegate changePasswordViewControllerDidChangePassword:strongSelf withUsername:email password:self.passwordTextField.text];
                                                             }
                                                             
                                                         } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                                             
                                                             NSString *message = (statusCode == 404) ? @"Invalid code entered" : @"Failed to change password";
                                                             [UIAlertController showAlertInViewController:self
                                                                                                withTitle:@"Failed"
                                                                                                  message:message
                                                                                        cancelButtonTitle:@"OK"
                                                                                   destructiveButtonTitle:nil
                                                                                        otherButtonTitles:nil
                                                                                                 tapBlock:nil];
                                                         }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.codeTextField) {
        
        if (textField.text.length == NumberOfCharactersForSecretCode && !self.codeValidated) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else {
            textField.clearButtonMode = UITextFieldViewModeNever;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * combinedString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.codeTextField) {
        
        BOOL shouldChange = NO;
        
        if (combinedString.length < NumberOfCharactersForSecretCode) {
            shouldChange = YES;
        }
        else if (combinedString.length == NumberOfCharactersForSecretCode && string.length == 0) {
            shouldChange = YES;
        }
        else if (combinedString.length == NumberOfCharactersForSecretCode && string.length == 1) {
            textField.text = combinedString;
            [self.passwordTextField becomeFirstResponder];
            [self validateCode:combinedString];
            shouldChange = NO;
        }
        else {
            shouldChange = NO;
        }
        
        if (shouldChange) {
            self.codeTextField.textColor = [UIColor yamoDarkGray];
        }
        
        return shouldChange;
    }
    else if (textField == self.passwordTextField) {
        
        [self updateDoneButtonStatus:self.codeValidated password:combinedString];
    }
    
    return YES;
}

#pragma mark - Validation

- (void)updateDoneButtonStatus:(BOOL)codeValidated password:(NSString *)passwordString {
    self.doneButton.enabled = (codeValidated && [PasswordValidator validatePassword:passwordString] == LOCFormValidationStateValid);
}

#pragma mark - LOCPasswordTextFieldDelegate

- (BOOL)passwordTextField:(UITextField<LOCPasswordTextFieldProtocol> *)passwordTextField shouldToggleSecureEntryMode:(BOOL)secureEntryMode {
    
    if ([passwordTextField conformsToProtocol:@protocol(LOCPasswordTextFieldProtocol)]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Services

- (void)resendCode {
    
    __weak __typeof__(self) weakSelf = self;
    
    NSString *email = [self.delegate currentEmailForChangingPassword];
    
    if (email) {
        
        [[APIClient sharedInstance] authenticationRecoverPasswordForEmail:email beforeLoad:^{
            
            [self showIndicator:YES];
            [self enableUIUserInteraction:NO];
        } afterLoad:^{
            
            [self showIndicator:NO];
            [self enableUIUserInteraction:YES];
        } successBlock:^{
            
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            [UIAlertController showAlertInViewController:strongSelf
                                               withTitle:NSLocalizedString(@"Code Sent", nil)
                                                 message:NSLocalizedString(@"Your code has resent, please check your inbox for the verification code.", nil)
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                                tapBlock:nil];
            
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            
            NSLog(@"Send Code Failed");
        }];
    }
    else {
        
        [UIAlertController showAlertInViewController:self
                                           withTitle:NSLocalizedString(@"No Email found", nil)
                                             message:NSLocalizedString(@"Could not found the email from previous screen, please go back and try again.", nil)
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                            tapBlock:nil];
    }
}

- (void)validateCode:(NSString *)secretCode {
    
    __weak __typeof__(self) weakSelf = self;
    
    NSString *email = [self.delegate currentEmailForChangingPassword];
    
    if (email) {
        
        [[APIClient sharedInstance] authenticationValidateRecoverPasswordCodeForEmail:email secretCode:secretCode beforeLoad:^{
            
            [self showIndicator:YES];
            [self enableUIUserInteraction:NO];
        } afterLoad:^{
            
            [self showIndicator:NO];
            [self enableUIUserInteraction:YES];
        } successBlock:^{
            
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            strongSelf.codeValidated = YES;
            [strongSelf updateDoneButtonStatus:self.codeValidated password:self.passwordTextField.text];
            
        } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            // Change the text to colour red
            strongSelf.codeTextField.textColor = [[UIColor alloc] initWithHexString:@"#F02828"];
            strongSelf.codeTextField.clearButtonMode = UITextFieldViewModeAlways;
            strongSelf.codeValidated = NO;
        }];
    }
    else {
        
        [UIAlertController showAlertInViewController:self
                                           withTitle:NSLocalizedString(@"No Email found", nil)
                                             message:NSLocalizedString(@"Could not found the email from previous screen, please go back and try again.", nil)
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@[NSLocalizedString(@"Ok", nil)]
                                            tapBlock:nil];
    }
}

#pragma mark - UI

- (void)enableUIUserInteraction:(BOOL)enable {
    
    self.view.userInteractionEnabled = enable;
}

@end
