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
    [PFUser enableAutomaticUser];
    
    // Analytics Tracking App Opening
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

@end
