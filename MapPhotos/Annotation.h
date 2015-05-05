//
//  Annotation.h
//  MapPhotos
//
//  Created by Ouya Zhang on 4/18/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *pid;

//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//-(Annotation *)initAnnotationWithLocation:(NSDictionary *)location;

@end
