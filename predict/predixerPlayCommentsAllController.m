//
//  predixerPlayCommentsAllController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "predixerPlayCommentsAllController.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "DataQuestions.h"
#import "predixerPlayCommentsDetailsController.h"
#import "predixerSettingsViewControllerViewController.h"

@interface predixerPlayCommentsAllController ()

@end

@implementation predixerPlayCommentsAllController

@synthesize dataComments;
@synthesize commentsDataController;
@synthesize dataQuestion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataComments == nil) {
            dataComments = [[DataComments alloc]init];
        }
        
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        if (dataQuestion == nil) {
            dataQuestion = [[DataQuestions alloc] init];
        }
        
        nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
               selector:@selector(didFinishLoadingComments)
                   name:@"didFinishLoadingComments"
                 object:nil];
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingComments" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tblComments.backgroundColor = [UIColor clearColor];
    tblComments.dataSource = self;
    tblComments.delegate = self;
    
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
    
    lblQuestion.text = dataQuestion.questionText;
    lblQuestion.lineBreakMode = UILineBreakModeWordWrap;
    lblQuestion.numberOfLines = 2;

    
    [self getComments];
}

- (void)getComments{
    
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
    
    commentsDataController.questionID = dataQuestion.questionID;
    [commentsDataController getComments];
    
}

- (void)didFinishLoadingComments
{
    [tblComments reloadData];
    lblCommentNumber.text = [NSString stringWithFormat:@"%d", [commentsDataController countOfList]];
    
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [commentsDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    // Configure the cell...
    if ([commentsDataController countOfList] != 0)
    {
        dataComments = [commentsDataController objectInListAtIndex:indexPath.row];
        
        NSLog(@"dataComments.comment %@", dataComments.comment);
        NSLog(@"commentID %@", dataComments.commentID);
        cell.textLabel.text = dataComments.comment;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"By %@ on %@", dataComments.fbName, dataComments.commentDate];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    predixerPlayCommentsDetailsController *commentDetails = [[predixerPlayCommentsDetailsController alloc] initWithQuestion:[questionID intValue] comment:[commentsDataController objectInListAtIndex:indexPath.row] count:[commentsDataController countOfList]];
    
    commentDetails.dataQuestion = self.dataQuestion;    
    
    [self.navigationController pushViewController:commentDetails animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
