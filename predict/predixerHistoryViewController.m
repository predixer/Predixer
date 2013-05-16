//
//  predixerHistoryViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "predixerHistoryViewController.h"
#import "DataUserAnswers.h"
#import "DataUserAnswersController.h"
//#import "predixerPlayQuestionDetailsViewController.h"
#import "LoadingController.h"
#import "predixerHistoryDetailsViewController.h"

@interface predixerHistoryViewController ()

@end

@implementation predixerHistoryViewController

@synthesize dataController;
@synthesize userAnswers;
@synthesize loadingController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (dataController == nil) {
			dataController = [[DataUserAnswersController alloc] init];
			
			//NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingData)
				   name:@"didFinishLoadingUserAnswersAll"
				 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserAnswersAll" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tblPredictions.backgroundColor = [UIColor clearColor];
    
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
    
    dataController.isGetCorrectAnswers = NO;
    [dataController getUserAnswers];
	
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
	[tblPredictions reloadData];
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
	return [dataController countOfList];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = color;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if ([dataController countOfList] != 0) {
        userAnswers = [dataController objectInListAtIndex:indexPath.row];
        
        cell.textLabel.text = userAnswers.question;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSString *dateStr = [formatter stringFromDate:userAnswers.answerDate];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@, Answer: %@", dateStr, userAnswers.answerOption];
        
        //NSLog(@"userAnswers.isCorrect %d", userAnswers.isCorrect);
        
        if (userAnswers.isAnswerSet == true) {
            if (userAnswers.isCorrect == true) {
                cell.imageView.image = [UIImage imageNamed:@"img_XGreen.png"];
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"img_XRed.png"];
            }
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"img_XGray.png"];
        }
        
    }
    
    
    cell.textLabel.font = [UIFont fontWithName: @"Verdana" size:16];
    
    //cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userAnswers = [dataController objectInListAtIndex:indexPath.row];
    
    NSString *questionID = [NSString stringWithFormat:@"%d", userAnswers.questionID];
    
    //predixerPlayQuestionDetailsViewController *questionDetails = [[predixerPlayQuestionDetailsViewController alloc] initWithQuestion:questionID];
    predixerHistoryDetailsViewController *historyDetails = [[predixerHistoryDetailsViewController alloc] initWithQuestion:questionID];
    
    [self.navigationController pushViewController:historyDetails animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
