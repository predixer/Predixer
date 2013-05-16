//
//  predixerPointsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "predixerPointsViewController.h"
#import "DataUserPoints.h"
#import "DataUserPointsController.h"
#import "predixerUserInviteViewController.h"
#import "LoadingController.h"
#import "DataLeaderboard.h"
#import "DataLeaderboardController.h"

@interface predixerPointsViewController ()

@end

@implementation predixerPointsViewController

@synthesize dataController;
@synthesize dataUserPoints;
@synthesize loadingController;
@synthesize leaderboardDataController;
@synthesize dataLeaderboard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (items == nil) {
            items = [NSMutableArray arrayWithObjects:@"Points this week", @"Overall standing",nil];
        }
        
        if (dataController == nil) {
			dataController = [[DataUserPointsController alloc] init];
			
			//NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        // Custom initialization
        if (leaderboardDataController == nil) {
			leaderboardDataController = [[DataLeaderboardController alloc] init];
			
			//NSLog(@"Count at init: %d", [dataController countOfList]);
		}
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingData)
				   name:@"didFinishLoadingUserPoints"
				 object:nil];
        
        //observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingUserLeaderboard)
				   name:@"didFinishLoadingUserLeaderboard"
				 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserPoints" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserLeaderboard" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblPoints.backgroundColor = [UIColor clearColor];
    
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
    
    [self getWeek];
    
    [leaderboardDataController getUserLeaderboard];
    
    //[dataController getPoints];
	
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

- (void)getWeek
{
    NSDate *today = [NSDate date];
    //NSLog(@"Today date is %@",today);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    //Week Start Date
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [components setDay:([components day] - ((dayofweek) - 1))];// for beginning of the week.
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"MM/dd/yyyy"];
    
    NSString *startWeekDate = [dateFormat stringFromDate:beginningOfWeek];
    
    //Week End Date
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *componentsEnd = [gregorianEnd components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int Enddayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [componentsEnd setDay:([componentsEnd day]+(6-Enddayofweek)+1)];// for end day of the week
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"MM/dd/yyyy"];
    
    NSString *endWeekDate = [dateFormat stringFromDate:EndOfWeek];
    
    
    lblWeek.text = [NSString stringWithFormat:@"Week: %@ - %@", startWeekDate, endWeekDate];
}

- (void)didFinishLoadingData
{
	[tblPoints reloadData];
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


- (void)didFinishLoadingUserLeaderboard
{
	[tblPoints reloadData];
	[self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
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

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = color;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyIdentifier"];
        
        
    }
    
    if ([leaderboardDataController countOfList] != 0) {
        
        dataLeaderboard = [leaderboardDataController objectInListAtIndex:0];
        
        //Correct Prediction
        if (indexPath.row == 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",dataLeaderboard.questionPoints];
        }
        else if (indexPath.row == 1) {
            //draw points
            cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",dataLeaderboard.recordID];
        }
    }
    else {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = @"0";
        }
        else if (indexPath.row == 1) {
            //draw points
            cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
            cell.detailTextLabel.text = @"0";
        }
    }
    
    /*
    dataUserPoints = [dataController objectInListAtIndex:0];
    
    //Correct Prediction
    if (indexPath.row == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = dataUserPoints.totalPredictPoints;
    }
    else if (indexPath.row == 1) {
        //draw points
        cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[items objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = dataUserPoints.drawPoints;
    }
    */
    
    cell.textLabel.font = [UIFont fontWithName: @"Verdana" size:16];
    
    //cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
