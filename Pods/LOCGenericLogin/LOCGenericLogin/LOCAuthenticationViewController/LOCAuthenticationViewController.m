
//
//  LOCAuthenticationViewController.m
//  GenericLogin
//
//  Created by Peter Su on 22/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCAuthenticationViewController.h"

@interface LOCAuthenticationViewController()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *scrollContentView;
@property (nonatomic, strong) NSLayoutConstraint *scrollContentViewWidth;

@property (nonatomic, strong) LOCLoginView *loginView;
@property (nonatomic, strong) LOCSignupView *signupView;
@property (nonatomic, strong) LOCForgotPasswordView *forgotPasswordView;
@property (nonatomic, strong) LOCValidateCodeView *validateCodeView;
@property (nonatomic, strong) NSLayoutConstraint *keyboardPaddingHeightConstraint;

@property (nonatomic, strong) UITextField *currentTextField;

@property (nonatomic, strong) UIView *headerContainerView;

@property (nonatomic, strong) UIView *footerContainerView;

@end

@implementation LOCAuthenticationViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeText)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollContentViewWidth.constant = CGRectGetWidth(self.view.frame);
}

- (instancetype)initWithRetainedValues:(NSDictionary *)retainedValues {
    
    return [self initWithAuthenticationState:AuthenticationStateLoginEmailPassword retainedValues:retainedValues];
}

- (instancetype)initWithAuthenticationState:(AuthenticationState)authenticationState
                             retainedValues:(NSDictionary *)retainedValues {
    
    if (self = [super init]) {
        _currentAuthenticationState = authenticationState;
    }
    
    return self;
}

- (void)setClipParentScrollView:(BOOL)clip {
    
    self.scrollView.clipsToBounds = clip;
}

#pragma mark - Keyboard notifications

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    NSNumber *animationDuration = info[UIKeyboardAnimationDurationUserInfoKey];
    
    self.keyboardPaddingHeightConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.footerContainerView.alpha = 1.0f;
    [UIView animateWithDuration:[animationDuration floatValue]
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                         
                     }];
}

- (void)keyboardWillChangeFrame:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *animationDuration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat expectedHeight = (kbSize.height - CGRectGetHeight(self.footerContainerView.bounds));
    if (self.keyboardPaddingHeightConstraint.constant != expectedHeight) {
        self.keyboardPaddingHeightConstraint.constant = expectedHeight;
        [self.view setNeedsUpdateConstraints];
        
        __weak typeof(self) weakSelf = self;
        weakSelf.footerContainerView.alpha = 0.0f;
        [UIView animateWithDuration:[animationDuration floatValue]
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                         }];
    }
}

#pragma mark - Setup

- (void)setup {
    
    [self setupHeaderView];
    [self setupScrollView];
    [self changeAuthenticationState:self.currentAuthenticationState
                     retainedValues:@{}];
}

- (void)setupHeaderView {
    
    self.headerContainerView = [UIView new];
    self.headerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerContainerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.headerContainerView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[self pinView:self.headerContainerView
                                    toView:self.view
                                 attribute:NSLayoutAttributeLeading]];
    [self.view addConstraint:[self pinView:self.headerContainerView
                                    toView:self.view
                                 attribute:NSLayoutAttributeTrailing]];
    
    UIView *headerView = [self headerView];
    [self.headerContainerView addSubview:headerView];
    
    [self.headerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.headerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.headerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.headerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0]];
}

