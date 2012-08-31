//
//  predixerGameMenuViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerGameMenuViewController.h"
#import "predixerGamePlayViewController.h"
#import "predixerGameFindFriendsViewController.h"
#import "predixerHowToViewController.h"
#import "predixerGameLeaguesViewController.h"
#import "facebookAPIViewController.h"
#import "DataFacebookUser.h"
#import "DataFacebookUserController.h"
#import "DataFacebookUserAdd.h"
#import "DataFacebookUserRecordLogin.h"
#import "predixerSettingsViewControllerViewController.h"


@interface predixerGameMenuViewController ()

- (void)didFinishLoadingFacebookFriends:(NSNotification *)notification;
- (void)didFinishLoadingFacebookFriendsWithApp:(NSNotification *)notification;

@end

@implementation predixerGameMenuViewController

@synthesize fbApi;
@synthesize dataController;
@synthesize dataUser;
@synthesize addUser;
@synthesize updateUserLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataController == nil) {
            dataController = [[DataFacebookUserController alloc] init];
            
            NSLog(@"Count at init: %d", [dataController countOfList]);
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //LEFT NAV BUTTON    
    // Set the custom back button
	UIImage *backButtonNormalImage = [UIImage imageNamed:@"btn_Logo.png"];
	UIImage *backButtonHighlightImage = [UIImage imageNamed:@"btn_Logo.png"];
    
	//create the button and assign the image
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:backButtonNormalImage forState:UIControlStateNormal];
	[backButton setImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	backButton.frame = CGRectMake(0, 0, 33, 39);
    
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = customBackBarItem;
    
    
    //RIGHT NAV BUTTON    
    // Set the custom back button
	UIImage *settingsButtonNormalImage = [UIImage imageNamed:@"btn_Settings.png"];
	UIImage *settingsButtonHighlightImage = [UIImage imageNamed:@"btn_Settings_up.png"];
    
	//create the button and assign the image
	UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[settingsButton setImage:settingsButtonNormalImage forState:UIControlStateNormal];
	[settingsButton setImage:settingsButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	settingsButton.frame = CGRectMake(0, 0, settingsButtonNormalImage.size.width, settingsButtonNormalImage.size.height);
    
	[settingsButton addTarget:self action:@selector(pressSettings:) forControlEvents:UIControlEventTouchUpInside];
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customSettingsBarItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
	self.navigationItem.rightBarButtonItem = customSettingsBarItem;
    
    //HIGHLIGHTS
    UIImage *playImage = [UIImage imageNamed:@"btn_menu_play_up.png"]; 
    [btnPlayGame setImage:playImage forState:UIControlStateHighlighted];
    
    UIImage *friendsImage = [UIImage imageNamed:@"btn_menu_findfriends_up.png"]; 
    [btnFindFriends setImage:friendsImage forState:UIControlStateHighlighted];
    
    UIImage *pointsImage = [UIImage imageNamed:@"btn_menu_pointforprizes_up.png"]; 
    [btnPointsForPrizes setImage:pointsImage forState:UIControlStateHighlighted];
    
    UIImage *leaguesImage = [UIImage imageNamed:@"btn_menu_leagues_up.png"]; 
    [btnLeagues setImage:leaguesImage forState:UIControlStateHighlighted];
    
    
    nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self 
           selector:@selector(didFinishLoadingFacebookUser) 
               name:@"didFinishLoadingFacebookUser" 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(didFinishFacebookRequest) 
               name:@"didFinishFacebookLoginRequest" 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(didFinishUpdatingFacebookUserLogin) 
               name:@"didFinishUpdatingFacebookUserLogin" 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(didFinishLoadingData) 
               name:@"didFinishAddingFacebookUser" 
             object:nil];
    
    /*
    //observer 
    [nc addObserver:self 
           selector:@selector(didFinishLoadingFacebookFriends:) 
               name:@"didFinishLoadingFacebookFriends" 
             object:nil];
    
    
    //observer 
    [nc addObserver:self 
           selector:@selector(didFinishLoadingFacebookFriends:) 
               name:@"didFinishLoadingFacebookFriendsWithApp" 
             object:nil];
    
    
    //observer 
    [nc addObserver:self 
           selector:@selector(didFinishLoadingFacebookFriends:) 
               name:@"didFinishLoadingFacebookFriendsWithNoApp" 
             object:nil];
    */
    
    fbApi = [[facebookAPIViewController alloc] init];
    
    //ALERT
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Updating data..."
                                           message:@""
                                          delegate:self 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [baseAlert show];
    
    
    //Activity indicator
    aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
    [baseAlert addSubview:aiv];
    [aiv startAnimating];
}

