//
//  ForgottenViewController.h
//  Yamo
//
//  Created by Adrian on 26/07/2017.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgottenViewController : BaseViewController<UIAlertViewDelegate>
{
    IBOutlet UITextField* tf_email;
}


-(IBAction)send:(id)sender;
@end