- (void)setupScrollView {
    self.scrollView = [UIScrollView new];
    self.scrollView.clipsToBounds = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.headerContainerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[self pinView:self.scrollView
                                    toView:self.view
                                 attribute:NSLayoutAttributeLeading]];
    [self.view addConstraint:[self pinView:self.scrollView
                                    toView:self.view
                                 attribute:NSLayoutAttributeTrailing]];
    
    self.scrollContentView = [UIView new];
    self.scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollView addConstraint:[self pinView:self.scrollContentView
                                          toView:self.scrollView
                                       attribute:NSLayoutAttributeTop]];
    [self.scrollView addConstraint:[self pinView:self.scrollContentView
                                          toView:self.scrollView
                                       attribute:NSLayoutAttributeLeading]];
    [self.scrollView addConstraint:[self pinView:self.scrollContentView
                                          toView:self.scrollView
                                       attribute:NSLayoutAttributeTrailing]];
    [self.scrollView addConstraint:[self pinView:self.scrollContentView
                                          toView:self.scrollView
                                       attribute:NSLayoutAttributeBottom]];
    
    self.scrollContentViewWidth = [NSLayoutConstraint constraintWithItem:self.scrollContentView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0
                                                                constant:320];
    [self.scrollContentView addConstraint:self.scrollContentViewWidth];
    
    UIView *keyboardPseudoView = [UIView new];
    keyboardPseudoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:keyboardPseudoView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:keyboardPseudoView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[self pinView:keyboardPseudoView
                                    toView:self.view
                                 attribute:NSLayoutAttributeLeading]];
    [self.view addConstraint:[self pinView:keyboardPseudoView
                                    toView:self.view
                                 attribute:NSLayoutAttributeTrailing]];
    
    // Rename this
    self.keyboardPaddingHeightConstraint = [NSLayoutConstraint constraintWithItem:keyboardPseudoView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.scrollView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    [self.view addConstraint:self.keyboardPaddingHeightConstraint];
    
    [self setupFooterViewUnderView:keyboardPseudoView];
}

- (void)setupFooterViewUnderView:(UIView *)aboveView {
    self.footerContainerView = [UIView new];
    self.footerContainerView.clipsToBounds = YES;
    self.footerContainerView.backgroundColor = [UIColor clearColor];
    self.footerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.footerContainerView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:aboveView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[self pinView:self.footerContainerView
                                    toView:self.view
                                 attribute:NSLayoutAttributeLeading]];
    [self.view addConstraint:[self pinView:self.footerContainerView
                                    toView:self.view
                                 attribute:NSLayoutAttributeTrailing]];
    //
    
    UIView *footerView = [self footerView];
    [self.footerContainerView addSubview:footerView];
    
    [self.footerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:footerView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.footerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:footerView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.footerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:footerView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0
                                                                          constant:0]];
    
    [self.footerContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:footerView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:0]];
    
}

#pragma mark - Override

- (UIView *)headerView {
    
    return [UIView emptyView];
}

- (UIView *)footerView {
    
    return [UIView emptyView];
    
}

#pragma mark - Setters

- (void)setCurrentAuthenticationState:(AuthenticationState)currentAuthenticationState {
    _currentAuthenticationState = currentAuthenticationState;
    
    if (self.scrollView) {
        [self changeAuthenticationState:currentAuthenticationState
                         retainedValues:@{}];
    }
}

#pragma mark - Defaults

- (LOCLoginView *)buildLoginView:(NSDictionary *)values {
    
    LOCLoginView *loginView = [LOCLoginView new];
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return loginView;
}

- (LOCSignupView *)buildSignupView:(NSDictionary *)values {
    
    LOCSignupView *signupView = [LOCSignupView new];
    signupView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return signupView;
}

- (LOCForgotPasswordView *)buildForgotPasswordView:(NSDictionary *)values {
    
    LOCForgotPasswordView *forgotPasswordView = [LOCForgotPasswordView new];
    forgotPasswordView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return forgotPasswordView;
}

- (LOCValidateCodeView *)buildValidateCodeView:(NSDictionary *)values {
    
    LOCValidateCodeView *validateCodeView = [LOCValidateCodeView new];
    validateCodeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return validateCodeView;
}

