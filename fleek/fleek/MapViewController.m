//
//  MapViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/10/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "LocationData.h"
#import "SearchResultsViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // LocationManager to enable reporting the user's position
    if ( [CLLocationManager locationServicesEnabled] ) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // New in iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
            
            CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
            if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
                authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
                
                [self.locationManager startUpdatingLocation];
                self.mapView.showsUserLocation = YES;
            }
            
            self.locationManager.distanceFilter = 1000;
            [self.locationManager startUpdatingLocation];
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.75, -73.98);
            CLLocationDistance radius = 30.0;
            
            CLCircularRegion *region2 = [[CLCircularRegion alloc] initWithCenter:center
                                                                          radius:radius
                                                                      identifier:@"userRegion"];
            
            MKCoordinateSpan span = MKCoordinateSpanMake(10, 10);
            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
            [self.mapView setRegion:region animated:YES];
            
            if ( [CLLocationManager isMonitoringAvailableForClass:[region2 class]] ) {
                // Apple's documentation says to check authorization after determining monitoring is available.
                //            CLLocationAccuracy accuracy = 1.0;
                //            [self.locationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
                NSLog(@"Region monitoring available.");
            } else {
                NSLog(@"Warning: Region monitoring not supported on this device."); }
        }
    }
}


- (void)setMapRegion:(CLLocation *)location {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - LocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    [self setMapRegion:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [error description]);
}


#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Restaurants";
    request.region = self.mapView.region;
    
    LocationData *locationData = [[LocationData alloc] init];
    locationData.region = self.mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        SearchResultsViewController *destinationVC = [segue destinationViewController];
        locationData.searchResults = (NSMutableArray *)response.mapItems;
        [destinationVC setLocationData:locationData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableNotification" object:self];
    }];
}

@end
