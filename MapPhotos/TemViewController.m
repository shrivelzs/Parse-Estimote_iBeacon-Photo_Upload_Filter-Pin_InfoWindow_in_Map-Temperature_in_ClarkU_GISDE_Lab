//
//  ViewController.m
//  TM33
//
//  Created by Shu Zhang on 4/21/15.
//  Copyright (c) 2015 Shu Zhang. All rights reserved.
//

#import "TemViewController.h"
#import "cloudsView.h"
#import "earthView.h"
#import "superman.h"




@interface TemViewController ()<ESTBeaconConnectionDelegate>
{
    earthView *newearthView;
    superman *newSuperman;
    cloudsView *newCloud;
    NSTimer *theTimer;
    NSTimer *theTwinkleTemLabelTimer;
    UILabel *activityLabel;
    
}
//@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;




@property (nonatomic,strong) ESTBeaconConnection *beaconConnection;

@property (nonatomic, strong) NSTimer *readTemperatureWithInterval;
//@property (nonatomic, strong) loadingAnimation *activityIndicator;

@end

@implementation TemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.0f, 4, self.view.bounds.size.width/2.0f, self.view.bounds.size.height/3.0f)];
    
    activityLabel.font = [UIFont boldSystemFontOfSize:20];
    activityLabel.text = @"CONNECTING...";
    [self.view addSubview:activityLabel];
    
    
    
    self.temperatureLabel.alpha = 0;
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    
    self.beaconConnection = [ESTBeaconConnection  connectionWithProximityUUID:uuid major:30229 minor:30723 delegate:self] ;
    //twinkle label
    float theInterval = 1.0f;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target:self selector:@selector(twinkleLabel) userInfo:nil repeats:YES];
    
   
    
    
    
    
    
    
    

    //start animation
     newearthView = [[earthView alloc]initWithFrame:self.view.bounds];
     [self.view addSubview:newearthView];
     newSuperman = [[superman alloc]initWithFrame:self.view.bounds];
     [self.view addSubview:newSuperman];
     newCloud = [[cloudsView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
     [self.view addSubview:newCloud];
    
    
    [self.beaconConnection startConnection];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.beaconConnection.connectionStatus == ESTConnectionStatusConnected || self.beaconConnection.connectionStatus == ESTConnectionStatusConnecting)
    {
        if (self.readTemperatureWithInterval)
        {
            [self.readTemperatureWithInterval invalidate];
            self.readTemperatureWithInterval = nil;
        }
        
        [self.beaconConnection cancelConnection];
    }
}
#pragma mark - Animation Function
-(void)twinkleLabel
{
    float labelAlpha = activityLabel.alpha;
    labelAlpha = (labelAlpha == 1.0f)?0:1.0f;
    [UIView animateWithDuration:1.0f animations:^{
        activityLabel.alpha = labelAlpha;
    }];

}

#pragma mark - Beacon Operations
- (void)readBeaconTemperature
{
    //Reading temperature is asynchronous task, so we need to wait for completion block to be called.
    [self.beaconConnection readTemperatureWithCompletion:^(NSNumber* value, NSError *error) {
        
        if (!error)
        {
            
            self.temperatureLabel.font = [UIFont boldSystemFontOfSize:30];
            self.temperatureLabel.shadowColor = [UIColor colorWithRed:0.855 green:0.863 blue:0.882 alpha:1.0];
            //Temperature twinkleLabel
            
            
          
            
            self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f°C/%.1f°F", [value floatValue],(([value floatValue]*9)/5+32)];
            
            
            //[self.activityIndicator endAnimation];
            //end animation
            [newearthView removeFromSuperview];
            [newSuperman removeFromSuperview];
            [newCloud removeFromSuperview];

        }
        else
        {
            activityLabel.text = [NSString stringWithFormat:@"Error:%@", [error localizedDescription]];
            activityLabel.textColor = [UIColor redColor];
        }
    }];
}
-(void)startTemLabelAnimation
{
    
    //begin animation
    [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:7.0f initialSpringVelocity:4.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.temperatureLabel.alpha = 0.f;
        self.temperatureLabel.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:7.f initialSpringVelocity:4.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.temperatureLabel.alpha = 1.f;
            self.temperatureLabel.transform = CGAffineTransformMakeScale(1.f, 1.f);
        } completion:nil];
        
        
    }];
    
}




#pragma mark - ESTBeaconDelegate
- (void)beaconConnectionDidSucceed:(ESTBeaconConnection *)connection
{
    //[self.activityIndicator endAnimation];
    //end animation
    [newearthView removeFromSuperview];
    [newSuperman removeFromSuperview];
    [newCloud removeFromSuperview];
    [theTimer invalidate];
    [activityLabel removeFromSuperview];
    [UIView animateWithDuration:1.0f animations:^{
        self.temperatureLabel.alpha = 1;
    }];
     theTwinkleTemLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(startTemLabelAnimation) userInfo:nil repeats:YES];

    
    
    
    activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5.0f, 4, self.view.bounds.size.width, self.view.bounds.size.height/3.0f)];
    
    activityLabel.font = [UIFont boldSystemFontOfSize:20];
    
    activityLabel.text = @"Lab temperature is:";
    [self.view addSubview:activityLabel];

    
    
    
    
 
    
    //After successful connection, we can start reading temperature.
    self.readTemperatureWithInterval = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                                        target:self
                                                                      selector:@selector(readBeaconTemperature)
                                                                      userInfo:nil repeats:YES];
    
    [self readBeaconTemperature];
}

- (void)beaconConnection:(ESTBeaconConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Something went wrong. Beacon connection Did Fail. Error: %@", error);
    
    //[self.activityIndicator stopAnimating];
    //end animation
    [newearthView removeFromSuperview];
    [newSuperman removeFromSuperview];
    [newCloud removeFromSuperview];

    //self.activityIndicator.alpha = 0.;
    
    activityLabel.text = @"Connection failed";
    activityLabel.textColor = [UIColor redColor];
    
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Connection error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}


@end
