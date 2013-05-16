//
//  predixerGameMenuViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerGameMenuViewController.h"
#import "predixerGameViewController.h"
#import "predixerHowToViewController.h"
#import "DataFacebookUser.h"
#import "DataFacebookUserController.h"
#import "DataFacebookUserAdd.h"
#import "DataFacebookUserRecordLogin.h"
#import "predixerSettingsViewControllerViewController.h"
#import "DataDrawDate.h"
#import "DataDrawDateController.h"
#import "LoadingController.h"
#import "predixerAppDelegate.h"
#import "predixerFBFriendsViewController.h"
#import "Constants.h"
#import "predixerLeaderboardViewController.h"

@interface predixerGameMenuViewController ()

@end

@implementation predixerGameMenuViewController

@synthesize fbApi;
@synthesize isSystemLogin;
@synthesize dataController;
@synthesize dataUser;
@synthesize addUser;
@synthesize updateUserLogin;
@synthesize dataDrawDate;
@synthesize drawDateController;
@synthesize loadingController;
@synthesize appDelegate;
@synthesize leaderboard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataController == nil) {
            dataController = [[DataFacebookUserController alloc] init];
            
            //NSLog(@"Count at init: %d", [dataController countOfList]);
        }
        
        if (drawDateController == nil) {
            drawDateController = [[DataDrawDateController alloc] init];
        }
    
        
        appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
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
    UIImage *playImage = [UIImage imageNamed:@"btn_menu_play"];
    UIImage *playImageUp = [UIImage imageNamed:@"btn_menu_play_up"];
    [btnPlayGame setImage:playImage forState:UIControlStateNormal];
    [btnPlayGame setImage:playImageUp forState:UIControlStateHighlighted];
    
    UIImage *friendsImage = [UIImage imageNamed:@"btn_menu_findfriends"];
    UIImage *friendsImageUp = [UIImage imageNamed:@"btn_menu_findfriends_up"];
    [btnFindFriends setImage:friendsImage forState:UIControlStateNormal];
    [btnFindFriends setImage:friendsImageUp forState:UIControlStateHighlighted];
    
    UIImage *pointsImage = [UIImage imageNamed:@"btn_menu_howto"];
    UIImage *pointsImageUp = [UIImage imageNamed:@"btn_menu_howto_up"];
    [btnPointsForPrizes setImage:pointsImage forState:UIControlStateNormal];
    [btnPointsForPrizes setImage:pointsImageUp forState:UIControlStateHighlighted];
    
    UIImage *leaguesImage = [UIImage imageNamed:@"btn_menu_winners"];
    UIImage *leaguesImageUp = [UIImage imageNamed:@"btn_menu_winners_up"];
    [btnLeagues setImage:leaguesImage forState:UIControlStateNormal];
    [btnLeagues setImage:leaguesImageUp forState:UIControlStateHighlighted];
    
    UIImage *nextDrawImage = [UIImage imageNamed:@"bkd_Draw"];
    vwNextDraw.image = nextDrawImage;
        
    //CHECK FOR IPHONE 5
    if (IS_IPHONE5 == YES) {
        
        btnPlayGame.frame = CGRectMake(21.0f, 40.0f, playImage.size.width, playImage.size.height);
        btnFindFriends.frame = CGRectMake(21.0f, 140.0f, friendsImage.size.width, friendsImage.size.height);
        btnPointsForPrizes.frame = CGRectMake(21.0f, 265.0f, friendsImage.size.width, friendsImage.size.height);
        btnLeagues.frame = CGRectMake(21.0f, 371.0f, friendsImage.size.width, friendsImage.size.height);
        
        vwNextDraw.frame = CGRectMake(75.0f, 480.0f, nextDrawImage.size.width, nextDrawImage.size.height);
        
        lblDays.frame = CGRectMake(147.0f, 475.0f, lblDays.frame.size.width, lblDays.frame.size.height);
        lblHours.frame = CGRectMake(172.0f, 475.0f, lblHours.frame.size.width, lblHours.frame.size.height);
        lblMins.frame = CGRectMake(197.0f, 475.0f, lblMins.frame.size.width, lblMins.frame.size.height);
        lblSec.frame = CGRectMake(220.0f, 475.0f, lblSec.frame.size.width, lblSec.frame.size.height);

    }
    
    
    
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
    
    [nc addObserver:self
           selector:@selector(didFinishLoadingDrawDate)
               name:@"didFinishLoadingDrawDate"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didSystemLogin)
               name:@"didSystemLogin"
             object:nil];
    
    
    //ALERT
    
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Updating data...";
    [self.view addSubview:loadingController.view];
    
    /*
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
     */
    

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
        //NSLog(@"User already exist with recordID %@", dataUser.fbRecordID);
        
        [[NSUserDefaults standardUserDefaults] setValue:dataUser.userID forKey:@"userId"];
        
        //UPDATE USER LOGIN DATE
        updateUserLogin = [[DataFacebookUserRecordLogin alloc] init];
        updateUserLogin.fbUserID = dataUser.facebookUserID;
        
        [updateUserLogin updateFBUserLoginRecord];
        
    }
    else {
        //add user to database
        //NSLog(@"User not yet in database, adding...");
        
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
        
        //[addUser addFBUser];
        [addUser addUserFacebook];
        
    }
}

