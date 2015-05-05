//
//  Annotation.m
//  MapPhotos
//
//  Created by Ouya Zhang on 4/18/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

@end