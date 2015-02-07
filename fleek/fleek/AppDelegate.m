//
//  AppDelegate.m
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"eSzBJHobsgvoUPKNg4iEbuZ2ce1RPFVmJdDPox1V" clientKey:@"BIicNk1hC9UNyfSjCaN51ahqSxk9LeeKF8w7EyhN"];
    
    // Parse Test Code that Saves the Empire State Building Point of Interest
    PFObject *poi = [PFObject objectWithClassName:@"POI"];
    [poi setObject:@"ESB" forKey:@"Name"];
    [poi setObject:@40.74 forKey:@"Latitude"];
    [poi setObject:@-73.98 forKey:@"Longitude"];
    [poi save];
    
    return YES;
}

@end