- (void)textFieldDidChangeText {
    
    if (self.currentTextField) {
        if ([self.currentTextField.superview isKindOfClass:[LOCFormView class]]) {
            
            LOCStateView *stateView = (LOCStateView *)self.currentTextField.superview.superview;
            
            if (self.currentTextField.LOCLoginFormKey && self.currentTextField.LOCLoginFormKey.length > 0) {
                [self validateForm:stateView
                      withNewEntry:self.currentTextField.text
                          entryKey:self.currentTextField.LOCLoginFormKey];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self authenticationViewActionForValidationState:[LOCFormView validateInputString:textField.text forKey:textField.LOCLoginFormKey]
                                        forTextField:textField];
    
    self.currentTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.superview isKindOfClass:[LOCFormView class]]) {
        
        LOCFormView *formView = (LOCFormView *)textField.superview;
        NSDictionary *formValues = formView.valuesForForm;
        
        NSInteger currentTextFieldIndex = [formView.formTextFields indexOfObject:textField];
        
        if (currentTextFieldIndex != (formView.formTextFields.count - 1)) {
            
            return [formView.formTextFields[currentTextFieldIndex+1] becomeFirstResponder];
        } else if (textField == [[formView formTextFields] lastObject]) {
            
            if ([self respondsToSelector:@selector(authenticationViewActionForResigningLastTextField:currentFormValues:)]) {
                [self authenticationViewActionForResigningLastTextField:textField currentFormValues:formValues];
            }
        }
        
    }
    
    return [textField resignFirstResponder];
}

#pragma mark - LOCLoginViewDelegate

- (void)loginViewLoginButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
    [self authenticationViewLoginWithEmail:values[LOCFormViewEmailKey] password:values[LOCFormViewPasswordKey]];
}

- (void)loginViewForgottenPasswordButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
    NSDictionary *retainedValues = @{ LOCFormViewEmailKey : values[LOCFormViewEmailKey] };
    [self changeAuthenticationState:AuthenticationStateForgotPassword
                     retainedValues:retainedValues];
}

- (void)loginViewSignupButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
    NSDictionary *retainedValues = @{ LOCFormViewEmailKey : values[LOCFormViewEmailKey] };
    [self changeAuthenticationState:AuthenticationStateSignupEmailPassword
                     retainedValues:retainedValues];
}

- (void)loginViewDidPressConnectWithSocialMediaType:(AllowedSocialMediaType)socialMediaType {
    
    switch (socialMediaType) {
        case AllowedSocialMediaTypeFacebook: {
            NSLog(@"AllowedSocialMediaTypeFacebook");
            break;
        }
        case AllowedSocialMediaTypeGooglePlus: {
            NSLog(@"AllowedSocialMediaTypeGooglePlus");
            break;
        }
        case AllowedSocialMediaTypeTwitter: {
            NSLog(@"AllowedSocialMediaTypeTwitter");
            break;
        }
        default:
            break;
    }
}

#pragma mark - LOCSignupViewDelegate

- (void)signupViewDidPressSignupButton:(UIButton *)button withValues:(NSDictionary *)values {
    
    [self authenticationViewSignupUserWithValues:values];
}

- (void)signupViewDidPressBackToLoginButton:(UIButton *)button withValues:(NSDictionary *)values {
    
    [self changeAuthenticationState:AuthenticationStateLoginEmailPassword
                     retainedValues:values];
}


- (void)signupView:(LOCSignupView *)signupView didFailWithErrorReason:(SignupViewErrorReason)reason {
    
}

#pragma mark - LOCForgotPasswordViewDelegate

- (void)forgotPasswordViewButtonPressed:(UIButton *)button withValues:(NSDictionary *)values {
    
    NSDictionary *retainedValues = @{ LOCFormViewEmailKey : values[LOCFormViewEmailKey] };
    
    [self authenticationViewForgotPasswordWithValues:retainedValues];
}

- (void)forgotPasswordViewCancelButtonPressed:(UIButton *)button {
    
    [self changeAuthenticationState:AuthenticationStateLoginEmailPassword
                     retainedValues:@{}];
}

#pragma mark - LOCValidateCodeViewDelegate

