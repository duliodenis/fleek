//
//  ViewController.h
//  fleek
//
//  Created by Dulio Denis on 1/27/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationData.h"

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet MKMapView *mapView;
- (void)updateRegion:(LocationData *)locationData;

@end

