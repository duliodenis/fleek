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


@interface ViewController ()
@property (nonatomic) NSDictionary *mapLocations;
@property (nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapLocations = @{@"name": @"ESB", @"latitude": @40.74, @"longitude": @-73.98};

    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [self.mapLocations[@"latitude"] doubleValue];
    newRegion.center.longitude = [self.mapLocations[@"longitude"] doubleValue];
    newRegion.span.latitudeDelta = 0.008388;
    newRegion.span.longitudeDelta = 0.008388;
    
    [self.mapView setRegion:newRegion animated:YES];
}


#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Restaurants";
    request.region = self.mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        SearchResultsViewController *destinationVC = [segue destinationViewController];
        [destinationVC setSearchResults:(NSMutableArray *) response.mapItems];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableNotification" object:self];
    }];
}

@end
