//
//  MapViewController.h
//  MapPhotos
//
//  Created by Ouya Zhang on 4/18/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "UploadViewController.h"
#import "PhotosViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *photoAnnotations;

- (void)updateMapViewAnnotations;
- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView;

@end