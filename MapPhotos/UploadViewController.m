//
//  UploadViewController.m
//  MapPhotos
//
//  Created by Ouya Zhang on 4/1/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

//#import <CoreLocation/CoreLocation.h>
#import "UploadViewController.h"
#import "MapViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface UploadViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgToUpload;
@property(nonatomic, strong) UIScrollView *scrollView;

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) NSString *username;
- (IBAction)sendPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) NSNumber *imgLatitude;
@property (strong, nonatomic) NSNumber *imgLongitude;
//for filter process
@property (nonatomic, strong)CIContext *context;

@property(nonatomic, strong)CIImage *Cimage;


@end

@implementation UploadViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize username = _username;
@synthesize commentTextField = _commentTextField;
@synthesize uploadButton = _uploadButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}
//functions for filter

//action will perform when tap subview
-(IBAction)setImageStyle:(UITapGestureRecognizer *)sender
{
    UIImage *newImage = [self changeImage:sender.view.tag];
    //NSLog(@"%ld",(long)sender.view.tag);
    [_imgToUpload setImage:newImage];
    
    
}

-(UIImage *)changeImage:(NSInteger)index
{
    UIImage *image;
    
    
    //8 filter could be selected, the filter are made by Core Image
    switch (index) {
        case 0:
        {
            return _imgToUpload.image;
            
        }
            break;
        case 1:
        {
            image = [self processImagewithFilter:@"CISepiaTone"];
            
        }
            break;
        case 2:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectTonal"];
        }
            break;
        case 3:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectChrome"];
        }
            break;
        case 4:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectMono"];
        }
            break;
        case 5:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectFade"];
        }
            break;
        case 6:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectInstant"];
        }
            break;
        case 7:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectTonal"];
        }
            break;
        case 8:
        {
            image = [self processImagewithFilter:@"CIPhotoEffectTransfer"];
        }
            break;
            
    }
    return image;
    
    
}

