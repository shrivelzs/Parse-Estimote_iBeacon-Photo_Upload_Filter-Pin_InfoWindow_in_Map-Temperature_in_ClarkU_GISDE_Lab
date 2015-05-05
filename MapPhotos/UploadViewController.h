//
//  UploadViewController.h
//  MapPhotos
//
//  Created by Ouya Zhang Shu Zhang on 4/1/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface UploadViewController : UIViewController <UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

-(void)updateMapViewWithAnnotation:(Annotation *)annotation;
-(NSDictionary *)getLatLngFromGPSDictionary:(NSDictionary *)gps_dict;
-(Annotation *)getAnnotationFromLat:(NSNumber *)latitude lng:(NSNumber *)longitude;

@end
