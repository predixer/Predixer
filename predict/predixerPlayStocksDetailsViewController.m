//
//  predixerPlayStocksDetailsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerPlayStocksDetailsViewController.h"
#import "DataQuestions.h"
#import "DataQuestionAnswers.h"
#import "DataQuestionAnswersController.h"
#import "DataUserQuestionAnswerController.h"
#import "DataUserQuestionAnswer.h"
#import "DataUserQuestionAnswerSubmitController.h"
#import "DataCommentAddController.h"
#import "predixerPlayCommentsController.h"
#import "predixerPlayCommentsAllController.h"
#import "predixerSettingsViewControllerViewController.h"


@interface predixerPlayStocksDetailsViewController ()

@end

@implementation predixerPlayStocksDetailsViewController

@synthesize dataQuestions;
@synthesize answersDataController;
@synthesize questionAnswers;
@synthesize selectedAnswerID;
@synthesize userAnswerController;
@synthesize userAnswer;
@synthesize submitAnswer;
@synthesize tblListAnswer;
@synthesize tblListComments;
@synthesize addCommentsController;
@synthesize userCommentsDataController;

- (id)initWithQuestion:(DataQuestions *)question
{
    
    if (self) {
        
        if (nil != question) {
            dataQuestions = [[DataQuestions alloc]init];
            
            dataQuestions = question;
            
        }
        
        if (answersDataController == nil) {
			answersDataController = [[DataQuestionAnswersController alloc] init];
			
			NSLog(@"Count at init: %d", [answersDataController countOfList]);
		}
        
        
        
		nc = [NSNotificationCenter defaultCenter];
		
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingQuestionAnswers)
				   name:@"didFinishLoadingQuestionAnswers"
				 object:nil];
        
        
		[nc addObserver:self
			   selector:@selector(didFinishLoadingUserAnswer)
				   name:@"didFinishLoadingUserQuestionAnswer"
				 object:nil];
        
        [nc addObserver:self
			   selector:@selector(didFinishSubmittingUserAnswer)
				   name:@"didFinishSubmittingUserAnswer"
				 object:nil];
        
        
        [nc addObserver:self
			   selector:@selector(didFinishAddingUserComment)
				   name:@"didFinishAddingUserComment"
				 object:nil];
        
        [nc addObserver:self
			   selector:@selector(didFinishLoadingCommentsToTable)
				   name:@"didFinishLoadingCommentsToTable"
				 object:nil];
        
        
    }
    return self;
}

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
    
    //self.title = @"News";
    
    tblListAnswer.backgroundColor = [UIColor clearColor];
    tblListComments.backgroundColor = [UIColor clearColor];
    
    if (userCommentsDataController == nil) {
        userCommentsDataController = [[predixerPlayCommentsController alloc]init];
        userCommentsDataController.view.frame = CGRectMake(15.0f, 288.0f, 290.0f, 140.0f);
        
        userCommentsDataController.dataQuestion = dataQuestions;
        
        [self.view addSubview:userCommentsDataController.view];
    }
    
    //tblListComments.dataSource = userCommentsDataController;
    //tblListComments.delegate = userCommentsDataController;
    userCommentsDataController.questionID = dataQuestions.questionID;
    
    
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
    
    lblQuestion.text = dataQuestions.questionText;
    lblQuestion.lineBreakMode = UILineBreakModeWordWrap;
    lblQuestion.numberOfLines = 2;
    
    questionPoints.text = [NSString stringWithFormat:@"Points: %d", dataQuestions.questionPoints];
    
    answersDataController.questionID = dataQuestions.questionID;
    [answersDataController getAnswers];
	
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
    
    checkedAnswer = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}


- (IBAction)showMoreComment:(id)sender
{
    predixerPlayCommentsAllController *allComments = [[predixerPlayCommentsAllController alloc] init];
    allComments.dataQuestion = dataQuestions;
    
    [self.navigationController pushViewController:allComments animated:YES];
}

- (void)didFinishLoadingQuestionAnswers
{
    
    if (userAnswerController == nil) {
        userAnswerController = [[DataUserQuestionAnswerController alloc]init];
    }
    
    userAnswerController.questionID = dataQuestions.questionID;
    [userAnswerController getAnswer];
}


- (void)didFinishLoadingUserAnswer
{
    NSLog(@"userAnswerController.countOfList %d", [userAnswerController countOfList]);
    
    if ([userAnswerController countOfList] > 0) {
        
        userAnswer = [userAnswerController objectInListAtIndex:0];
        
        if (userAnswer.questionID == [dataQuestions.questionID intValue]) {
            
            btnSubmitAnswer.enabled = NO;
            
            NSString *answerTime  = [userAnswer.answerDate substringFromIndex:10];
            
            //lblAnswerResult.text = [NSString stringWithFormat:@"Answered at %@.", userAnswer.answerDate];
            lblAnswerResult.text = [NSString stringWithFormat:@"Answered at %@.", answerTime];
            lblAnswerResult.hidden = NO;
            
            btnSubmitAnswer.hidden = YES;
            
            checkedAnswer = YES;
        }
    }
    
	[tblListAnswer reloadData];
    [userCommentsDataController getComments];
    
}

- (void)didFinishLoadingCommentsToTable
{
    [self didFinishLoadingData];
    
    lblCommentsCount.text = [NSString stringWithFormat:@"%d", userCommentsDataController.commentsCount];
    
    NSLog(@"userComments.commentsCount %d", userCommentsDataController.commentsCount);
    
}

