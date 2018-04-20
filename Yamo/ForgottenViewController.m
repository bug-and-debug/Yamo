//
//  ForgottenViewController.m
//  Yamo
//
//  Created by Adrian on 26/07/2017.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "ForgottenViewController.h"
@implementation ForgottenViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)send:(id)sender
{
    if(![Utility isValidEmail:tf_email.text])
    {
        [Utility showToast:@"Invalid email address" icon:ICON_NONE toView:self.view afterDelay:2.0];
        tf_email.text = @"";
        [tf_email becomeFirstResponder];
        return;
    }
    
    [[Utility sharedObject] showMBProgress:self.view message:@""];
    [[APIClient sharedInstance] authenticationRecoverPasswordForEmail:tf_email.text beforeLoad:^{
        
    } afterLoad:^{
        
    } successBlock:^{
        [[Utility sharedObject] hideMBProgress];
        UIAlertController* alert_success = [UIAlertController alertControllerWithTitle:@"Link Sent" message:@"Please check your inbox and Junk folders to reset your password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* btn_done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        [alert_success addAction:btn_done];
        [self presentViewController:alert_success animated:YES completion:nil];
        
        
    } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
        [[Utility sharedObject] hideMBProgress];
        [Utility showToast:@"Invalid Network" icon:ICON_FAIL toView:self.view afterDelay:2.0];
        
    }];

}

@end
