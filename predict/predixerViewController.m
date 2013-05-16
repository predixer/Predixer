//
//  predixerViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerViewController.h"
#import "predixerHowToViewController.h"
#import "predixerGameMenuViewController.h"
#import "predixerAppDelegate.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+HTML.h"
#import "DataSystemUser.h"
#import "DataSystemUserController.h"
#import "LoadingController.h"
#import "Constants.h"
#import "DataAddDeviceToken.h"

@interface predixerViewController ()
@end

@implementation predixerViewController

@synthesize permissions;
@synthesize dataUser;
@synthesize dataController;
@synthesize loadingController;
@synthesize appDelegate;
@synthesize menu;
@synthesize deviceTokenController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //lblFailed.text = @"WE NEVER POST TO FACEBOOK.";
    //lblFailed.textColor = [UIColor blackColor];
    
    appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.hasInternetConnection == NO) {
        vwNoInternet.hidden = NO;
    }
    else {
        vwNoInternet.hidden = YES;
    }
    
    if (dataController == nil) {
        dataController = [[DataSystemUserController alloc] init];
        
    }
    
    
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];
    
    nc = [NSNotificationCenter defaultCenter];
    
    //observer
    [nc addObserver:self
           selector:@selector(didFinishSystemUserLogin)
               name:@"didFinishSystemUserLogin"
             object:nil];
    
    UIImage *fbImage = [UIImage imageNamed:@"btn_Facebook_up.png"]; 
    [btnFacebook setImage:fbImage forState:UIControlStateHighlighted];
    
    UIImage *submitImage = [UIImage imageNamed:@"btn_Submit_up.png"]; 
    [btnSubmit setImage:submitImage forState:UIControlStateHighlighted];
    
    //lblFailed.hidden = YES;
    
    if (![[appDelegate facebook] isSessionValid])
    {
        //session invalid reauthorize
        //[[appDelegate facebook] authorize:permissions];
    } else {
        [appDelegate apiGraphMe];
        [self showLoggedIn];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showLoggedIn
{
    if (menu != nil) {
        [menu.view removeFromSuperview];
        [menu removeFromParentViewController];
        menu = nil;
    }
    
    menu = [[predixerGameMenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];    
}

- (IBAction)pressFacebook:(id)sender
{
    if (![[appDelegate facebook] isSessionValid]) {
        [[appDelegate facebook] authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}

- (void)loginFailed {
    //lblFailed.hidden = NO;
    lblFailed.text = @"Failed Facebook login! Try again.";
    lblFailed.textColor = [UIColor redColor];
}

- (IBAction)pressSubmit:(id)sender
{
    
    if (appDelegate.hasInternetConnection) {
        if ([txtEmail isFirstResponder]) {
            [txtEmail resignFirstResponder];
        }
        else if ([txtPassword isFirstResponder])
        {
            [txtPassword resignFirstResponder];
        }
        
        //PROCESS USER EMAIL AND PASSWORD
        
        if ([txtEmail.text length] > 0 && [txtPassword.text length] > 0) {
            
            //check password length
            if ([txtPassword.text length] < 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                                message:@"Password must be at least 6 characters long."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            
            //check if Valid email.
            
            //NSLog(@"email %@", [txtEmail.text lowercaseString]);
            
            BOOL emailIsValid = [self isValidEmail:[txtEmail.text lowercaseString]];
            
            if (emailIsValid == YES) {
                
                loadingController = [[LoadingController alloc] init];
                loadingController.strLoadingText = @"Logging in...";
                [self.view addSubview:loadingController.view];
                
                /*
                 baseAlert = [[UIAlertView alloc] initWithTitle:@"Logging In..."
                 message:@""
                 delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:nil];
                 [baseAlert show];
                 
                 
                 //Activity indicator
                 aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                 aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
                 [aiv startAnimating];
                 [baseAlert addSubview:aiv];
                 */
                
                [dataController checkSystemUser:txtEmail.text pwd:txtPassword.text];
                
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                                message:@"Please enter a valid Email Address."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Reqired!"
                                                            message:@"Kindly enter your Email and Password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

- (void)didFinishSystemUserLogin
{
    [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
}

- (void)performDismiss
{
    
    [loadingController.view removeFromSuperview];
    
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
    
    if ([dataController countOfList] > 0) {
        dataUser = [dataController objectInListAtIndex:0];
        
        if ([dataUser.userName length] > 0) {
            
            //NSLog(@"userId %@", dataUser.userID);
            
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.userID forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.userID forKey:@"fbId"];
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.email forKey:@"fbEmail"];
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.userName forKey:@"fbName"];
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.userName forKey:@"fbFirstName"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fbLastName"];
            [[NSUserDefaults standardUserDefaults] setValue:dataUser.userName forKey:@"fbUsername"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fbGender"];
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"isFBUser"];
            
            if (deviceTokenController == nil) {
                deviceTokenController = [[DataAddDeviceToken alloc] init];
                
                
                //save token to database
                [deviceTokenController addToken:[NSString stringWithFormat:@"%@",appDelegate.appDeviceToken]];
            }
            
            
            if ([dataUser.isWrongPassword isEqualToString:@"Yes"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                message:@"You have entered a wrong Password."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                
                txtEmail.text = @"";
                txtPassword.text = @"";
                
                [self showLoggedIn];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                            message:@"Kindly check your Email and Password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                        message:@"Kindly check your Email and Password."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    [nc postNotificationName:@"didSystemLogin" object:nil];
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE5 == NO) {
        CGRect frame = self.view.frame;
        frame.origin.y = -138.0f;
        
        // start the slide up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [UIView setAnimationDelegate:self];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([txtEmail isFirstResponder])
    {
        [txtPassword becomeFirstResponder];
    }
    else if ([txtPassword isFirstResponder])
    {
        if (IS_IPHONE5 == NO) {
        CGRect frame =  self.view.frame;
        frame.origin.y = 0.0f;
        
        // start the slide up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [UIView setAnimationDelegate:self];
        self.view.frame = frame;
        [UIView commitAnimations];
        }
        
        [txtPassword resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField :(id)sender
{
    [sender resignFirstResponder];
}




@end
