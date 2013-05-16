//
//  predixerAccountViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "predixerAccountViewController.h"
#import "DataFacebookUser.h"
#import "DataFacebookUserController.h"
#import "LoadingController.h"
#import "predixerAppDelegate.h"

@interface predixerAccountViewController ()

@end

@implementation predixerAccountViewController

@synthesize fbUser;
@synthesize dataController;
@synthesize loadingController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (dataController == nil) {
			dataController = [[DataFacebookUserController alloc] init];
			
			//NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingData)
				   name:@"didFinishLoadingFacebookUser"
				 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingFacebookUser" object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tblAccount.backgroundColor = [UIColor clearColor];
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fbUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    dataController.fbUserID = fbUserID;
    [dataController getFBUser];
	
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
}

- (void)didFinishLoadingData
{
	[tblAccount reloadData];
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

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}


- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = color;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    // Configure the cell...
    if ([dataController countOfList] != 0)
	{
        
		fbUser = [dataController objectInListAtIndex:0];

        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Name:"];
            cell.detailTextLabel.text = fbUser.facebookName;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"Email:"];
            cell.detailTextLabel.text = fbUser.facebookUserEmail;
        }
        else if (indexPath.row == 2) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM d, YYYY"];
            NSString *dateStr = [formatter stringFromDate:fbUser.dateEntered];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Sign Up:"];
            cell.detailTextLabel.text = dateStr;
        }
        
        cell.textLabel.font = [UIFont fontWithName: @"Verdana" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName: @"Verdana" size:15];
    }
    
    
    return cell;
}

- (IBAction)logout:(id)sender
{
    predixerAppDelegate *appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
