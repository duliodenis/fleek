//
//  ViewController.m
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "SearchResultsViewController.h"


@interface ViewController () //<UISearchBarDelegate>
@property (nonatomic) NSDictionary *mapLocations;
@property (nonatomic) IBOutlet MKMapView *mapView;
// @property (nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* do this in the Storyboard in IB
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPOI)];
    self.searchBar.delegate = self;
     
    CGRect newBounds = self.mapView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.mapView.bounds = newBounds;

     */
    
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
}

#pragma mark - UISearchBarDelegate Delegate Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Restaurants";
    request.region = self.mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSLog(@"Returned MapItems = %lu", (unsigned long)response.mapItems.count);
        SearchResultsViewController *destinationVC = [segue destinationViewController];
        [destinationVC setSearchResults:(NSMutableArray *) response.mapItems];
    }];
}

@end