- (void)didFinishFacebookRequest
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dataController.fbUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    if ([dataController.fbUserID length] > 0) {
        
        //CHECK IF USER EXISTS, IF NOT ADD IT
        [dataController getFBUser];
        
    }
}

- (void)didFinishLoadingFacebookUser
{
    
    dataUser = [dataController objectInListAtIndex:0];
    
    if ([dataUser.fbRecordID intValue] > 0) {
        //user already exists in database
        NSLog(@"User already exist with recordID %@", dataUser.fbRecordID);
        
        [[NSUserDefaults standardUserDefaults] setValue:dataUser.userID forKey:@"userId"];
        
        //UPDATE USER LOGIN DATE
        updateUserLogin = [[DataFacebookUserRecordLogin alloc] init];
        updateUserLogin.fbUserID = dataUser.facebookUserID;
        
        [updateUserLogin updateFBUserLoginRecord];
        
    }
    else {
        //add user to database
        NSLog(@"User not yet in database, adding...");
        
        addUser = [[DataFacebookUserAdd alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        addUser.facebookUser.fbRecordID = @"0";
        addUser.facebookUser.userID = @"";
        addUser.facebookUser.facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
        addUser.facebookUser.facebookUserEmail = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbEmail"]];
        addUser.facebookUser.facebookName = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbName"]];
        addUser.facebookUser.facebookUserFirstName = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbFirstName"]];
        addUser.facebookUser.facebookUserLastName = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbLastName"]];
        addUser.facebookUser.facebookUserName = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbUsername"]];
        addUser.facebookUser.facebookUserGender = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbGender"]];
        addUser.facebookUser.facebookUserLocation = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbLocation"]];
        
        [addUser addFBUser];
        
    }
}

- (void)didFinishUpdatingFacebookUserLogin
{
    [self didFinishLoadingData];
}

- (void)didFinishLoadingData
{
	[self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
}

- (void)performDismiss
{
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
}

- (IBAction)playGame:(id)sender
{ 
    predixerGamePlayViewController *playGame = [[predixerGamePlayViewController alloc] init];
    [self.navigationController pushViewController:playGame animated:YES];
}

- (IBAction)findFriends:(id)sender
{    
    
    [self.navigationController pushViewController:fbApi animated:YES];
    [fbApi getUserFriendsWithApp];
}

- (void)didFinishLoadingFacebookFriends:(NSNotification *)notification
{
    
    predixerGameFindFriendsViewController *findFriends = [[predixerGameFindFriendsViewController alloc] init];
    
    findFriends.friendsData = (NSMutableArray*)[notification object];
    
    [self.navigationController pushViewController:findFriends animated:YES];
}

- (void)didFinishLoadingFacebookFriendsWithApp:(NSNotification *)notification
{
    
    predixerGameFindFriendsViewController *findFriends = [[predixerGameFindFriendsViewController alloc] init];
    
    findFriends.friendsData = (NSMutableArray*)[notification object];
    
    [self.navigationController pushViewController:findFriends animated:YES];
}

- (IBAction)pointsForPrizes:(id)sender
{
    predixerHowToViewController *howTo = [[predixerHowToViewController alloc] init];
    [self.navigationController pushViewController:howTo animated:YES];
    
}

- (IBAction)gotoLeagues:(id)sender
{
    predixerGameLeaguesViewController *leagues = [[predixerGameLeaguesViewController alloc] init];
    [self.navigationController pushViewController:leagues animated:YES];
    
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSettings:(id)sender
{
    //[fbApi apiLogout];
    
    predixerSettingsViewControllerViewController *settings = [[predixerSettingsViewControllerViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"bkd_navBar_Logo.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
