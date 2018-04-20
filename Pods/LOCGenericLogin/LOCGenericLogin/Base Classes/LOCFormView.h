//
//  LOCFormView.h
//  GenericLogin
//
//  Created by Peter Su on 23/02/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCBaseView.h"
#import "LOCFormValidationState.h"
#import "UITextField+LOCLoginForm.h"

static CGFloat kTextFieldHeight = 48;
static CGFloat kTextFieldVerticalPadding = 15;
static CGFloat kTextFieldLeadingTrailingMargin = 33;

static NSInteger const LOCFormViewDefaultMaxLength = 255;
static NSInteger const LOCFormViewDefaultNameMinLength = 2;
static NSInteger const LOCFormViewDefaultNameMaxLength = 30;
static NSInteger const LOCFormViewDefaultPasswordMinLength = 7;

extern NSString * const LOCFormViewEmailKey;
extern NSString * const LOCFormViewPasswordKey;
extern NSString * const LOCFormViewConfirmPasswordKey;
extern NSString * const LOCFormViewUsernameKey;
extern NSString * const LOCFormViewFirstNameKey;
extern NSString * const LOCFormViewLastNameKey;
extern NSString * const LOCFormViewPhoneNumberKey;

/*
 *  This class also has the default validation rules for the various types of text fields that belong in 
 *  the authentication flow.
 *
 *  Email - Regex to check whether it's an email
 *  Password - Checks length to see if it's at least 7 characters
 *  Confirm Password - Checks length to see if it's at least 7 characters
 *  First name / last name - Checks to see if its between 2 to 15 characters
 *
 *  To provide additional validation, create a subclass of this class and override the
 *  class method validateInputString:forKey.
 *  There, you should get the LOCLoginFormKey for the UITextField which gives you the context
 *  of the text field you are validating.
 */

@interface LOCFormView : LOCBaseView {
    @protected
    NSArray<UITextField *> *_formTextFields;
    NSArray<UIButton *> *_formValidatedButtons;
}

/*
 *  Text Fields that have a key which can be used to identify how it should be 
 *  valdiated.
 */
@property (nonatomic, strong, readonly) NSArray<UITextField *> *formTextFields;

/*
 *  When the validation rules are applied, these buttons will enabled/disabled
 */
@property (nonatomic, strong, readonly) NSArray<UIButton *> *formValidatedButtons;

- (NSDictionary *)valuesForForm;
+ (LOCFormValidationState)validateInputString:(NSString *)input forKey:(NSString *)key;

@end