- (void)validateCodeViewDidPressCancelButton:(UIButton *)button {
    
    [self changeAuthenticationState:AuthenticationStateForgotPassword
                     retainedValues:@{}];
}

- (void)validateCodeViewDidPressSubmitDetailsButton:(UIButton *)button withValues:(NSDictionary *)values {
    
    [self authenticationViewValidateCodeWithValues:values];
}


#pragma mark - LOCAuthenticationViewControllerDelegate

- (void)authenticationViewLoginWithEmail:(NSString *)email
                                password:(NSString *)password {
    
    NSAssert(NO, @"Subclass must override");
}

- (void)authenticationViewSignupUserWithValues:(NSDictionary *)dictionary {
    
    NSAssert(NO, @"Subclass must override");
}

- (void)authenticationViewForgotPasswordWithValues:(NSDictionary *)dictionary {
    
    NSAssert(NO, @"Subclass must override");
}

- (void)authenticationViewValidateCodeWithValues:(NSDictionary *)dictionary {
    
    NSAssert(NO, @"Subclass must override");
}

#pragma mark Optionals

- (void)authenticationViewAdditionalConfigurationForLoginView:(LOCLoginView *)view {
    // Can override
}

- (void)authenticationViewAdditionalConfigurationForSignupView:(LOCSignupView *)view {
    // Can override
}

- (void)authenticationViewAdditionalConfigurationForForgottenPasswordView:(LOCForgotPasswordView *)view {
    // Can override
}

- (void)authenticationViewAdditionalConfigurationForValidateCodeView:(LOCValidateCodeView *)view {
    // Can override
}

- (void)authenticationViewActionForValidationState:(LOCFormValidationState)state forTextField:(UITextField *)textField {
    // Can override
}

#pragma mark - Helper

- (LOCFormValidationState)validateRuleForValidateForm:(LOCStateView *)view withInput:(NSString *)input entryKey:(NSString *)key {
    
    return [LOCFormView validateInputString:input forKey:key];
}

#pragma mark Validation

- (void)validateForm:(LOCStateView *)view withNewEntry:(NSString *)newInput entryKey:(NSString *)key {
    // validate existing text in text fields
    
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

#pragma mark Switching States

- (void)changeAuthenticationState:(AuthenticationState)authenticationState
                   retainedValues:(NSDictionary *)retainedValues {
    
    [self.signupView removeFromSuperview];
    [self.loginView removeFromSuperview];
    [self.forgotPasswordView removeFromSuperview];
    [self.validateCodeView removeFromSuperview];
    
    switch (authenticationState) {
        case AuthenticationStateLoginEmailPassword: {
            [self layoutForLogin:retainedValues];
            break;
        }
        case AuthenticationStateSignupEmailPassword: {
            [self layoutForSignup:retainedValues];
            break;
        }
        case AuthenticationStateValidateCode: {
            [self layoutForValidateCode:retainedValues];
            break;
        }
        case AuthenticationStateForgotPassword: {
            [self layoutForForgotPassword:retainedValues];
        }
        default:
            break;
    }
}

#pragma mark Layout

- (void)layoutForLogin:(NSDictionary *)values {
    
    if ([self respondsToSelector:@selector(alternativeViewForLoginState)]) {
        
        self.loginView = [self alternativeViewForLoginState];
    } else {
        
        LOCLoginView *defaultLoginView = [self buildLoginView:values];
        [defaultLoginView updateFormForRetainedValues:values];
        [self authenticationViewAdditionalConfigurationForLoginView:defaultLoginView];
        self.loginView = defaultLoginView;
    }
    
    for (UITextField *textField in self.loginView.formTextFields) {
        textField.delegate = self;
    }
    self.loginView.delegate = self;
    [self validateForm:self.loginView withNewEntry:@"" entryKey:@""];
    
    [self.scrollContentView addSubview:self.loginView];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.loginView
                                              attribute:NSLayoutAttributeTop]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.loginView
                                              attribute:NSLayoutAttributeLeading]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.loginView
                                              attribute:NSLayoutAttributeTrailing]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.loginView
                                              attribute:NSLayoutAttributeBottom]];
}

