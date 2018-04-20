//
//  BaseViewController.m
//  Yamo
//
//  Created by Jin on 7/10/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[textField.superview viewWithTag:11] setBackgroundColor:COLOR_LINE];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[textField.superview viewWithTag:11] setBackgroundColor:COLOR_BLACK];
}

- (void) singleTapGestureCaptured:(UITapGestureRecognizer*)gesture
{
    [self hideKeyboard];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}
@end
