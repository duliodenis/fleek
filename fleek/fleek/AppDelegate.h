//
//  AppDelegate.h
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CLLocationManager *locationManager;
@end

