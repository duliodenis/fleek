//
//  ViewController.m
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <UISearchBarDelegate>
@property (nonatomic) NSDictionary *mapLocations;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPOI)];
    self.searchBar.delegate = self;
    
    self.mapLocations = @{@"name": @"ESB", @"latitude": @40.74, @"longitude": @-73.98};
    
    //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    //NSLog(@"lat: %f, lng: %f", coordinate.latitude, coordinate.longitude);
    
    //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate: coordinate addressDictionary: nil];
    //MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    //mapItem.name = self.mapLocations[@"name"];
    //mapItem.phoneNumber = @"212-736-3100";
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [self.mapLocations[@"latitude"] doubleValue];
    newRegion.center.longitude = [self.mapLocations[@"longitude"] doubleValue];
    newRegion.span.latitudeDelta = 0.008388;
    newRegion.span.longitudeDelta = 0.008388;
    
    [self.mapView setRegion:newRegion animated:YES];
    
    CGRect newBounds = self.mapView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.mapView.bounds = newBounds;
}

- (void)searchPOI {
    NSLog(@"Search POI");
   [self.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate Delegate Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = placemark.region.center.latitude;
        newRegion.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        
        newRegion.span = span;
        
        [self.mapView setRegion:newRegion animated:YES];
    }];
}

@end
