//
//  ViewController.m
//  StorySite
//
//  Created by Vicc Alexander on 9/10/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import "SSMainController.h"
@import MapKit;
@import CoreLocation;

#import <Parse/Parse.h>
#import <ChameleonFramework/Chameleon.h>
#import "MKMapView+ZoomLevel.h"
#import "SSSegmentedControl.h"

@interface SSMainController () <CLLocationManagerDelegate, SSSegmentedControlDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) SSSegmentedControl *segmentedControl;

@end

@implementation SSMainController

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    //Super
    [super viewDidLoad];
    
    //Setup UI
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    
    //Super
    [super viewDidAppear:animated];
}

#pragma mark - UIStatusBar Methods

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Setup Methods

- (void)setupUI {
    
    //Request Authorization
    self.locationManager = [[CLLocationManager alloc] init];;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //Setup Location Manager
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    //Setup Map View
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    //Setup Navigation View
    [self setupNavigationView];
}

- (void)setupNavigationView {
    
    //Setup Navigation View
    self.navigationView = [[UIView alloc] init];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.frame = CGRectMake(16, 16, self.view.frame.size.width - 32, 96);
    self.navigationView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.navigationView.layer.shadowOpacity = 0.3;
    [self.view addSubview:self.navigationView];
    
    //Setup Navigation Title
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, self.navigationView.frame.size.width, 44);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"StorySite";
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = HexColor(@"ff4c4c");
    [self.navigationView addSubview:title];
    
    //Setup Segmented control
    self.segmentedControl = [[SSSegmentedControl alloc] initWithFrame:CGRectMake(8, 44, self.navigationView.frame.size.width-16, 44) withTitles:@[@"Sites", @"Moments", @"Memories"] andIcons:nil];
    self.segmentedControl.selectionColors = @[HexColor(@"ff4c4c"), HexColor(@"0099e5"), HexColor(@"34bf49")];
    self.segmentedControl.backgroundColor = FlatWhite;
    self.segmentedControl.delegate = self;
    [self.navigationView addSubview:self.segmentedControl];
}

#pragma mark - Parse Methods

- (void)fetchNearestLocations {
    
    //Define Parameters
    NSDictionary *parameters = @{@"latitude" : @(self.currentUserLocation.coordinate.latitude),
                                 @"longitude": @(fabs(self.currentUserLocation.coordinate.longitude)),
                                 @"resultLimit" : @(3)};
    
    //Call Cloud Function
    [PFCloud callFunctionInBackground:@"getNearestLocations" withParameters:parameters block:^(id  _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"%@", object);
        } else {
            NSLog(@"Error:%@", [error localizedDescription]);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //Check if coordinates are consistent
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    //Check against absolute value of the interval
    if ([newLocation.timestamp timeIntervalSinceNow] > 30) {
        
        //Update User Location
        self.currentUserLocation = newLocation;
        
        //Set Region
        [self.mapView setCenterCoordinate:self.currentUserLocation.coordinate zoomLevel:13 animated:YES];
        
        //Fetch Nearest Locations
        [self fetchNearestLocations];
    }
}

#pragma mark - SSSegmentedControlDelegate Methods

- (void)segmentedControl:(SSSegmentedControl *)segmentedControl didSelectSegmentAtIndex:(int)index {
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    
    //Super
    [super didReceiveMemoryWarning];
}

@end
