//
//  predixerHowToViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerHowToViewController.h"
#import "predixerSettingsViewControllerViewController.h"
#import "DataGrandPrizeController.h"
#import "DataHowToController.h"
#import "LoadingController.h"
#import "DataHowTo.h"

@interface predixerHowToViewController ()

@end

@implementation predixerHowToViewController

@synthesize dataController;
@synthesize dataHowToController;
@synthesize loadingController;
@synthesize howTo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (dataController == nil)
        {
            dataController = [[DataGrandPrizeController alloc] init];
        }
        
        if (dataHowToController == nil) {
            dataHowToController = [[DataHowToController alloc] init];
        }
        
        nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishGettingGrandPrize)
				   name:@"didFinishGettingGrandPrize"
				 object:nil];
        
        [nc addObserver:self
			   selector:@selector(didFinishGettingHowTo)
				   name:@"didFinishGettingHowTo"
				 object:nil];
        
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishGettingGrandPrize" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishGettingHowTo" object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    txtHowTo.font = [UIFont fontWithName: @"Verdana" size:15];
    txtHowTo.textColor = [UIColor colorWithRed:0.02f green:0.32f blue:0.52f alpha:1.0f];
    //lblMoney.font = [UIFont fontWithName: @"Verdana" size:11];
    
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
    
     
      
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Loading...";
    [self.view addSubview:loadingController.view];
    
   /*
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
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
    
    //[dataController getGrandPrize];
    
    [dataHowToController getHowToText];
    
    txtHowTo.font = [UIFont fontWithName: @"Verdana" size:16];
}

- (void)didFinishGettingGrandPrize
{
    [dataHowToController getHowToText];
    
}

- (void)didFinishGettingHowTo
{
    if ([dataHowToController countOfList] != 0) {
        
        //NSString *strText = [dataHowToController objectInListAtIndex:0];
        
        howTo = [dataHowToController objectInListAtIndex:0];
        
        //NSLog(@"%@", howTo.howToText);
        
        txtHowTo.text = howTo.howToText;
    }
    
	[self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
}

- (void)performDismiss
{
    
    lblMoney.text = dataController.strGrandPrize;
    
    [loadingController.view removeFromSuperview];
    
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"bkd_navBar_Logo.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];    
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