- (void)didFinishUpdatingFacebookUserLogin
{
    //Get drawdate
    [drawDateController getDrawDate];
}

- (void)didSystemLogin
{
    isSystemLogin = YES;
    //Get drawdate
    [drawDateController getDrawDate];
}

- (void)didFinishLoadingDrawDate
{
    if ([drawDateController countOfList] > 0) {
        dataDrawDate = [drawDateController objectInListAtIndex:0];
        
        lblDrawDate.text = [NSString stringWithFormat:@"%@", dataDrawDate.drawDate];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date] toDate:dataDrawDate.drawDate options:0];

        day = [dateComponents day];
        hour = [dateComponents hour];
        minute = [dateComponents minute];
        second = [dateComponents second];

        NSDate * now = [NSDate date];
        NSDate * draw = dataDrawDate.drawDate;
        NSComparisonResult result = [now compare:draw];
                
        //NSLog(@"Draw: %@, today:  %@", draw, now );
        
        if(result==NSOrderedAscending){
            //NSLog(@"Draw is in the future");
            
            lblDays.text = [NSString stringWithFormat:@"%d", day];
            lblHours.text = [NSString stringWithFormat:@"%d", hour];
            lblMins.text = [NSString stringWithFormat:@"%d", minute];
            lblSec.text = [NSString stringWithFormat:@"%d", second];
            
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        }
        else if(result==NSOrderedDescending)
        {
            //NSLog(@"Draw is in the past");
            lblDays.text = @"00";
            lblHours.text = @"00";
            lblMins.text = @"00";
            lblSec.text = @"00";
            
            
        }
        else {
            //NSLog(@"Both dates are the same");
            lblDays.text = @"00";
            lblHours.text = @"00";
            lblMins.text = @"00";
            lblSec.text = @"00";
        }
        

    }
    
    [self didFinishLoadingData];
}

-(void)timerFired
{
    if((minute > 0 || second >=0) && minute>=0)
    {
        if(second==0)
        {
            minute-=1;
            second=60;
        }
        else if(second>0)
        {
            second-=1;
        }
        
        if (minute == 0) {
            hour -= 1;
            minute = 60;
        }
        
        if(minute>-1)
        {
            //[lblDrawDate setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",minute,@":",second]];
        
            
            lblDays.text = [NSString stringWithFormat:@"%d", day];
            lblHours.text = [NSString stringWithFormat:@"%d", hour];
            lblMins.text = [NSString stringWithFormat:@"%d", minute];
            lblSec.text = [NSString stringWithFormat:@"%d", second];
        }
        
        if (hour>-1) {
            lblDays.text = [NSString stringWithFormat:@"%d", day];
            lblHours.text = [NSString stringWithFormat:@"%d", hour];
            lblMins.text = [NSString stringWithFormat:@"%d", minute];
            lblSec.text = [NSString stringWithFormat:@"%d", second];
        }
    }
    else
    {
        [timer invalidate];
    }
}

- (void)didFinishLoadingData
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
    
    
}

- (IBAction)playGame:(id)sender
{ 
    predixerGameViewController *playGame = [[predixerGameViewController alloc] init];
    [self.navigationController pushViewController:playGame animated:YES];
}

- (IBAction)findFriends:(id)sender
{    
    
    predixerFBFriendsViewController *findFriends = [[predixerFBFriendsViewController alloc] init];
    findFriends.isSystemLogin = self.isSystemLogin;
    [self.navigationController pushViewController:findFriends animated:YES];
}


- (IBAction)howToPlay:(id)sender
{
    predixerHowToViewController *howTo = [[predixerHowToViewController alloc] init];
    [self.navigationController pushViewController:howTo animated:YES];
    
}

- (IBAction)gotoWinners:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.predixer.com/Winners.aspx"]];
}

- (IBAction)gotoLeaderboard:(id)sender{
    leaderboard = [[predixerLeaderboardViewController alloc] init];
    
    [self.navigationController pushViewController:leaderboard animated:YES];
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
    
    if (timer != nil) {
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [timer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer invalidate];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
