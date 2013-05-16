//
//  predixerGamePlayViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerGamePlayViewController.h"
#import "predixerPlayEntertainmentViewController.h"
#import "predixerPlaySportsViewController.h"
#import "predixerPlayStocksViewController.h"
#import "predixerPlayNewsViewController.h"
#import "predixerSettingsViewControllerViewController.h"

@interface predixerGamePlayViewController ()

@end

@implementation predixerGamePlayViewController


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
    
    //self.title = @"Play Game";
    
    
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
    
    
    //HIGHLIGHTS
    UIImage *entertainmentImage = [UIImage imageNamed:@"btn_Play_Entertainment_up.png"]; 
    [btnEntertainment setImage:entertainmentImage forState:UIControlStateHighlighted];
    
    UIImage *stockImage = [UIImage imageNamed:@"btn_Play_Stocks_up.png"]; 
    [btnStocks setImage:stockImage forState:UIControlStateHighlighted];
    
    UIImage *sportsImage = [UIImage imageNamed:@"btn_Play_Sports_up.png"]; 
    [btnSports setImage:sportsImage forState:UIControlStateHighlighted];
    
    UIImage *newsImage = [UIImage imageNamed:@"btn_Play_News_up.png"]; 
    [btnNews setImage:newsImage forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)playEntertainment:(id)sender
{
    predixerPlayEntertainmentViewController *enter = [[predixerPlayEntertainmentViewController alloc] init];
    [self.navigationController pushViewController:enter animated:YES];
}

- (IBAction)playStocks:(id)sender
{
    predixerPlayStocksViewController *stocks = [[predixerPlayStocksViewController alloc] init];
    [self.navigationController pushViewController:stocks animated:YES];
}

- (IBAction)playSports:(id)sender
{
    predixerPlaySportsViewController *sports = [[predixerPlaySportsViewController alloc] init];
    [self.navigationController pushViewController:sports animated:YES];
}

- (IBAction)playNews:(id)sender
{
    predixerPlayNewsViewController *news = [[predixerPlayNewsViewController alloc] init];
    [self.navigationController pushViewController:news animated:YES];
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSettings:(id)sender
{
    predixerSettingsViewControllerViewController *settings = [[predixerSettingsViewControllerViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
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
