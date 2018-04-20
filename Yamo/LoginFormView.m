//
//  LoginFormView.m
//  Yamo
//
//  Created by Vlad Buhaescu on 18/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LoginFormView.h"
#import "UIFont+Yamo.h"
#import "UIColor+Yamo.h"
#import "NSNumber+Yamo.h"

#define UIColorFromRGB(rgbValue) [UIColor \
            colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@import UIImage_LOCExtensions;

@interface LoginFormView ()

@property (nonatomic, strong, readwrite) NSArray<UITextField *> *formTextFields;
@property (nonatomic, strong, readwrite) NSArray<UIButton *> *formValidatedButtons;

@end

@implementation LoginFormView

@synthesize formTextFields;
@synthesize formValidatedButtons;

+ (LoginFormView *)loadFromNib {
    
    LoginFormView *loginForm = (LoginFormView *)[[[UINib nibWithNibName:@"LoginFormView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    return loginForm;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIFont *graphikRegular14 = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14.0f];
    UIFont *graphikRegular12 = [UIFont preferredFontForStyle:FontStyleGraphikRegular size:12.0f];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoDarkGray],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    
    self.facebookButton.titleLabel.font = graphikRegular14;
    
    self.emailTextField.LOCLoginFormKey = LOCFormViewEmailKey;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.textColor = [UIColor blackColor];
    self.emailTextField.font = graphikRegular14;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, self.emailTextField.frame.size.height - borderWidth, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:border];
    //self.emailTextField.layer.masksToBounds = YES;®

    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email", nil) attributes: attributes];
    
    self.passwordTextField.LOCLoginFormKey = LOCFormViewPasswordKey;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.font = graphikRegular14;
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password (at least 8 characters)", nil) attributes: attributes];
    
    self.formTextFields = @[self.emailTextField,
                            self.passwordTextField];
    
    NSAttributedString *forgotPasswordTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Forgotten Password?", nil)
                                                                              attributes:@{ NSFontAttributeName : graphikRegular12,
                                                                                            NSForegroundColorAttributeName: UIColorFromRGB(0xDAD9D7),
                                                                                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) }];
    
    [self.forgotPasswordButton setAttributedTitle:forgotPasswordTitle forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.passwordTextField.placeholderColor = [UIColor yamoDarkGray];
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor yamoBlack],
                                 NSFontAttributeName: [UIFont preferredFontForStyle:FontStyleGraphikRegular size:14],
                                 NSKernAttributeName: [NSNumber kernValueWithStyle:KernValueStyleRegular fontSize:14]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:sender.text attributes:attributes];
    
    sender.attributedText = attributedString;
}

@end
