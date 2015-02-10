//
//  AppDelegate.m
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"eSzBJHobsgvoUPKNg4iEbuZ2ce1RPFVmJdDPox1V" clientKey:@"BIicNk1hC9UNyfSjCaN51ahqSxk9LeeKF8w7EyhN"];
    
    [PFUser enableAutomaticUser];
    
//    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (error) {
//            NSLog(@"Anonymous login failed.");
//        } else {
//            NSLog(@"Anonymous user logged in.");
//            PFUser *user = [PFUser currentUser];
//            if (user) NSLog(@"Current user = %@", user);
//            
//            // Parse Test Code that Saves the Empire State Building Point of Interest
//            PFObject *poi = [PFObject objectWithClassName:@"POI"];
//            [poi setObject:@"ESB" forKey:@"Name"];
//            [poi setObject:@40.74 forKey:@"Latitude"];
//            [poi setObject:@-73.98 forKey:@"Longitude"];
//            [poi setObject:user forKey:@"user"];
//            [poi save];
//        }
//    }];

    // Analytics Tracking App Opening
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    // LocationManager to enable reporting the user's position
    if ( [CLLocationManager locationServicesEnabled] ) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        // New in iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager startUpdatingLocation];
        
        
        
        if ( [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] ) {
//            CLLocationAccuracy accuracy = 1.0;
//            [self.locationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
            NSLog(@"Region monitoring available.");
        } else {
            NSLog(@"Warning: Region monitoring not supported on this device."); }
    }
    
    return YES;
}


#pragma mark - LocationManager Delegate Methods

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"Location: %@", [newLocation description]);
//}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"Locations Updated to: %@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [error description]);
}

@end
