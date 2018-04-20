//
//  SignupFormView.m
//  RoundsOnMe
//
//  Created by Peter Su on 29/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "SignupFormView.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"

@import UIImage_LOCExtensions;

@interface SignupFormView () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;
@property BOOL eyePressed;

@end

@implementation SignupFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

+ (SignupFormView *)loadFromNib {
    
    SignupFormView *signupForm = (SignupFormView *)[[[UINib nibWithNibName:@"SignupFormView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    return signupForm;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.eyePressed = NO;
    
    self.firstNameTextField.LOCLoginFormKey = LOCFormViewFirstNameKey;
    self.firstNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self setupFormTextField:self.firstNameTextField placeholder:NSLocalizedString(@"First Name", nil) isLast:NO];
    
    self.lastNameTextField.LOCLoginFormKey = LOCFormViewLastNameKey;
    self.lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self setupFormTextField:self.lastNameTextField placeholder:NSLocalizedString(@"Last Name", nil) isLast:NO];
    
    self.emailTextField.LOCLoginFormKey = LOCFormViewEmailKey;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self setupFormTextField:self.emailTextField placeholder:NSLocalizedString(@"Email", nil) isLast:NO];
    
    self.passwordTextField.LOCLoginFormKey = LOCFormViewPasswordKey;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self setupFormPasswordTextField:self.passwordTextField placeholder:NSLocalizedString(@"Password (at least 8 characters)", nil) isLast:YES];
    
    self.formTextFields = @[self.firstNameTextField,
                            self.lastNameTextField,
                            self.emailTextField,
                            self.passwordTextField ];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.passwordTextField.placeholderColor = [UIColor yamoDarkGray];
}

- (void)setupFormTextField:(TextField *)textField
               placeholder:(NSString *)placeholder
                    isLast:(BOOL)isLast {
    
    UIColor *textColor = [UIColor blackColor];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes: attributes];
    textField.textColor = textColor;
    textField.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14];
    textField.keyboardAppearance = UIKeyboardAppearanceLight;
    
    textField.returnKeyType = isLast ? UIReturnKeyDone : UIReturnKeyNext;
}

- (void)setupFormPasswordTextField:(PasswordTextField *)textField
                       placeholder:(NSString *)placeholder
                            isLast:(BOOL)isLast {
    
    UIColor *textColor = [UIColor blackColor];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes: attributes];
    textField.textColor = textColor;
    textField.font = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14];
    textField.keyboardAppearance = UIKeyboardAppearanceLight;

    textField.returnKeyType = isLast ? UIReturnKeyDone : UIReturnKeyNext;
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoBlack],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sender.text attributes:attributes];
    
    sender.attributedText = attributedString;
}

@end
