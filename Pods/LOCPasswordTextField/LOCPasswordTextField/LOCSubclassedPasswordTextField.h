//
//  LOCSubclassedPasswordTextField.h
//  LOCPasswordTextField
//
//  Created by Peter Su on 01/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOCPasswordTextFieldProtocol.h"

/*
 *  Set right view for text field to toggle the secureEntry
 *  Default rightViewMode is UITextFieldViewModeAlways
 *
 *  There's a bug with toggling secureEntry mode on a UITextField where the font is lost
 *  This subclass fixes it by having a UITextField subview which becomes the new responder
 *  This is a temp hack until a better solution is found.
 */

@interface LOCSubclassedPasswordTextField : UITextField <LOCPasswordTextFieldProtocol>

@property (nonatomic) CGFloat editingTextLeftRightPadding;

@property (nonatomic) CGFloat revealRightPadding;

@property (nonatomic) CGFloat revealLeftPadding;


@end
