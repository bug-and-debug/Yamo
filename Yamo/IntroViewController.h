//
//  IntroViewController.h
//  Yamo
//
//  Created by Jin on 7/11/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface IntroViewController : BaseViewController<KASlideShowDataSource, KASlideShowDelegate>
{
    IBOutlet KASlideShow* v_slider;
    NSMutableArray* slider_data_source;
    IBOutlet UIPageControl* pager;
    IBOutlet UILabel* lbl_intro;
}

- (IBAction)createAccount:(id)sender;
- (IBAction)continueWithFacebook:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)pagerValueChanged:(id)sender;
@end
