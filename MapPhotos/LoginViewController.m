//
//  LoginViewController.m
//  MapPhotos
//
//  Created by Ouya Zhang on 3/24/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginPressed:(id)sender;
@end

@implementation LoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // For test only
    self.userTextField.text = @"newuser";
    self.passwordTextField.text = @"password";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userTextField = nil;
    self.passwordTextField = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.userTextField.text
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                
        if(user) {
            [self.navigationController performSegueWithIdentifier:@"loginSuccessful" sender:sender];
        }
        else {
            // Something went wrong.
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:errorString
                                                                    delegate: nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil, nil];
            [errorAlertView show];
        }
    }];
}



@end
