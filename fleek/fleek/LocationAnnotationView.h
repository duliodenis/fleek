//
//  LocationAnnotationView.h
//  fleek
//
//  Created by Dulio Denis on 2/3/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LocationAnnotationView : MKAnnotationView <MKAnnotation>

@property (nonatomic) float stickerColor;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
