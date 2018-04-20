//
//  SignUpController.h
//  Yamo
//
//  Created by Vlad Buhaescu on 19/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpViewControllerDelegate.h"

@protocol SignUpController <NSObject>

@property (nonatomic, weak) id <SignUpViewControllerDelegate> signupDelegate;

@end

