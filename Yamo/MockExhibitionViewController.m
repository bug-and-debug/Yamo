//
//  MockExhibitionViewController.m
//  Yamo
//
//  Created by Peter Su on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "MockExhibitionViewController.h"
#import "RoutePlannerViewController.h"
#import "Route.h"
#import "Place.h"
#import "Venue.h"

@interface MockExhibitionViewController ()

@end

@implementation MockExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToRoutePlannerViewController:(id)sender {
    
    RoutePlannerViewController *routeViewController = [[RoutePlannerViewController alloc] initWithRoute:[MockExhibitionViewController mockRoute]];
    
    [self.navigationController pushViewController:routeViewController animated:YES];
}

+ (Route *)mockRoute {
    
    Route *route = [Route new];
    route.counter = @3;
    route.created = [NSDate date];
    route.name = @"My favourite route";
    route.updated = [NSDate date];
    route.userId = @1;
    route.uuid = @1;
    
    NSMutableArray *mockSteps = [NSMutableArray new];
    NSDictionary *mockVenueDetails = @{ @"John Hoyland Power Stations Paintings 1964-1982 " :[[CLLocation alloc] initWithLatitude:51.535638 longitude:-0.089344],
                                        @"Shoreditch" :[[CLLocation alloc] initWithLatitude:51.528490 longitude:-0.084728],
                                        @"Hoxton 2" :[[CLLocation alloc] initWithLatitude:51.535638 longitude:-0.084728],
                                        @"Shoreditch 2" :[[CLLocation alloc] initWithLatitude:51.528490 longitude:-0.089344],
                                        @"Canary Wharf" :[[CLLocation alloc] initWithLatitude:51.505431 longitude:-0.023533],
                                        @"Canada Water" :[[CLLocation alloc] initWithLatitude:51.497990 longitude:-0.049690],
                                        @"Liverpool street" :[[CLLocation alloc] initWithLatitude:51.517410 longitude:-0.083018],
                                        @"Finsbury park" : [[CLLocation alloc] initWithLatitude:51.563296 longitude:-0.107435],
                                        @"Seven sisters" : [[CLLocation alloc] initWithLatitude:51.464108 longitude:-0.159438],
                                        @"Seven sisters 2" : [[CLLocation alloc] initWithLatitude:51.764108 longitude:-0.159438],
                                        @"Seven sisters 3" : [[CLLocation alloc] initWithLatitude:51.964108 longitude:-0.159438]
                                        };
    
    // Create mock route steps
    NSInteger index = 0;
    for (NSString *key in mockVenueDetails.allKeys) {
        
        RouteStep *step = [RouteStep new];
        step.uuid = @(index);
        step.sequenceOrder = @(index);
        step.venue = [self mockVenueWithUUID:@(index) name:key coordinate:mockVenueDetails[key]];
        
        [mockSteps addObject:step];
        
        index++;
    }
    
    route.steps = mockSteps;
    
    return route;
}

+ (Venue *)mockVenueWithUUID:(NSNumber *)venueId name:(NSString *)name coordinate:(CLLocation *)location {
    
    Venue *mockVenue = [Venue new];
    mockVenue.name = name;
    mockVenue.locationName = name;
    mockVenue.uuid = venueId;
    mockVenue.latitude = location.coordinate.latitude;
    mockVenue.longitude = location.coordinate.longitude;
    
    return mockVenue;
}

+ (Place *)mockHome {
    
    Place *place = [Place new];
    place.created = [NSDate new];
    place.latitude = 51.586448;
    place.longitude = -0.077359;
    place.locationName = @"Home";
    place.placeType = PlaceTypeHome;
    place.placeTypeValue = @0;
    place.updated = [NSDate date];
    place.userId = @41;
    place.uuid = @3;
    
    return place;
}

+ (Place *)mockWork {
    
    Place *place = [Place new];
    place.created = [NSDate date];
    place.latitude = 51.529856;
    place.longitude = -0.080232;
    place.locationName = @"Work";
    place.placeType = PlaceTypeWork;
    place.placeTypeValue = @1;
    place.updated = [NSDate date];
    place.userId = @41;
    place.uuid = @2;
    
    return place;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
