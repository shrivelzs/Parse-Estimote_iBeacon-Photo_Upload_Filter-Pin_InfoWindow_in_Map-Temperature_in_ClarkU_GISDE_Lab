//
//  PhotosViewController.m
//  MapPhotos
//
//  Created by Ouya Zhang on 3/26/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import "PhotosViewController.h"
#import <Parse/Parse.h>
#import "MapViewController.h"
#import "UploadViewController.h"
#import "Photo.h"

@interface PhotosViewController () {
    
}


@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


-(void)getWallImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@end

@implementation PhotosViewController
@synthesize wallObjectsArray = _wallObjectsArray;
@synthesize wallScroll = _wallScroll;
@synthesize activityIndicator = _loadingSpinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.wallScroll = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //Reload the wall
    [self getWallImages];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Wall Load
//Load the images on the wall
-(void)loadWallViews
{
    // Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]) {
        
        if ([viewToRemove isMemberOfClass:[UIView class]]) {
            [viewToRemove removeFromSuperview];
        }
    }
    
    // For every wall element, put a view in the scroll
    int originY = 15;
    
    for (PFObject *wallObject in self.wallObjectsArray) {
        //1
        // Build the view with the image and the comments
        UIView *wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 300)];
        
        //2
        // Add the image
        PFFile *image = (PFFile *)[wallObject objectForKey:@"image"];
        UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        userImage.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 280);
        // Add long press action
        userImage.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(handleLongPress:)];
        lpgr.delegate = self;
        [userImage addGestureRecognizer:lpgr];
        [wallImageView addSubview:userImage];
        
        //3
        //Add the info label (User and creation date)
        NSDate *creationDate = wallObject.createdAt;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm dd/MM yyyy"];
        
        //4
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, wallImageView.frame.size.width, 10)];
        infoLabel.text = [NSString stringWithFormat:@"Uploaded by: %@, %@", [wallObject objectForKey:@"user"], [df stringFromDate:creationDate]];
        infoLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:9];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:infoLabel];
        
        //5
        // Add the comment.66
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, wallImageView.frame.size.width, 15)];
        commentLabel.text = [wallObject objectForKey:@"comment"];
        commentLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:commentLabel];
        
        //6
        [self.wallScroll addSubview:wallImageView];
        
        originY = originY + wallImageView.frame.size.width + 20;
    }
    
    //7
    // Set the bounds of the scroll
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
}

-(void)zoomToLocationWithLat:(NSNumber *)lat lng:(NSNumber *)lng
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [lat doubleValue];
    region.center.longitude = [lng doubleValue];
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta = 0.15f;
    [self.tabBarController setSelectedIndex:1];
    MapViewController *mapVC = (MapViewController *)[self.tabBarController.viewControllers objectAtIndex:1];
    [mapVC.mapView setRegion:region animated:YES];
}

// Handle the long press gesture
-(void)handleLongPress:(UILongPressGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertController *view = [UIAlertController alertControllerWithTitle:@"Options"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *map = [UIAlertAction actionWithTitle:@"Map"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        // TODO: map photo on the map
                                                    }];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           // TODO: delete photo
                                                       }];
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];

        [view addAction:map];
        [view addAction:delete];
        [view addAction:cancel];
        [self presentViewController: view animated:YES completion:nil];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"End!");
    }
}

#pragma mark Receive Wall Objects

//Get the list of images
-(void)getWallImages
{
    // Prepare the query to get all the images in descending order.
    //1
    PFQuery *query = [PFQuery queryWithClassName:@"WallImageObject"];
    //2
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3
        if(!error) {
            // Everything was correct, put the new objects and load the wall.
            self.wallObjectsArray = nil;
            self.wallObjectsArray = [[NSArray alloc] initWithArray:objects];
            [self loadWallViews];
        }else {
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}


#pragma mark IB Actions


-(IBAction)logoutPressed:(id)sender
{
    [PFUser logOut];
    //If logout succesful:
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

@end
