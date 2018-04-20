//
//  LOCPasswordTextField.h
//  LOCPasswordTextField
//
//  Created by Peter Su on 16/03/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOCPasswordTextFieldProtocol.h"

/*
 *  Set right view for text field to toggle the secureEntry
 *  Default rightViewMode is UITextFieldViewModeAlways
 *
 *  There's a bug with toggling secureEntry mode on a UITextField where the font is lost
 *  This subclass fixes it by resigning and making the textField the responder, however
 *  this causes an issue with the keyboard
 */
@interface LOCPasswordTextField : UITextField <LOCPasswordTextFieldProtocol>

@property (nonatomic) CGFloat editingTextLeftRightPadding;

@property (nonatomic) CGFloat revealRightPadding;

@property (nonatomic) CGFloat revealLeftPadding;

@end
