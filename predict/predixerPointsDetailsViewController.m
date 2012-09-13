//
//  predixerPointsDetailsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import "predixerPointsDetailsViewController.h"
#import "DataUserAnswers.h"
#import "DataUserAnswersController.h"
#import "predixerPlayQuestionDetailsViewController.h"

@interface predixerPointsDetailsViewController ()

@end

@implementation predixerPointsDetailsViewController

@synthesize dataController;
@synthesize userAnswers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (dataController == nil) {
			dataController = [[DataUserAnswersController alloc] init];
			
			NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingData)
				   name:@"didFinishLoadingUserAnswersCorrect"
				 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserAnswersCorrect" object:nil];
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
    
    dataController.isGetCorrectAnswers = YES;
    [dataController getUserAnswers];
	
    
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

- (void)didFinishLoadingData
{
	[tblPredictions reloadData];
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
    }
    
     
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    //cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userAnswers = [dataController objectInListAtIndex:indexPath.row];
    
    NSString *questionID = [NSString stringWithFormat:@"%d", userAnswers.questionID];
    
    predixerPlayQuestionDetailsViewController *questionDetails = [[predixerPlayQuestionDetailsViewController alloc] initWithQuestion:questionID];
    
    
    [self.navigationController pushViewController:questionDetails animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
