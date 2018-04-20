//
//  LOCFloatingAccessoryTextField.h
//  LOCAccessoryTextField
//
//  Created by Peter Su on 12/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCCustomTextField.h"

@interface LOCFloatingAccessoryTextField : LOCCustomTextField <LOCCustomTextFieldInterface>

@property (nonatomic, strong) IBInspectable UIColor *borderInactiveColor;

@property (nonatomic, strong) IBInspectable UIColor *borderActiveColor;

@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@property (nonatomic) IBInspectable CGFloat placeholderFontScale;

@property (nonatomic, strong) IBInspectable UIImage *activeImage;

@property (nonatomic, strong) IBInspectable UIImage *inactiveImage;

@property (nonatomic, strong) NSString *errorMessage;

@property (nonatomic, strong) IBInspectable UIColor *errorMessageColor;

@end
