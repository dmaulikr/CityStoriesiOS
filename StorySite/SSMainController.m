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

#import <ChameleonFramework/Chameleon.h>
#import "MKMapView+ZoomLevel.h"

@interface SSMainController () <CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) UIView *navigationView;

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
    self.navigationView.frame = CGRectMake(16, 16, self.view.frame.size.width - 32, 88);
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
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"Did Update Location");
    
    //Update User Location
    self.currentUserLocation = newLocation;
    
    //Set Region
    [self.mapView setCenterCoordinate:self.currentUserLocation.coordinate zoomLevel:13 animated:YES];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    
    //Super
    [super didReceiveMemoryWarning];
}

@end
