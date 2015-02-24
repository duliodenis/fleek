//
//  SearchResultsViewController.m
//  fleek
//
//  Created by Dulio Denis on 1/29/15.
//  Copyright (c) 2015 ddApps. See included LICENSE file.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchResultsViewController.h"
#import "MapViewController.h"
#import "LocationData.h"
#import "LocationAnnotationView.h"


@interface SearchResultsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SearchResultsViewController


#pragma mark - ViewLifecycle Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"ReloadTableNotification" object:nil];
}


- (void)reloadTable {
    [self.tableView reloadData];
}


- (void)setLocationData:(LocationData *)locationData {
    _locationData = locationData;
}


#pragma mark - UITableViewDataSource Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MKMapItem *mapItem = self.locationData.searchResults[indexPath.row];
    cell.textLabel.text = mapItem.name;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationData.searchResults.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger myVCIndex = [self.navigationController.viewControllers indexOfObject:self];
    MapViewController *mapVC = [self.navigationController.viewControllers objectAtIndex:myVCIndex-1];
    
    MKMapItem *mapItem = self.locationData.searchResults[indexPath.row];
    MKPlacemark *placemark = mapItem.placemark;
    
    LocationAnnotationView *annotation = [[LocationAnnotationView alloc] initWithPlacemark:placemark];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 2000, 2000);
    [mapVC.mapView setRegion:region animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mapVC.mapView addAnnotation:annotation];
    });

    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = searchBar.text;
        request.region = self.locationData.region;
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            self.locationData.searchResults = (NSMutableArray *)response.mapItems;
            [self.tableView reloadData];
    }];
}

@end
