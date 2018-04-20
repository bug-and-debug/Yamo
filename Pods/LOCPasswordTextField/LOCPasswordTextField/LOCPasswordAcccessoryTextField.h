//
//  LOCPasswordAcccessoryTextField.h
//  LOCPasswordTextField
//
//  Created by Peter Su on 13/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "LOCFloatingAccessoryTextField.h"
#import "LOCPasswordTextFieldProtocol.h"

@interface LOCPasswordAcccessoryTextField : LOCFloatingAccessoryTextField<LOCPasswordTextFieldProtocol>

@property (nonatomic, strong) IBInspectable UIImage *revealImage;

@property (nonatomic, strong) IBInspectable UIImage *hiddenImage;

@end
