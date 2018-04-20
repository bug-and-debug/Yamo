//
//  LoginHeaderView.h
//  RoundsOnMe
//
//  Created by Hungju Lu on 13/04/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

+ (LoginHeaderView *)loadFromNib;

@end
