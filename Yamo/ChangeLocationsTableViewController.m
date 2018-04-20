//
//  ChangeLocationsTableViewController.m
//  mapPlaying
//
//  Created by Dario Langella on 10/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#import "ChangeLocationsTableViewController.h"
#import "RoutePlannerViewController.h"
#import "RoutePlannerCoordinator.h"
#import "Route.h"
#import "RouteStep.h"
#import "Venue.h"

@interface ChangeLocationsTableViewController ()

@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) NSMutableArray *arrayOfPoints;

@end

@implementation ChangeLocationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.route = [ChangeLocationsTableViewController mockRoute];
    self.arrayOfPoints = self.route.steps.mutableCopy;

    self.tableView.dataSource=self;
    self.tableView.delegate = self;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
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
    mockVenue.venueDescription = name;
    mockVenue.locationName = name;
    mockVenue.uuid = venueId;
    mockVenue.latitude = location.coordinate.latitude;
    mockVenue.longitude = location.coordinate.longitude;
    
    return mockVenue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.route.steps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    RouteStep *locationObject = self.route.steps[indexPath.row];
    
    cell.textLabel.text = locationObject.venue.name;
    // Configure the cell...
    RouteStep *step = self.route.steps[indexPath.row];
    if ([self.arrayOfPoints containsObject:step]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RoutePlannerInvalidateCacheNotification object:nil];
    
    RouteStep *step = self.route.steps[path.row];
    if ([self.arrayOfPoints containsObject:step]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.arrayOfPoints removeObject:step];
 
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.arrayOfPoints addObject:step];
        
    }
}

- (IBAction)doneAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^() {
        
        [self.changeLocationsDelegate sendLocationsToMap:self.arrayOfPoints];
        
    }];
}


@end
