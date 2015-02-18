//
//  MapViewController.m
//  fleek
//
//  Created by Dulio Denis on 2/10/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "MapViewController.h"
#import "LocationData.h"
#import "SearchResultsViewController.h"
#import "LocationAnnotationView.h"
#import "SWRevealViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate, SWRevealViewControllerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) LocationAnnotationView *currentAnnotation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@end


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentAnnotation = nil;
    self.mapView.delegate = self;
    
    // The Menu Bar Button
    self.revealViewController.delegate = self;
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
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
    
    [self loadPOIs];
}


- (void)setMapRegion:(CLLocation *)location {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - Parse POI Save and Load Methods

- (void)loadPOIs {
    PFQuery *query = [PFQuery queryWithClassName:@"POI"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self makePinInMap:objects];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}


- (void)savePOIs {
    PFUser *user = [PFUser currentUser];
    PFObject *poi = [PFObject objectWithClassName:@"POI"];
    [poi setObject:self.currentAnnotation.title forKey:@"name"];
    [poi setObject:self.currentAnnotation.subtitle forKey:@"subtitle"];
    [poi setObject:user forKey:@"user"];
/*
    NSNumber *latituteNumber = [NSNumber numberWithDouble:self.currentAnnotation.coordinate.latitude];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:self.currentAnnotation.coordinate.longitude];
    [poi setObject:latituteNumber forKey:@"Latitude"];
    [poi setObject:longitudeNumber forKey:@"Longitude"];
*/
    PFGeoPoint *locationCoordinate = [PFGeoPoint new];
    locationCoordinate.longitude = self.currentAnnotation.coordinate.longitude;
    locationCoordinate.latitude = self.currentAnnotation.coordinate.latitude;
    [poi setObject:locationCoordinate forKey:@"coordinate"];
    
    [poi saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Save to Parse Successful.");
        } else {
            NSLog(@"Save to Parse Failure.");
        }
    }];
}


#pragma mark - Helper Map Methods

- (void)makePinInMap:(NSArray*)pins {
    for (PFObject *pin in pins) {
        PFGeoPoint *locationCoordinate = [pin objectForKey:@"coordinate"];
        
        CLLocationDegrees latitude = locationCoordinate.latitude;
        CLLocationDegrees longitude = locationCoordinate.longitude;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        LocationAnnotationView *annotation = [[LocationAnnotationView alloc] initWithCoordinate:coordinate];
        annotation.title = [pin objectForKey:@"name"];
        annotation.subtitle = [pin objectForKey:@"subtitle"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:annotation];
        });
    }
}


#pragma mark - LocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    [self setMapRegion:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location Manager Error: %@", [error description]);
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


#pragma mark - Annotation Methods

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //first make sure the annotation is our custom class...
    if ([view.annotation isKindOfClass:[LocationAnnotationView class]])
    {
        //cast the object to our custom class...
        LocationAnnotationView *annotation = (LocationAnnotationView *)view.annotation;
        self.currentAnnotation = annotation;
    
        //show one alert view with title set to annotation's title
        //and message set to annotation's subtitle...
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"Save %@", annotation.title]
                              message:@"Would you like to save this to your favorites?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *myPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    
    UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionsButton.frame = CGRectMake(0, 0, 23, 23);
    [directionsButton setBackgroundImage:[UIImage imageNamed:@"Atomic"] forState:UIControlStateNormal];
    
    myPin.leftCalloutAccessoryView = directionsButton;
    myPin.rightCalloutAccessoryView = calloutButton;
    myPin.draggable = NO;
    myPin.highlighted = NO;
    myPin.animatesDrop= YES;
    myPin.canShowCallout = YES;
    myPin.pinColor = MKPinAnnotationColorPurple;
    
    return myPin;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        NSLog(@"Canceled the Parse Save Operation");
        self.currentAnnotation = nil;
    }
    else {
        [self savePOIs];
    }
}

@end
