//
//  predixerSettingsViewControllerViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerSettingsViewControllerViewController.h"
#import "facebookAPIViewController.h"
#import "predixerAboutViewController.h"
#import "predixerAccountViewController.h"
#import "predixerHistoryViewController.h"
#import "predixerPointsViewController.h"
#import "predixerPrivacyViewController.h"
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
            items = [NSMutableArray arrayWithObjects:@"Your Points", @"History", @"Account", @"Terms", @"Privacy", @"About", @"Logout",nil];
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"MyIdentifier"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:24];
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
        predixerTermsViewController *terms = [[predixerTermsViewController alloc] init];
        [self.navigationController pushViewController:terms animated:YES];
        
    }
    else if (indexPath.row == 4) {
        //Privacy
        predixerPrivacyViewController *privacy = [[predixerPrivacyViewController alloc] init];
        [self.navigationController pushViewController:privacy animated:YES];
    }
    else if (indexPath.row == 5) {
       //About
        predixerAboutViewController *about = [[predixerAboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.row == 6) {
        //Logout
        
        facebookAPIViewController *fbApi = [[facebookAPIViewController alloc] init];
        [fbApi apiLogout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
