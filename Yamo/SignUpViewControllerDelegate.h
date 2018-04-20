//
//  SignUpViewControllerDelegate.h
//  Yamo
//
//  Created by Vlad Buhaescu on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignUpViewControllerDelegate <NSObject>

- (void)signUpDidFinish:(UIViewController *)viewController withUsername:(NSString *)username andPassword:(NSString *)password;

@optional

- (BOOL)signUpShouldBeSkipped:(UIViewController *)viewController;

@end


