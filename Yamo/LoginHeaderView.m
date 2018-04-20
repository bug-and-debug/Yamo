//
//  LoginHeaderView.m
//  RoundsOnMe
//
//  Created by Hungju Lu on 13/04/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import "LoginHeaderView.h"

@implementation LoginHeaderView

+ (LoginHeaderView *)loadFromNib {
    
    LoginHeaderView *view = (LoginHeaderView *)[[[UINib nibWithNibName:@"LoginHeaderView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
//    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