- (void)didFinishAddingUserComment
{
    [self didFinishLoadingData];
    [userCommentsDataController getComments];
    txtComment.text = @"";
}

- (void)didFinishLoadingData
{
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
    return [answersDataController countOfList];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];;
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    // Configure the cell...
    if ([answersDataController countOfList] != 0)
    {
        questionAnswers = [answersDataController objectInListAtIndex:indexPath.row];
        
        //cell.textLabel.text = questionAnswers.answerText;
        //cell.textLabel.numberOfLines = 2;
        //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        //cell.textLabel.font = [UIFont systemFontOfSize:14];
        NSLog(@"answerid %d", questionAnswers.answerID);
        
        RadioButton *rb = [[RadioButton alloc] initWithFrame:CGRectMake(0, 0, 275, 35)];
        [rb setGroupID:0 AndID:questionAnswers.answerID AndTitle:[NSString stringWithFormat:@"%@", questionAnswers.answerText]];
        rb.delegate = self;
        rb.tag = indexPath.row;
        [cell.contentView addSubview:rb];
        
        if (checkedAnswer == YES) {
            
            if (userAnswer.answerSelectionID == questionAnswers.answerID) {
                rb.btn_RadioButton.selected = YES;
            }
            else {
                
                rb.btn_RadioButton.enabled = NO;
            }
        }
        
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    /*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)submitAnswer:(id)sender
{
    
    if (selectedAnswerID != 0) {
        
        baseAlert = [[UIAlertView alloc] initWithTitle:@"Submitting your answer..."
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
        
        //SUBMIT ANSWER
        submitAnswer = [[DataUserQuestionAnswerSubmitController alloc] init];
        submitAnswer.questionId = dataQuestions.questionID;
        submitAnswer.answerId = [NSString stringWithFormat:@"%d",selectedAnswerID];
        [submitAnswer submitQuestionAnswer];
        
        /*
         for (int i=0; i < [dataController countOfList]; i++) {
         questionAnswers = [dataController objectInListAtIndex:i];
         
         
         
         if (questionAnswers.answerID == selectedAnswerID) {
         
         if (questionAnswers.isCorrect == YES) {
         lblAnswerResult.text = @"Correct";
         lblAnswerResult.textColor = [UIColor greenColor];
         NSLog(@"answerID %d - selectedAnswerID %d", questionAnswers.answerID, selectedAnswerID);
         }
         else {
         lblAnswerResult.text = @"Wrong";
         lblAnswerResult.textColor = [UIColor redColor];
         NSLog(@"answerID %d - selectedAnswerID %d", questionAnswers.answerID, selectedAnswerID);
         }
         }
         }
         */
        
        btnSubmitAnswer.enabled = NO;
        
        for (UIButton *btn in self.view.subviews) {
            if (btn.tag == 0) {
                btn.enabled = NO;
            }
            else if (btn.tag ==1) {
                btn.enabled = NO;
            }
        }
    }
    else {
        UIAlertView *bAlert = [[UIAlertView alloc] initWithTitle:@"No Answer!"
                                                         message:@"Please select your answer first by pressing a checkbox."
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [bAlert show];
    }
    
    
}

- (void)didFinishSubmittingUserAnswer
{
    [self didFinishLoadingData];
    
    UIAlertView *bAlert = [[UIAlertView alloc] initWithTitle:@"Submitted!"
                                                     message:@"Your Answer has been submitted. Kindly post your comments below."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
    [bAlert show];
}

#pragma mark Delegate Functions

- (void)stateChangedForGroupID:(NSUInteger)indexGroup WithSelectedButton:(NSUInteger)indexID
{
    NSLog(@"Group %d - Button %d", indexGroup, indexID);
    
    selectedAnswerID = indexID;
}

- (IBAction)submitComment:(id)sender
{
    [txtComment resignFirstResponder];
    
    if ([txtComment.text length] != 0) {
        
        baseAlert = [[UIAlertView alloc] initWithTitle:@""
                                               message:@"Submitting your comment..."
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
        [baseAlert show];
        
        
        //Activity indicator
        aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiv.center = CGPointMake(baseAlert.bounds.size.width / 2.0f, baseAlert.bounds.size.height / 1.5f);
        [aiv startAnimating];
        [baseAlert addSubview:aiv];
        
        //SUBMIT COMMENT
        addCommentsController = [[DataCommentAddController alloc] init];
        addCommentsController.questionID = dataQuestions.questionID;
        addCommentsController.commentText = txtComment.text;
        
        [addCommentsController addUserComment];
        
    }
    else {
        UIAlertView *bAlert = [[UIAlertView alloc] initWithTitle:@"No Comment!"
                                                         message:@"Please enter your comment first before submitting."
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [bAlert show];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    int count = 199;
    
    if ([textView.text length] <= count) {
        lblCharCount.text = [NSString stringWithFormat:@"%d of 200.", count - [textView.text length]];
        lblCharCount.font = [UIFont systemFontOfSize:14.0f];
    }
    else {
        [textView resignFirstResponder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    CGRect frame = self.view.frame;
    frame.origin.y = -130.0f;
    
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    CGRect frame =  self.view.frame;
    frame.origin.y = 0.0f;
    
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    [textView resignFirstResponder];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL isReturn = NO;
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    //return (newLength > 300) ? NO : YES;
    
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        
        
        return isReturn;
    }
    else {
        if (newLength < 300) {
            isReturn = YES;
        }
    }
    
    return isReturn;
}


@end
