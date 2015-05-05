//
//  RegisterViewController.m
//  MapPhotos
//
//  Created by Ouya Zhang on 4/1/15.
//  Copyright (c) 2015 idce399. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userRegisterTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordRegisterTextField;


- (IBAction)signupPressed:(id)sender;

@end

@implementation RegisterViewController
@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}


#pragma mark IB Actions

////Sign Up Button pressed
-(IBAction)signupPressed:(id)sender
{
    //1
    PFUser *user = [PFUser user];
    //2
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    //3
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            //If signup sucessful
            [self.navigationController performSegueWithIdentifier:@"signupSuccessful" sender:sender];
        }else {
            // Something went wrong
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

@end
