//
//  predixerSettingsViewControllerViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerSettingsViewControllerViewController.h"
#import "predixerAccountViewController.h"
#import "predixerHistoryViewController.h"
#import "predixerPointsViewController.h"
#import "predixerAppDelegate.h"
#import "predixerTermsViewController.h"

@interface predixerSettingsViewControllerViewController ()

@end

@implementation predixerSettingsViewControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (items == nil) {
            items = [NSMutableArray arrayWithObjects:@"Your Points", @"Predictions", @"Account", @"Terms", @"Privacy", @"Official Rules", @"About", @"Logout",nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblSettings.backgroundColor = [UIColor clearColor];
    
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
    
    
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    vwDeauthorized.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    vwDeauthorized.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = color;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName: @"Verdana" size:18];
    //cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //Your points
        predixerPointsViewController *point = [[predixerPointsViewController alloc] init];
        [self.navigationController pushViewController:point animated:YES];
    }
    else if (indexPath.row == 1) {
        //History
        predixerHistoryViewController *history = [[predixerHistoryViewController alloc] init];
        [self.navigationController pushViewController:history animated:YES];
    }
    else if (indexPath.row == 2) {
        //Account
        predixerAccountViewController *account = [[predixerAccountViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
        
    }
    else if (indexPath.row == 3) {
        //Terms
        //predixerTermsViewController *terms = [[predixerTermsViewController alloc] init];
        //[self.navigationController pushViewController:terms animated:YES];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.predixer.com/TermsOfService.aspx"]];
        
    }
    else if (indexPath.row == 4) {
        //Privacy
        //predixerPrivacyViewController *privacy = [[predixerPrivacyViewController alloc] init];
        //[self.navigationController pushViewController:privacy animated:YES];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.predixer.com/PrivacyPolicy.aspx"]];
    }
    else if (indexPath.row == 5) {
            //Contest Rules
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.predixer.com/ContestRules.aspx"]];
        
        predixerTermsViewController *terms = [[predixerTermsViewController alloc] init];
        [self.navigationController pushViewController:terms animated:YES];
    }
    else if (indexPath.row == 6) {
            //About
            //predixerAboutViewController *about = [[predixerAboutViewController alloc] init];
            //[self.navigationController pushViewController:about animated:YES];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.predixer.com/About.aspx"]];
    }
    else if (indexPath.row == 7) {
        //Logout
        
        predixerAppDelegate *appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logout];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
