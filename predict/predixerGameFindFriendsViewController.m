//
//  predixerGameFindFriendsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerGameFindFriendsViewController.h"
#import "predixerGameFindFriendsInviteController.h"
#import "predixerGameFindFriendsPlayController.h"
#import "predixerSettingsViewControllerViewController.h"

@interface predixerGameFindFriendsViewController ()

@end

@implementation predixerGameFindFriendsViewController

@synthesize friendsPlay;
@synthesize friendsInvite;
@synthesize friendsData;
@synthesize friendsWithAppData;
@synthesize friendsWithNoAppData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"FACEBOOK";
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"bkd_navBar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  
    
    //LEFT NAV BUTTON    
    // Set the custom back button
	UIImage *backButtonNormalImage = [UIImage imageNamed:@"btn_Back.png"];
	UIImage *backButtonHighlightImage = [UIImage imageNamed:@"btn_Back_up.png"];
    
	//create the button and assign the image
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:backButtonNormalImage forState:UIControlStateNormal];
	[backButton setImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	backButton.frame = CGRectMake(0, 0, backButtonNormalImage.size.width, backButtonNormalImage.size.height);
    
	[backButton addTarget:self action:@selector(pressBack:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    friendsWithAppData = [[NSMutableArray alloc] init];
    friendsWithNoAppData = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dict in friendsData) {
        NSString* keycode = [dict objectForKey:@"installed"];
        
        
        if ([keycode intValue] == 1)
        {
            //GET ONLY FRIENDS WHO INSTALLED THE APP
            [friendsWithAppData addObject:dict];
        }
        else {
            //GET ONLY FRIENDS WHO ARE NOT APP USERS
            [friendsWithNoAppData addObject:dict];
        }
    }
    
    
    friendsPlay = [[predixerGameFindFriendsPlayController alloc] initWithStyle:UITableViewStylePlain data:friendsWithAppData];
    friendsPlay.view.tag = 10;
    friendsPlay.view.hidden = NO;
    friendsPlay.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 412.0f);
    [self.view addSubview:friendsPlay.view];
    
    friendsInvite = [[predixerGameFindFriendsInviteController alloc] initWithStyle:UITableViewStylePlain data:friendsWithNoAppData];
    friendsInvite.view.tag = 12;
    friendsInvite.view.hidden = YES;
    friendsInvite.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 412.0f);
    [self.view addSubview:friendsInvite.view];
    
}

- (void)pressBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pressSettings:(id)sender
{
    predixerSettingsViewControllerViewController *settings = [[predixerSettingsViewControllerViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
}

- (IBAction)pressPlay:(id)sender
{
    friendsPlay.view.hidden = NO;
    friendsInvite.view.hidden = YES;
}

- (IBAction)pressInvite:(id)sender
{   
    friendsPlay.view.hidden = YES;
    friendsInvite.view.hidden = NO;
}

- (IBAction)pressShare:(id)sender
{
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
