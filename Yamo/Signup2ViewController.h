//
//  Signup2ViewController.h
//  Yamo
//
//  Created by Jin on 7/10/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Signup2ViewController : BaseViewController
{
    IBOutlet UITextField* emailTextField;
    IBOutlet UITextField* passwordTextField;
}

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;

- (IBAction)gotoSignin:(id)sender;
- (IBAction)done:(id)sender;

@end