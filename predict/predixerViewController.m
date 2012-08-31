//
//  predixerViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerViewController.h"
#import "predixerAboutViewController.h"
#import "predixerHowToViewController.h"
#import "predixerGameMenuViewController.h"
#import "predixerAppDelegate.h"
#import "FBConnect.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+HTML.h"


@interface predixerViewController ()
- (void)showLoggedIn;
@end

@implementation predixerViewController

@synthesize permissions;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UIImage *fbImage = [UIImage imageNamed:@"btn_Facebook_up.png"]; 
    [btnFacebook setImage:fbImage forState:UIControlStateHighlighted];
    
    UIImage *submitImage = [UIImage imageNamed:@"btn_Submit_up.png"]; 
    [btnSubmit setImage:submitImage forState:UIControlStateHighlighted];
    
    UIImage *aboutImage = [UIImage imageNamed:@"btn_About_up.png"]; 
    [btnAbout setImage:aboutImage forState:UIControlStateHighlighted];
    
    UIImage *howtoImage = [UIImage imageNamed:@"btn_HowTo_up.png"]; 
    [btnHowTo setImage:howtoImage forState:UIControlStateHighlighted];
    
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"publish_stream",@"email",nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
        
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        //[self showLoggedOut];
    } else {
        [self showLoggedIn];
    }
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
    predixerGameMenuViewController *menu = [[predixerGameMenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
    
    [self apiFQLIMe];
}

- (IBAction)pressFacebook:(id)sender
{
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}

- (IBAction)pressSubmit:(id)sender
{
    //PROCESS USER EMAIL AND PASSWORD
    [self showLoggedIn];
}

- (IBAction)pressAbout:(id)sender
{
    predixerAboutViewController *about = [[predixerAboutViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}

- (IBAction)pressHowTo:(id)sender
{
    predixerHowToViewController *howto = [[predixerHowToViewController alloc]init];
    [self.navigationController pushViewController:howto animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
        CGRect frame = self.view.frame;
        frame.origin.y = -138.0f;
        
        // start the slide up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [UIView setAnimationDelegate:self];
        self.view.frame = frame;
        [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([txtEmail isFirstResponder])
    {
        [txtPassword becomeFirstResponder];
    }
    else if ([txtPassword isFirstResponder])
    {
        CGRect frame =  self.view.frame;
        frame.origin.y = 0.0f;
        
        // start the slide up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [UIView setAnimationDelegate:self];
        self.view.frame = frame;
        [UIView commitAnimations];
        
        [txtPassword resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    [self showLoggedIn];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
    
    //[pendingApiCallsController userDidGrantPermission];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    //[pendingApiCallsController userDidNotGrantPermission];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    //pendingApiCallsController = nil;
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //[self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    NSData * dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/?access_token=%@", delegate.facebook.accessToken]]];
    
    //NSDictionary *response = (NSDictionary*)[[JSONDecoder decoder] objectWithData:dt];
    
    NSString *response = [[NSString alloc] initWithData:dt encoding:NSUTF8StringEncoding];
 	NSLog(@"Login JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *responseInfo = [response JSONValue];

    
    NSLog(@"fb response %@",response);
    
    if (response.length > 0)
    {
        // Check and retrieve authorization information
        
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"id"] forKey:@"fbId"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"email"] forKey:@"fbEmail"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"name"] forKey:@"fbName"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"first_name"] forKey:@"fbFirstName"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"last_name"] forKey:@"fbLastName"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"username"] forKey:@"fbUsername"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"gender"] forKey:@"fbGender"];
        
       
        
        //NSLog(@"email item: %@", [responseInfo objectForKey:@"email"]);
        //NSLog(@"email item: %@", [[responseInfo objectForKey:@"email"] stringByDecodingHTMLEntities]);
        //NSLog(@"email item: %@", [[responseInfo objectForKey:@"email"] stringByConvertingHTMLToPlainText]);
        
        NSDictionary *aLocation = [responseInfo objectForKey:@"location"];
        
        // NSLog(@"arrlocation item: %@", aLocation);
        
        
        // NSString *locationString = [NSString stringWithUTF8String:[[aLocation objectForKey:@"name"] cStringUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *str = [aLocation objectForKey:@"name"];
        
        str = [str stringByReplacingOccurrencesOfString:@"\u00f1"
                                             withString:@"ñ"];
        
        NSLog(@"arrlocation item: %@", str);
        
        NSLog(@"aLocation item: %@", [[aLocation objectForKey:@"name"] stringByDecodingHTMLEntities]);
        
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fbLocation"];
        
        [[NSUserDefaults standardUserDefaults] setValue:delegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
        [[NSUserDefaults standardUserDefaults] setValue:delegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        //[self apiGraphUserPermissions];        
    }
    /*
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Result: %@", result);
    NSDictionary *userInfo = (NSDictionary *)result;
    NSString *userName = [userInfo objectForKey:@"name"];
    NSString *fb_id = [userInfo objectForKey:@"uid"];
    
    NSLog(@"userName: %@", userName);
    NSLog(@"fb_id: %@", fb_id);
    
    for (id key in result) {        
        NSLog(@"key: %@, value: %@", key, [result objectForKey:key]);
    }
    
    
    
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        //nameLabel.text = [result objectForKey:@"name"];
        // Get the profile image
        
        NSLog(@"name: %@", [result objectForKey:@"name"]);
        NSLog(@"id: %@", [result objectForKey:@"id"]);
        
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        //UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //[profilePhotoImageView setImage:imgThumb];
       
        
        [self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
           */
     nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"didFinishFacebookLoginRequest" object:nil];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

@end
