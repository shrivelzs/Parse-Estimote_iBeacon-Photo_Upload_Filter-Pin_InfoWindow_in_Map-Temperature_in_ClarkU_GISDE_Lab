//
//  PhotosViewController.h
//  MapPhotos
//
//  Created by Ouya Zhang on 3/26/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController: UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *wallScroll;
@property (nonatomic, retain) NSArray *wallObjectsArray;
-(void)zoomToLocationWithLat:(NSNumber *)lat lng:(NSNumber *)lng;

@end