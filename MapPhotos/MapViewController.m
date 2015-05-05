//
//  MapViewController.m
//  MapPhotos
//
//  Created by Ouya Zhang on 4/18/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

// Associate MKAnnotations with MKAnnotationViews
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *reuseId = @"MapViewController";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:reuseId];
        annotationView.canShowCallout = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        annotationView.leftCalloutAccessoryView = imageView;
    }
    
    annotationView.annotation = annotation;
    [self updateLeftCalloutAccessoryViewInAnnotationView:annotationView];
    return annotationView;
}

// Add left callout photo for annotation
- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView
{
    UIImageView *imageView = nil;
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    if (imageView) {
        Annotation *annotation = nil;
        if ([annotationView.annotation isKindOfClass:[Annotation class]])
        {
            annotation = (Annotation *)annotationView.annotation;
        }
        if (annotation) {
            PhotosViewController *photosVC = (PhotosViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
            for (PFObject *wallObject in photosVC.wallObjectsArray) {
                NSString *pid = [[NSString alloc]initWithString:[wallObject objectId]];
                if (annotation.pid == pid) {
                    PFFile *image = (PFFile *)[wallObject objectForKey:@"image"];
                    imageView.image = [UIImage imageWithData:image.getData];
                    break;
                }
            }
        }
    }
}

- (void)updateMapViewAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photoAnnotations];
    [self.mapView showAnnotations:self.photoAnnotations animated:YES];
}

// Initialize map
- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
}

// Get Photo Annotations
- (NSArray *)photoAnnotations {
    if (!_photoAnnotations) {
        PhotosViewController *photosVC = (PhotosViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
        NSMutableArray *mutablePhotoAnnotations = [[NSMutableArray alloc]init];
        for (PFObject *wallObject in photosVC.wallObjectsArray) {
            UploadViewController *uploadVC = (UploadViewController *)[self.tabBarController.viewControllers objectAtIndex:2];
            PFGeoPoint *point = wallObject[@"location"];
            Annotation *annotation = [uploadVC getAnnotationFromLat:[NSNumber numberWithDouble:point.latitude]
                                                                lng:[NSNumber numberWithDouble:point.longitude]];
            annotation.title = [wallObject objectForKey:@"comment"];
            annotation.pid = [wallObject objectId];
            [mutablePhotoAnnotations addObject:annotation];
            
        }
        _photoAnnotations = (NSArray *)[mutablePhotoAnnotations copy];
    }
    return _photoAnnotations;
}

@end
