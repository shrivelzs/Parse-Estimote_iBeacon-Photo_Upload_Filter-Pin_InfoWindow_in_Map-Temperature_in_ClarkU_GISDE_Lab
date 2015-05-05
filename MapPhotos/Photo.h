//
//  Photo.h
//  MapPhotos
//
//  Created by Ouya Zhang on 4/30/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Photo : UIImage <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *pid;

@end