-(UIImage *)processImagewithFilter:(NSString *)filterName
{
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:_Cimage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [_context createCGImage:result fromRect:extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    
    return newImage;
    
    
}








//functions for photo select
-(void)dismissKeyboard {
    [self.commentTextField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.username = nil;
    self.commentTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateMapViewWithAnnotation:(Annotation *)annotation {
    MapViewController *mapVC = (MapViewController *)[self.tabBarController.viewControllers objectAtIndex:1];
    [mapVC.mapView addAnnotation:annotation];
}

-(NSDictionary *)getLatLngFromGPSDictionary:(NSDictionary *)gps_dict  {
    
    double latitude = [[gps_dict objectForKey:@"Latitude"] doubleValue];
    double longitude = [[gps_dict objectForKey:@"Longitude"] doubleValue];
    if ([[gps_dict objectForKey:@"LatitudeRef"] isEqualToString:@"S"]) {
        latitude = -latitude;
    }
    if ([[gps_dict objectForKey:@"LongitudeRef"] isEqualToString:@"W"]) {
        longitude = -longitude;
    }
    
    NSDictionary *latLngDictionary = [[NSDictionary alloc]
                                        initWithObjectsAndKeys:[NSNumber numberWithDouble:latitude] ,@"Latitude",
                                                                [NSNumber numberWithDouble:longitude], @"Longitude",
                                                                nil];
    return latLngDictionary;
}

-(Annotation *)getAnnotationFromLat:(NSNumber *)latitude lng:(NSNumber *)longitude {
    Annotation *annotation = [[Annotation alloc]init];
    annotation.latitude = latitude;
    annotation.longitude = longitude;
    
    return annotation;
}

#pragma mark IB Actions

-(IBAction)choosePhoto:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = true;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = true;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

-(IBAction)sendPressed:(id)sender
{
    if (!self.imgToUpload.image) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Please Select Photo to Upload"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
        [errorAlertView show];
        return;
    }
    [self.commentTextField resignFirstResponder];
    
    //Disable the send button until we are ready
    
    self.uploadButton.enabled = NO;
    
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [loadingSpinner startAnimating];
    
    [self.view addSubview:loadingSpinner];
    
    NSData *pictureData = UIImagePNGRepresentation(self.imgToUpload.image);
    
    // 1
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded) {
            //2
            // Add the image to the object, and add the comment and the user
            PFObject *imageObject = [PFObject objectWithClassName:@"WallImageObject"];
            [imageObject setObject:file forKey:@"image"];
            [imageObject setObject:[PFUser currentUser].username forKey:@"user"];
            [imageObject setObject:self.commentTextField.text forKey:@"comment"];
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[self.imgLatitude doubleValue]
                                                       longitude:[self.imgLongitude doubleValue]];
            imageObject[@"location"] = point;
            //3
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //4
                if(succeeded) {
                    //Reset and Go back to the wall
                    //[self.navigationController popViewControllerAnimated:YES];
                    self.uploadButton.enabled = YES;
                    self.imgToUpload.image = nil;
                    [self.tabBarController setSelectedIndex:0];
                    
                    if (self.imgLatitude != (NSNumber *)nil && self.imgLongitude != (NSNumber *)nil) {
                        Annotation *annotation = [self getAnnotationFromLat:self.imgLatitude lng:self.imgLongitude];
                        [self updateMapViewWithAnnotation:annotation];
                    }
                }else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
        }else {
            //5
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d %%", percentDone);
    }];
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
             resultBlock:^(ALAsset *asset) {
                 NSDictionary *metadata = asset.defaultRepresentation.metadata;
                 NSLog(@"exif_dict: %@", metadata);
                 
                 ALAssetRepresentation *image_representation = [asset defaultRepresentation];
                 
                 // create a buffer to hold image data
                 uint8_t *buffer = (Byte*)malloc(image_representation.size);
                 NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0  length:image_representation.size error:nil];
                 
                 if (length != 0)  {
                     
                     // buffer -> NSData object; free buffer afterwards
                     NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
                     
                     // identify image type (jpeg, png, RAW file, ...) using UTI hint
                     NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:(id)[image_representation UTI] ,kCGImageSourceTypeIdentifierHint,nil];
                     
                     // create CGImageSource with NSData
                     CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) adata,  (__bridge CFDictionaryRef) sourceOptionsDict);
                     
                     // get imagePropertiesDictionary
                     CFDictionaryRef imagePropertiesDictionary;
                     imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(sourceRef,0, NULL);
                     
                     // get gps data
                     CFDictionaryRef gps = (CFDictionaryRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyGPSDictionary);
                     NSDictionary *gps_dict = (__bridge NSDictionary*)gps;
                     
                     
                     // get latlng if the gps dictionary is not empty
                     if (gps_dict != (NSDictionary *)nil)
                     {
                         NSDictionary *latLngDict = [self getLatLngFromGPSDictionary:gps_dict];
                         self.imgLatitude = (NSNumber *)[latLngDict objectForKey:@"Latitude"];
                         self.imgLongitude = (NSNumber *)[latLngDict objectForKey:@"Longitude"];
                     }

                 }
                 else {
                     NSLog(@"image_representation buffer length == 0");
                 }
             }
            failureBlock:^(NSError *error) {
                NSLog(@"couldn't get asset: %@", error);
            }
     ];
    //Place the image in the imageview
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgToUpload.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    
    
    //add filter subviews
    //Label will show under the filter subView
    NSArray *filterName = [NSArray arrayWithObjects:@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8", nil];
    //the filter subview windows will be added in a scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 140, self.view.bounds.size.width, 80)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    //Core Image Filter
    _context = [CIContext contextWithOptions:nil];
    _Cimage = [[CIImage alloc]initWithImage:self.imgToUpload.image];
    
    
    //calculate positions for every filter view
    float x = 0.0;
    for (NSInteger i = 0; i < 8; i++) {
        x = 10 + 51*i;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        //recognizer.delegate = self;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 53, 40, 23)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[filterName objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor blackColor]];
        [label setUserInteractionEnabled:YES];
        [label setTag:i];
        
        [label addGestureRecognizer:recognizer];
        
        [_scrollView addSubview:label];
        
        UIImageView *subImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 40, 43)];
        [subImageView setTag:i];
        [subImageView addGestureRecognizer:recognizer];
        [subImageView setUserInteractionEnabled:YES];
        ////
        UIImage *subImage = [self changeImage:i ];
        subImageView.image = subImage;
        
        
        [_scrollView addSubview:subImageView];
    }
    _scrollView.contentSize = CGSizeMake(x + 55, 80);
    [self.view addSubview:_scrollView];

    
}

#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

@end