- (void)layoutForSignup:(NSDictionary *)values {
    
    if ([self respondsToSelector:@selector(alternativeViewForSigninState)]) {
        
        self.signupView = [self alternativeViewForSigninState];
    } else {
        LOCSignupView *defaultSignupView = [self buildSignupView:values];
        [defaultSignupView updateFormForRetainedValues:values];
        [self authenticationViewAdditionalConfigurationForSignupView:defaultSignupView];
        self.signupView = defaultSignupView;
    }
    
    for (UITextField *textField in self.signupView.formView.formTextFields) {
        textField.delegate = self;
    }
    self.signupView.delegate = self;
    [self validateForm:self.signupView withNewEntry:@"" entryKey:@""];
    
    [self.scrollContentView addSubview:self.signupView];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.signupView
                                              attribute:NSLayoutAttributeTop]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.signupView
                                              attribute:NSLayoutAttributeLeading]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.signupView
                                              attribute:NSLayoutAttributeTrailing]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.signupView
                                              attribute:NSLayoutAttributeBottom]];
}

- (void)layoutForForgotPassword:(NSDictionary *)values {
    
    if ([self respondsToSelector:@selector(alternativeViewForForgotPasswordState)]) {
        
        self.forgotPasswordView = [self alternativeViewForForgotPasswordState];
    } else {
        LOCForgotPasswordView *defaultForgotPasswordView = [self buildForgotPasswordView:values];
        [defaultForgotPasswordView updateFormForRetainedValues:values];
        [self authenticationViewAdditionalConfigurationForForgottenPasswordView:defaultForgotPasswordView];
        self.forgotPasswordView = defaultForgotPasswordView;
    }
    
    for (UITextField *textField in self.forgotPasswordView.formView.formTextFields) {
        textField.delegate = self;
    }
    self.forgotPasswordView.delegate = self;
    [self validateForm:self.forgotPasswordView withNewEntry:@"" entryKey:@""];
    
    [self.scrollContentView addSubview:self.forgotPasswordView];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.forgotPasswordView
                                              attribute:NSLayoutAttributeTop]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.forgotPasswordView
                                              attribute:NSLayoutAttributeLeading]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.forgotPasswordView
                                              attribute:NSLayoutAttributeTrailing]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.forgotPasswordView
                                              attribute:NSLayoutAttributeBottom]];
}

- (void)layoutForValidateCode:(NSDictionary *)values {
    
    if ([self respondsToSelector:@selector(alternativeViewForValidateCodeState)]) {
        
        self.validateCodeView = [self alternativeViewForValidateCodeState];
    } else {
        LOCValidateCodeView *defaultValidateCodeView = [self buildValidateCodeView:values];
        [defaultValidateCodeView updateFormForRetainedValues:values];
        [self authenticationViewAdditionalConfigurationForValidateCodeView:defaultValidateCodeView];
        self.validateCodeView = defaultValidateCodeView;
    }
    
    self.validateCodeView.delegate = self;
    for (UITextField *textField in self.validateCodeView.formView.formTextFields) {
        textField.delegate = self;
    }
    [self validateForm:self.validateCodeView withNewEntry:@"" entryKey:@""];
    
    [self.scrollContentView addSubview:self.validateCodeView];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.validateCodeView
                                              attribute:NSLayoutAttributeTop]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.validateCodeView
                                              attribute:NSLayoutAttributeLeading]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.validateCodeView
                                              attribute:NSLayoutAttributeTrailing]];
    [self.scrollContentView addConstraint:[self pinView:self.scrollContentView
                                                 toView:self.validateCodeView
                                              attribute:NSLayoutAttributeBottom]];
}

- (NSLayoutConstraint *)pinView:(UIView *)view toView:(UIView *)toView attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:toView
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0];
}

@end
