//
//  MapViewController.m
//  Yamo
//
//  Created by Vlad Buhaescu on 25/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

@import MapKit;
@import CoreLocation;

#import "MapViewController.h"
//#import "GetToKnowViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *overlayForGetToKnowMe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthConstraintForOverlay;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(51.5085300, -0.1257400
), MKCoordinateSpanMake(0.01,0.01));
    [self.mapView setRegion:region animated:YES];

    self.overlayForGetToKnowMe.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.heigthConstraintForOverlay.constant = self.view.bounds.size.height/4;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.view bringSubviewToFront:self.overlayForGetToKnowMe];
        
    });
    
}
- (IBAction)removeOverlay:(id)sender {
    
    [UIView animateWithDuration:0.3
                     animations:^{self.overlayForGetToKnowMe .alpha = 0.0;}
                     completion:^(BOOL finished){ [self.overlayForGetToKnowMe  removeFromSuperview]; }];
    
}

- (IBAction)presentGetToKnowMe:(id)sender {
    
    //GetToKnowViewController *getTKMe = [[GetToKnowViewController alloc] init];
    //[self presentViewController:getTKMe animated:YES completion:nil];
}

@end
