//
//  predixerPlaySportsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerPlaySportsViewController.h"
#import "predixerPlaySportsDetailsViewController.h"
#import "DataQuestions.h"
#import "DataQuestionsController.h"
#import "predixerSettingsViewControllerViewController.h"


@interface predixerPlaySportsViewController ()

@end

@implementation predixerPlaySportsViewController

@synthesize dataController;
@synthesize dataQuestions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataController == nil) {
			dataController = [[DataQuestionsController alloc] init];
			
			NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer 
		[nc addObserver:self 
			   selector:@selector(didFinishLoadingData) 
				   name:@"didFinishLoadingQuestions" 
				 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingQuestions" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"Play Game";
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    lblDate.text = [dateFormat stringFromDate:today];

    tblList.backgroundColor = [UIColor clearColor];
    
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
    
    dataController.categoryID = @"2";
    //[dataController getQuestions];
	[dataController getQuestionsFromLocal];
	
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
  
}


- (void)didFinishLoadingData
{
	[tblList reloadData];
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

#pragma mark - UITableView Datasource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   return [dataController countOfList];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = color;
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    // Configure the cell...
    if ([dataController countOfList] != 0)
	{
		dataQuestions = [dataController objectInListAtIndex:indexPath.row];
        
        cell.textLabel.text = dataQuestions.questionText;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        
        NSString *strNumber = [NSString stringWithFormat:@"n%d.png",indexPath.row]; 
        UIImage *numberImage = [UIImage imageNamed:strNumber];
        cell.imageView.image = numberImage;
    }
    
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    dataQuestions = [dataController objectInListAtIndex:indexPath.row];
    NSLog(@"questionID: %@", dataQuestions.questionID);
    
    predixerPlaySportsDetailsViewController *details = [[predixerPlaySportsDetailsViewController alloc] initWithQuestion:dataQuestions];
    [self.navigationController pushViewController:details animated:YES];

    
    
}

@end
