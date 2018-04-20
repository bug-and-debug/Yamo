//
//  PlaceholderViewController.m
//  Yamo
//
//  Created by Mo Moosa on 26/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "PlaceholderViewController.h"
#import "SideMenuChildViewController.h"

#warning remove
#import "RoutePlannerViewController.h"
#import "RouteLocation.h"

@interface PlaceholderViewController () <SideMenuChildViewController>

@end

@implementation PlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)preferredTitle {
    
    return self.title;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    self.label.text = title;
}

- (IBAction)handleButtonTap:(id)sender {
    

    PlaceholderViewController *viewController = [PlaceholderViewController new];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goToMapRoute:(id)sender {
    
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] init];
    
    RouteLocation *locationObject0 = [[RouteLocation alloc] init];
    locationObject0.title = @"Location A";
    locationObject0.annotationLetter = @"A";
    locationObject0.coordinate = CLLocationCoordinate2DMake(51.529963,-0.079800);
    [arrayOfPoints addObject:locationObject0];
    
    RouteLocation *locationObject1= [[RouteLocation alloc] init];
    locationObject1.title = @"Location B";
    locationObject1.annotationLetter = @"B";
    locationObject1.coordinate = CLLocationCoordinate2DMake(51.529614, -0.081214);
    [arrayOfPoints addObject:locationObject1];
    
    
    RouteLocation *locationObject2= [[RouteLocation alloc] init];
    locationObject2.title = @"Location C";
    locationObject2.annotationLetter = @"C";
    locationObject2.coordinate = CLLocationCoordinate2DMake(51.516040, -0.097277);
    [arrayOfPoints addObject:locationObject2];
    
    
    RouteLocation *locationObject3= [[RouteLocation alloc] init];
    locationObject3.title = @"Location D";
    locationObject3.annotationLetter = @"D";
    locationObject3.coordinate = CLLocationCoordinate2DMake(51.514444, -0.099734);
    [arrayOfPoints addObject:locationObject3];
   

    
    
    RoutePlannerViewController *viewController = [[RoutePlannerViewController alloc] initWithNibName:@"RoutePlannerViewController" bundle:nil ];
    viewController.arrayOfLocations = arrayOfPoints;

    [self.navigationController pushViewController:viewController animated:YES];

}

@end
