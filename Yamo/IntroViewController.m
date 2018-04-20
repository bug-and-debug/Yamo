//
//  IntroViewController.m
//  Yamo
//
//  Created by Jin on 7/11/17.
//  Copyright © 2017 Locassa. All rights reserved.
//

#import "IntroViewController.h"
#import "AuthenticationViewController.h"
#import "APIClient+Authentication.h"
#import "LOCFloatingPasswordTextField.h"
#import "LoginView.h"
#import "User.h"
#import "UserService.h"
#import "LOCMacros.h"
#import "Yamo-Swift.h"
#import "PasswordValidator.h"
#import "UIViewController+Network.h"
#import "LOCAppDefinitions.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import UIAlertController_LOCExtensions;

#define INTRO_MESSAGE @[@"Browse the most comprehensive\n collection of art exhibitions.", @"Select an art exhibition and find\n further information.", @"Go explore!\n           "]

@interface IntroViewController ()

@property (nonatomic, strong) UIButton *facebookButton;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkAutoLogin];
    [self initSlideData];
}

- (void) checkAutoLogin
{
    if(((NSString*)[[Utility sharedObject] getDefaultObject:USER_SAVED]).intValue == 1)
    {
        NSString* email = (NSString*)[[Utility sharedObject] getDefaultObject:USER_NAME];
        NSString* password = (NSString*)[[Utility sharedObject] getDefaultObject:USER_PASSWORD];
        [[Utility sharedObject] showMBProgress:self.view message:@""];
        [[APIClient sharedInstance] loginWithEmail:email
                                          password:password
                                      successBlock:^(id  _Nullable element) {
                                          [[Utility sharedObject] hideMBProgress];
                                          [Utility showToast:@"User login success" icon:ICON_SUCCESS toView:self.view afterDelay:2];
                                          NSError *parseError = nil;
                                          User *loggedInUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:element error:&parseError];
                                          [[UserService sharedInstance] didLoginWithUser:loggedInUser];
                                          
                                          //hans modified
                                          NSDictionary *flurry_email_param = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                              loggedInUser.email, @"email",
                                                                              [NSString stringWithFormat:@"%@ %@", loggedInUser.firstName, loggedInUser.lastName], @"name",
                                                                              nil];
                                          [[Utility sharedObject] flurryLogEvent:FLURRY_EMAIL param:flurry_email_param];
                                          //
                                          [self gotoHome];
                                          
                                      } failureBlock:^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {
                                          [[Utility sharedObject] hideMBProgress];
                                          [Utility showToast:@"Please check your credential." icon:ICON_FAIL toView:self.view afterDelay:2];
                                      }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) initSlideData
{
    lbl_intro.text = [INTRO_MESSAGE objectAtIndex:0];
    slider_data_source = [[NSMutableArray alloc] initWithObjects:@"intro-1", @"intro-2", @"intro-3", nil];
    
    v_slider.datasource = self;
    v_slider.delegate = self;
    [v_slider setDelay:4];
    [v_slider setTransitionDuration:.5];
    [v_slider setTransitionType:KASlideShowTransitionSlideHorizontal];
    [v_slider setImagesContentMode:UIViewContentModeScaleAspectFill];
    [v_slider addGesture:KASlideShowGestureSwipe];
    [self performSelector:@selector(startSlide) withObject:nil afterDelay:2.0];
}

- (void) startSlide
{
    [v_slider start];
}

#pragma mark - <delegate> KASlideShow
#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return slider_data_source[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return slider_data_source.count;
}

#pragma mark - KASlideShow delegate

- (void) slideShowWillShowNext:(KASlideShow *)slideShow
{
    
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
    
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    pager.currentPage = slideShow.currentIndex;
    lbl_intro.text = [INTRO_MESSAGE objectAtIndex:slideShow.currentIndex];
    
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    pager.currentPage = slideShow.currentIndex;
    lbl_intro.text = [INTRO_MESSAGE objectAtIndex:slideShow.currentIndex];
}

#pragma mark - IBAction
- (IBAction)pagerValueChanged:(id)sender
{
    //NSLog(@"--------- current page --------- %ld", pager.currentPage);
}

