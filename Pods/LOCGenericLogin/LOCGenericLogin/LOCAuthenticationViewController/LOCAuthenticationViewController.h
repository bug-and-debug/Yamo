//
//  LOCAuthenticationViewController.h
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOCLoginView.h"
#import "LOCSignupView.h"
#import "LOCForgotPasswordView.h"
#import "LOCValidateCodeView.h"

typedef NS_ENUM(NSUInteger, AuthenticationState) {
    AuthenticationStateLoginEmailPassword,
    AuthenticationStateSignupEmailPassword,
    AuthenticationStateValidateCode,
    AuthenticationStateForgotPassword
};

@protocol LOCAuthenticationViewControllerDelegate <NSObject>

@required

- (void)authenticationViewLoginWithEmail:(NSString *)email
                                password:(NSString *)password;
- (void)authenticationViewSignupUserWithValues:(NSDictionary *)dictionary;
- (void)authenticationViewForgotPasswordWithValues:(NSDictionary *)dictionary;
- (void)authenticationViewValidateCodeWithValues:(NSDictionary *)dictionary;

@optional

/*
 *  Your subclass can override this to customise the appearance of the default views.
 *  The exposed default view will have public properties so you can edit the font, placeholders and
 *  text values of the elements inside the view.
 */
- (void)authenticationViewAdditionalConfigurationForLoginView:(LOCLoginView *)view;
- (void)authenticationViewAdditionalConfigurationForSignupView:(LOCSignupView *)view;
- (void)authenticationViewAdditionalConfigurationForForgottenPasswordView:(LOCForgotPasswordView *)view;
- (void)authenticationViewAdditionalConfigurationForValidateCodeView:(LOCValidateCodeView *)view;

/*
 *  Can provide a custom view for a particular state section
 *  View inside here should resolve it's own height
 */
- (LOCLoginView *)alternativeViewForLoginState;
- (LOCSignupView *)alternativeViewForSigninState;
- (LOCForgotPasswordView *)alternativeViewForForgotPasswordState;
- (LOCValidateCodeView *)alternativeViewForValidateCodeState;

/*
 *  This is the method that is called to validate the input for validateForm:withNewEntry:entryKey.
 *  Override this if you want to provide your own validation for keys rather than the default behaviour
 *  [LOCFormView validateInputString:forKey]
 */
- (LOCFormValidationState)validateRuleForValidateForm:(LOCStateView *)view withInput:(NSString *)input entryKey:(NSString *)key;

/*
 *  Can override to provide different behaviour for validation. This will validate the fields inside LOCStateView formTextFields.
 *  If everything is valid, this will enable the buttons in LOCStateView formValidatedButtons. Otherwise, the buttons in LOCStateView
 *  formValidatedButtons will be disabled.
 */
- (void)validateForm:(LOCStateView *)view withNewEntry:(NSString *)newInput entryKey:(NSString *)key;

/*
 *  Optional method which gives you the validation state of a text field when it ends editing.
 *
 */
- (void)authenticationViewActionForValidationState:(LOCFormValidationState)state forTextField:(UITextField *)textField;

/*
 *  Optional method which when the last text field in [formView formTextFields] resigns, it will perform this
 */
- (void)authenticationViewActionForResigningLastTextField:(UITextField *)textField currentFormValues:(NSDictionary *)formValues;

@end

@interface LOCAuthenticationViewController : UIViewController <LOCAuthenticationViewControllerDelegate, UITextFieldDelegate, LOCLoginViewDelegate, LOCSignupViewDelegate, LOCForgotPasswordViewDelegate, LOCValidateCodeViewDelegate>

- (instancetype)initWithRetainedValues:(NSDictionary *)retainedValues;

- (instancetype)initWithAuthenticationState:(AuthenticationState)authenticationState
                             retainedValues:(NSDictionary *)retainedValues;

/*
 *  Can either set currentAuthenticationState to change state OR call changeAuthenticationState and pass retained values
 *  so new view can use the values populate data to it's view.
 */
@property (nonatomic) AuthenticationState currentAuthenticationState;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) UIView *scrollContentView;

- (void)changeAuthenticationState:(AuthenticationState)authenticationState retainedValues:(NSDictionary *)retainedValues;

- (UIView *)headerView;

- (UIView *)footerView;

- (void)setClipParentScrollView:(BOOL)clip;

@end
