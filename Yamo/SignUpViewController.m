//
//  SignUpViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 20/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "SignUpViewController.h"
#import "AuthenticationViewController.h"
#import "LOCAppDefinitions.h"
#import "SignupView.h"
#import "APIClient+Authentication.h"
#import "APIClient+User.h"
#import "LOCMacros.h"
#import "LoginHeaderView.h"
#import "LOCCameraViewController.h"
#import "ValidateFormView.h"
#import "PasswordValidator.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIViewController+Network.h"

@import AFNetworking;
@import NSObject_LOCExtensions;
@import UIView_LOCExtensions;
@import UIImagePickerController_LOCExtensions;
@import UIAlertController_LOCExtensions;

NSString * const backgroundSignupView = @"orange-and-yellow";

@interface SignUpViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) SignupView *signupView;
@property (nonatomic, strong) NSDictionary *retainedValues;
@property (nonatomic) BOOL isSigningUp;
@property (nonatomic, strong) NSLayoutConstraint *loginHeaderViewHeightConstraint;
@property (nonatomic, strong) LoginHeaderView *loginHeaderView;
@property (nonatomic, strong) LOCCameraViewController *cameraViewController;
@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIImage *profileImage;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation SignUpViewController
/*

- (instancetype)initWithAuthenticationState:(AuthenticationState)authenticationState
                             retainedValues:(NSDictionary *)retainedValues {
    
    self = [super initWithAuthenticationState:AuthenticationStateSignupEmailPassword retainedValues:retainedValues];
    
    if (self) {
        self.retainedValues = retainedValues;
    }
    
    return self;
}

- (LOCSignupView *)buildSignupView:(NSDictionary *)values {
    
    LOCSignupView *signupView = [LOCSignupView new];
    signupView.translatesAutoresizingMaskIntoConstraints = NO;
    return signupView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!IS_IPHONE_4_OR_LESS) {
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
            [self hideHeaderViewAnimated:YES duration:duration.floatValue];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
            [self showHeaderViewAnimated:YES duration:duration.floatValue];
        }];
    }
 
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UITapGestureRecognizer *tapGestureRecognizerProfilePict = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddProfileImage)];
    tapGestureRecognizerProfilePict.numberOfTapsRequired = 1;
    self.signupView.profileImageView.userInteractionEnabled = YES;
    [self.signupView bringSubviewToFront:self.signupView.profileImageView];
    [self.signupView.profileImageView addGestureRecognizer:tapGestureRecognizerProfilePict];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDidTapSignupView:)];
    [self.signupView addGestureRecognizer:tapGestureRecognizer];
    [self.signupView.loginWithFacebook addTarget:self action:@selector(handleLoginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    [self bigScreen];
}

- (void)bigScreen {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundSignupView]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.bounces = NO;
    [self.scrollContentView insertSubview:self.backgroundImageView atIndex:0];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:self.backgroundImageView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.scrollContentView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0],
                                ]];
}
 
// Hide header and Show header will not be called for devices with screen size iphone 4s or lower
- (void)hideHeaderViewAnimated:(BOOL)animated duration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.loginHeaderViewHeightConstraint.constant = 64;
        self.loginHeaderView.logoImageView.alpha = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)showHeaderViewAnimated:(BOOL)animated duration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.loginHeaderViewHeightConstraint.constant = [self calculateLogoHeight];
        self.loginHeaderView.logoImageView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

- (LOCFormValidationState)validateRuleForValidateForm:(LOCStateView *)view withInput:(NSString *)input entryKey:(NSString *)key {
    if ([key isEqualToString:LOCFormViewPasswordKey]) {
        return [PasswordValidator validatePassword:input];
    }
    else {
        return [super validateRuleForValidateForm:view withInput:input entryKey:key];
    }
}

#pragma mark - UI

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (LOCSignupView *)alternativeViewForSigninState {
    
    self.signupView = [SignupView new];
    
    if (_retainedValues[LOCFormViewEmailKey]) {
        self.signupView.signupFormView.emailTextField.text = @"";
        [self.signupView.signupFormView.emailTextField insertText:_retainedValues[LOCFormViewEmailKey]];
    }
    
    for (UITextField *textField in self.signupView.formTextFields) {
        textField.delegate= self;
    }
    return self.signupView;
}
 

#pragma mark - Override

- (void)signupViewDidPressSignupButton:(UIButton *)button withValues:(NSDictionary *)values {
    
    NSString *firstName = values[LOCFormViewFirstNameKey];
    NSString *lastName = values[LOCFormViewLastNameKey];
    NSString *email = values[LOCFormViewEmailKey];
    NSString *password = values[LOCFormViewPasswordKey];
    
    [self signupWithFirstName:firstName
                     lastName:lastName
                        email:email
                     password:password
                pressedButton:button];
    
}

- (void)signupViewDidPressBackToLoginButton:(UIButton *)button withValues:(NSDictionary *)values {
    
    AuthenticationViewController *parent = (AuthenticationViewController*)self.parentViewController;
    [parent switchToLoginSignup];
    
}

- (void)signupView:(LOCSignupView *)signupView didFailWithErrorReason:(SignupViewErrorReason)reason {
    
    switch (reason) {
        
        case SignupViewErrorReasonNoPhoto: {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Profile Picture", nil)
                                                                                     message:NSLocalizedString(@"A profile picture must be selected in order to sign up.", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
            
        }
        default:
            break;
    }
}


#pragma mark - Login

- (void)loginViewLoginButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
}

#pragma mark - Actions

- (void)handleDidTapSignupView:(id)sender {
    
    [self.view endEditing:YES];
    
}

#pragma mark - API

- (void)signupWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                      email:(NSString *)email
                   password:(NSString *)password
              pressedButton:(UIButton *)pressedButton {
    
    if (!self.isSigningUp) {
        
        [self showIndicator:YES];
        [self enableUIUserInteractionState:NO];
        
        UIImage *profileImage = [self.profileImage isValidObject] ? self.profileImage: [UIImage imageNamed:@"default"];
        NSData *data = UIImageJPEGRepresentation(profileImage, 0.7f);
        NSString *encodedImageString = [data length] > 0 ? [data base64EncodedStringWithOptions:0] : @"";
        
        void (^beforeLoad)() = ^{
            pressedButton.userInteractionEnabled = NO;
            self.isSigningUp = YES;
        };
        
        void (^afterLoad)() = ^{
            pressedButton.userInteractionEnabled = YES;
            self.isSigningUp = NO;
            
            [self showIndicator:NO];
            [self enableUIUserInteractionState:YES];
        };
        
        void (^successBlock)(id element) = ^(id  _Nullable element) {
            
            if ([self.delegate respondsToSelector:@selector(signUpDidFinish:withUsername:andPassword:)]) {
                [self.delegate signUpDidFinish:self withUsername:email andPassword:password];
            }
        };
        
        void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
        ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
            [self handleNetworkError:error statusCode:statusCode];
        };
        
        
        if (self.isPayWallSubscription) {
            
            [[APIClient sharedInstance] userGuestSignupWithFirstName:firstName
                                                            lastName:lastName
                                                               email:email
                                                            password:password
                                                        imageContent:encodedImageString
                                                          beforeLoad:beforeLoad
                                                           afterLoad:afterLoad
                                                        successBlock:successBlock
                                                        failureBlock:failureBlock];
        }
        else {
            
            [[APIClient sharedInstance] authenticationSignupWithFirstName:firstName
                                                                 lastName:lastName
                                                                    email:email
                                                                 password:password
                                                             imageContent:encodedImageString
                                                               beforeLoad:beforeLoad
                                                                afterLoad:afterLoad
                                                             successBlock:successBlock
                                                             failureBlock:failureBlock];
        }
    }
}

- (void)handleLoginWithFacebook {
    
    self.facebookButton.userInteractionEnabled = NO;
    
    [self showIndicator:YES];
    [self enableUIUserInteractionState:NO];
    
    void (^loginBlock)() = ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"email"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if(!error) {
                NSString *fbUserId = [[FBSDKAccessToken currentAccessToken] userID];
                NSString *fbToken =  [[FBSDKAccessToken currentAccessToken] tokenString];
                NSString *fbEmail =  result[@"email"];
                
                [self connectWithFacebookWithFacebookToken:fbToken facebookId:fbUserId emailAddress:fbEmail];
            }
            else {
                NSLog(@"Connect with Facebook error is %@",error.description );
                
                [self showIndicator:NO];
                [self enableUIUserInteractionState:YES];
            }
        }];
    };
    
    if (![[FBSDKAccessToken currentAccessToken] tokenString]) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email", @"public_profile", @"user_birthday", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                loginBlock();
            } else {
                
                [self showIndicator:NO];
                [self enableUIUserInteractionState:YES];
            }
        }];
    } else {
        loginBlock();
    }
}

- (void)connectWithFacebookWithFacebookToken:(NSString *)fbToken
                                  facebookId:(NSString *)facebookId
                                emailAddress:(NSString *)emailAddress {
    void (^afterLoad)() = ^{
        
        [self showIndicator:NO];
        [self enableUIUserInteractionState:YES];
    };
    
    void (^successBlock)(id element) = ^(id  _Nullable element) {
        
        NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];

        if ([self.delegate respondsToSelector:@selector(signUpDidFinish:withUsername:andPassword:)]) {
            [self.delegate signUpDidFinish:self withUsername:emailAddress andPassword:tempPassword];
        }
    };
    
    void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
    ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {NSDictionary *errorDictionary = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] ? error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] : @{};
        
        NSLog(@"Error dictionary: %@", errorDictionary);
        [self handleNetworkError:error statusCode:statusCode];
    };
    
    if (self.isPayWallSubscription) {
        [[APIClient sharedInstance] userConnectWithFacebookWithFacebookToken:fbToken
                                                                  facebookId:facebookId
                                                                       email:emailAddress
                                                                  beforeLoad:nil
                                                                   afterLoad:afterLoad
                                                                successBlock:successBlock
                                                                failureBlock:failureBlock];
    } else {
        [[APIClient sharedInstance] authenticationConnectWithFacebookWithFacebookToken:fbToken
                                                                            facebookId:facebookId
                                                                                 email:emailAddress
                                                                            beforeLoad:nil
                                                                             afterLoad:afterLoad
                                                                          successBlock:successBlock
                                                                          failureBlock:failureBlock];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([[self superclass] instancesRespondToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [super textFieldShouldBeginEditing:textField];
    }
    return YES;
}

#pragma mark - Validation Error Strings

- (NSString *)errorStringForValidateState:(LOCFormValidationState)validState textFieldKey:(NSString *)textFieldKey{
    
    switch (validState) {
        case LOCFormValidationStateInvalidEmail: {
            return NSLocalizedString(@"Invalid Email", nil);
        }
        case LOCFormValidationStateStringTooLong: {
            return NSLocalizedString(@"Input too long", nil);
        }
        case LOCFormValidationStateStringMustHaveInput: {
            return NSLocalizedString(@"Must have input", nil);
        }
        case LOCFormValidationStateStringTooShort: {
            if ([textFieldKey isEqualToString:LOCFormViewPasswordKey]) {
                return NSLocalizedString(@"Password must contain at least 6 characters", nil);
            } else {
                return NSLocalizedString(@"Input too short", nil);
            }
        }
        case LOCFormValidationStateInvalidCharacters: {
            return NSLocalizedString(@"Only A-Z", nil);
        }
        case LOCFormValidationStateValid:
        default: {
            return nil;
        }
    }
}

#pragma mark - Error Handler

- (void)handleNetworkError:(NSError *)error statusCode:(NSInteger)statusCode {
    
    [UIAlertController showAlertInViewController:self
                                       withTitle:NSLocalizedString(@"Error", nil)
                                         message:[self errorMessageForLoginStatusCode:statusCode error:error]
                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil
                                        tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull alertAction, NSInteger index) {
                                            
                                        }];
}

- (NSString *)errorMessageForLoginStatusCode:(NSInteger)statusCode error:(NSError *)error {
    
    switch (statusCode) {
        case 409: // Email has been taken
            return NSLocalizedString(@"This email is already in use", nil);
        case 428: // Invalid entry in text field
            return NSLocalizedString(@"You must fill out all the text fields", nil);
    }
    
    NSDictionary *userInfo = error.userInfo;
    if (userInfo[NSLocalizedDescriptionKey]) {
        return userInfo[NSLocalizedDescriptionKey];
    }
    
    return NSLocalizedString(@"Failed to sign up", nil);
}

#pragma mark - Helpers

- (CGFloat)calculateLogoHeight {
    
    CGFloat screenheight = CGRectGetHeight([UIScreen mainScreen].bounds);
    static CGFloat statusBarHeight = 20;
    static CGFloat expectedFormHeight = 360;
    CGFloat headerHeight = screenheight - expectedFormHeight - 87 - statusBarHeight;
    
    return headerHeight;
}

- (void)handleAddProfileImage {
    
    BOOL hasCamera = [UIImagePickerController hasCamera];
    BOOL hasLibrary = [UIImagePickerController hasLibrary];
    
    if (hasCamera && hasLibrary) {
        
        NSString *title = NSLocalizedString(@"Select Photo from:", nil);
        NSString *cancel = NSLocalizedString(@"Cancel", nil);
        NSString *photoGallery = NSLocalizedString(@"Photo Gallery", nil);
        NSString *camera = NSLocalizedString(@"Camera", nil);
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:photoGallery style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [UIImagePickerController controllerForLibraryWithDelegate:self canEdit:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:camera style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [UIImagePickerController controllerForCameraWithDelegate:self canEdit:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else if (hasCamera) {
        UIImagePickerController *picker = [UIImagePickerController controllerForCameraWithDelegate:self canEdit:NO];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (hasLibrary) {
        UIImagePickerController *picker = [UIImagePickerController controllerForLibraryWithDelegate:self canEdit:NO];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Camera Found.", nil)
                                                                       message:NSLocalizedString(@"Your device does not appear to have a valid camera source", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - AddPhotoViewControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    
    if ([image isKindOfClass:[UIImage class]]) {
        self.signupView.profileImage = image;
        self.signupView.plusImageView.hidden = YES;
        self.profileImage = image;
        
        if (self.profileImage) {
                    [self validateForm:self.signupView
                          withNewEntry:@""
                              entryKey:@""];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UI

- (void)enableUIUserInteractionState:(BOOL)enable {
    
    self.signupView.userInteractionEnabled = enable;
}

#pragma mark - Validation for each entry in the SignUp Form

- (void)validateForm:(LOCStateView *)view withNewEntry:(NSString *)newInput entryKey:(NSString *)key {
    
    LOCFormValidationState valid = LOCFormValidationStateValid;
    
    NSString *keyForInvalid = @"";
    for (UITextField *textField in view.formTextFields) {
        
        valid = [self validateRuleForValidateForm:view withInput:textField.text entryKey:textField.LOCLoginFormKey];
        
        if (valid != LOCFormValidationStateValid ) {
            keyForInvalid = textField.LOCLoginFormKey;
            
            if ([key isEqualToString:keyForInvalid]) {
                valid = [self validateRuleForValidateForm:view withInput:newInput entryKey:key];
            }
            
            if (valid != LOCFormValidationStateValid) {
                break;
            }
        }
        
    }
    
    if (valid == LOCFormValidationStateValid) {
        // validate this new text for key
        valid = [self validateRuleForValidateForm:view withInput:newInput entryKey:key];
    }
    
    // Button
    for (UIButton *validateButton in view.formValidatedButtons) {
        validateButton.enabled = (valid == LOCFormValidationStateValid);
    }
    
}
*/

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"singupview did load");
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

- (IBAction)gotoSignin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoSignup2:(id)sender
{
    if(firstNameTextField.text.length < 1)
    {
        [Utility showToast:@"Please enter your first name" icon:ICON_NONE toView:self.view afterDelay:2];
        [firstNameTextField becomeFirstResponder];
        return;
    }
    if(lastNameTextField.text.length < 1)
    {
        [Utility showToast:@"Please enter your last name" icon:ICON_NONE toView:self.view afterDelay:2];
        [lastNameTextField becomeFirstResponder];
        return;
    }
    
    Signup2ViewController* s = [[Signup2ViewController alloc] initWithNibName:@"Signup2ViewController" bundle:nil];
	s.firstName = firstNameTextField.text;
    s.lastName = lastNameTextField.text;
    [self.navigationController pushViewController:s animated:YES];
}

@end