- (IBAction)createAccount:(id)sender
{
    LoginViewController* l = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    SignUpViewController* s = [[SignUpViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:l animated:NO];
    [self.navigationController pushViewController:s animated:YES];
}

- (IBAction)continueWithFacebook:(id)sender
{
    
    self.facebookButton.userInteractionEnabled = NO;
    
    [self showIndicator:YES];
    //[self enableUIUserInteractionState:NO];
    
    void (^loginBlock)() = ^{
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"email, first_name, last_name"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if(!error) {
                NSString *fbUserId = [[FBSDKAccessToken currentAccessToken] userID];
                NSString *fbToken =  [[FBSDKAccessToken currentAccessToken] tokenString];
                NSString *fbEmail =  result[@"email"];
                
                //hans modified - flurry
                NSDictionary *flurry_fb_param = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 result[@"email"], @"fb-email",
                                                 [NSString stringWithFormat:@"%@ %@", result[@"first_name"], result[@"last_name"]], @"fb-name",
                                                 nil];
                [[Utility sharedObject] flurryLogEvent:FLURRY_FB param:flurry_fb_param];
                //
                [self connectWithFacebookWithFacebookToken:fbToken facebookId:fbUserId emailAddress:fbEmail];
            }
            else {
                NSLog(@"Connect with Facebook error is %@",error.description );
                
                [self showIndicator:NO];
                //                [self enableUIUserInteractionState:YES];
            }
        }];
    };
    
    if (![[FBSDKAccessToken currentAccessToken] tokenString]) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email", @"public_profile", @"user_birthday", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                loginBlock();
            } else {
                
                [self showIndicator:NO];
                //[self enableUIUserInteractionState:YES];
            }
        }];
    } else {
        loginBlock();
    }
    
    
}

- (void)connectWithFacebookWithFacebookToken:(NSString *)fbToken
                                  facebookId:(NSString *)facebookId
                                emailAddress:(NSString *)emailAddress {
    void (^afterLoad)() = ^{
        
        [self showIndicator:NO];
        //[self enableUIUserInteractionState:YES];
    };
    
    void (^successBlock)(id element) = ^(id  _Nullable element) {
        
        [self gotoHome];
        
        //NSString *tempPassword = [NSString stringWithFormat:@"%@%@", facebookId, kFacebookSharedSecret];
        
        //if ([self.delegate respondsToSelector:@selector(signUpDidFinish:withUsername:andPassword:)]) {
        //    [self signUpDidFinish:self withUsername:emailAddress andPassword:tempPassword];
        //}
    };
    
    void (^failureBlock)(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) =
    ^(NSError * _Nonnull error, NSInteger statusCode, NSString * _Nullable context) {NSDictionary *errorDictionary = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] ? error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] : @{};
        
        NSLog(@"Error dictionary: %@", errorDictionary);
        //[self handleNetworkError:error statusCode:statusCode context:nil];
    };

        [[APIClient sharedInstance] authenticationConnectWithFacebookWithFacebookToken:fbToken
                                                                            facebookId:facebookId
                                                                                 email:emailAddress
                                                                            beforeLoad:nil
                                                                             afterLoad:afterLoad
                                                                          successBlock:successBlock
                                                                          failureBlock:failureBlock];

}

- (void) gotoHome
{
    RootViewController* r = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [r setExploreType:1];
    RootViewController* v = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [v setExploreType:2];
    SettingsViewController* s = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    NSArray *controllerArray = [NSArray arrayWithObjects:r, v, s, nil];
    NSArray * titleArray = TABBAR_TITLE_ARRAY;
    NSArray *imageArray= TABBAR_NORMAL_IMAGE_ARRAY;
    NSArray *selImageArray = TABBAR_SEL_IMAGE_ARRAY;
    CGFloat tabBarHeight = 49.0;
    
    XHTabBar* tabBar= [[XHTabBar alloc] initWithControllerArray:controllerArray titleArray:titleArray imageArray:imageArray selImageArray:selImageArray height:tabBarHeight];
    //self.window.rootViewController = tabBar;
    [self.navigationController pushViewController:tabBar animated:YES];
}

- (void)showIndicator:(BOOL)show {
    
    if (!self.networkActivityIndicator) {
        //[self initializeActivityIndicator];
    }
    
    if (show) {
        [self.networkActivityIndicator startAnimating];
        self.networkActivityIndicatorContainer.hidden = NO;
    } else {
        [self.networkActivityIndicator stopAnimating];
        self.networkActivityIndicatorContainer.hidden = YES;
    }
}

- (IBAction)signIn:(id)sender
{
    LoginViewController* s = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:s animated:YES];
}

@end
