//
//  LoginController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewControllerDelegate.h"

@protocol LoginController <NSObject>

@property (nonatomic, weak) id <LoginViewControllerDelegate> loginDelegate;

@end