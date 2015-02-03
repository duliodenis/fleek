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
#import "LocationAnnotationView.h"


@interface ViewController ()
@property (nonatomic) NSDictionary *mapLocations;
@property (nonatomic) LocationData *locationData;
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


- (void)updateRegion:(LocationData *)locationData {
    self.locationData = locationData;
}


#pragma mark - Annotation Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        NSLog(@"User Location");
        return nil;
    }
    else if ([annotation isKindOfClass:[LocationAnnotationView class]])
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        NSLog(@"Custom Annotation");
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"Atomic"];
        
        return annotationView;
    }
    return nil;
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
    controller.annotation = view.annotation; // thinking of having a property in the view controller for whatever data it needs to present the annotation's details
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.delegate = self;
    
    [self.popover presentPopoverFromRect:view.frame
                                  inView:view.superview
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
}
*/

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
