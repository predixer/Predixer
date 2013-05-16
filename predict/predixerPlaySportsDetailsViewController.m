//
//  predixerPlaySportsDetailsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerPlaySportsDetailsViewController.h"
#import "DataQuestions.h"
#import "DataQuestionAnswers.h"
#import "DataQuestionAnswersController.h"
#import "DataUserQuestionAnswerController.h"
#import "DataUserQuestionAnswer.h"
#import "DataUserQuestionAnswerSubmitController.h"
#import "DataCommentAddController.h"
#import "predixerPlayCommentsOneController.h"
#import "predixerPlayCommentsViewController.h"
#import "predixerSettingsViewControllerViewController.h"
#import "MSLabel.h"
#import "DataComments.h"
#import "LoadingController.h"
#import "predixerAppDelegate.h"

@interface predixerPlaySportsDetailsViewController ()

@end

@implementation predixerPlaySportsDetailsViewController

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
@synthesize loadingController;
@synthesize appDelegate;

- (id)initWithQuestion:(DataQuestions *)question
{
    
   if ((self = [super init])) {
        
        if (nil != question) {
            dataQuestions = [[DataQuestions alloc]init];
            
            dataQuestions = question;
            
        }
        
        if (answersDataController == nil) {
			answersDataController = [[DataQuestionAnswersController alloc] init];
			
			NSLog(@"Count at init: %d", [answersDataController countOfList]);
		}
        
        
        
		nc = [NSNotificationCenter defaultCenter];
		
       appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
       [[appDelegate facebook] enableFrictionlessRequests];
       
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingQuestionAnswers" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserQuestionAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishSubmittingUserAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishAddingUserComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingCommentsToTable" object:nil];
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
    lblCharCount.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    lblCharNumText.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    lblAnswerResult.font = [UIFont fontWithName: @"Comic Sans MS" size:12];
    
    tblListAnswer.backgroundColor = [UIColor clearColor];
    tblListComments.backgroundColor = [UIColor clearColor];
    
    if (userCommentsDataController == nil) {
        userCommentsDataController = [[predixerPlayCommentsOneController alloc]init];
        userCommentsDataController.view.backgroundColor = [UIColor clearColor];
        userCommentsDataController.view.frame = CGRectMake(13.0f, 335.0f, 296.0f, 92.0f);
        
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
    
    UIImage *fbButtonNormalImage = [UIImage imageNamed:@"btn_PostToFB"];
	UIImage *fbButtonHighlightImage = [UIImage imageNamed:@"btn_PostToFB_Up"];
    
	[btnPostToFB setImage:fbButtonNormalImage forState:UIControlStateNormal];
	[btnPostToFB setImage:fbButtonHighlightImage forState:UIControlStateSelected];
    
    UIImage *btnSubmitAnswerNormalImage = [UIImage imageNamed:@"btn_qSubmit"];
	UIImage *btnSubmitAnswerHighlightImage = [UIImage imageNamed:@"btn_qSubmit_up"];
    
	[btnSubmitAnswer setImage:btnSubmitAnswerNormalImage forState:UIControlStateNormal];
	[btnSubmitAnswer setImage:btnSubmitAnswerHighlightImage forState:UIControlStateHighlighted];
    
	[btnSubmitComment setImage:btnSubmitAnswerNormalImage forState:UIControlStateNormal];
	[btnSubmitComment setImage:btnSubmitAnswerHighlightImage forState:UIControlStateHighlighted];
    
    //lblQuestion.text = dataQuestions.questionText;
    //lblQuestion.lineBreakMode = UILineBreakModeWordWrap;
    //lblQuestion.numberOfLines = 4;
    //lblQuestion.font = [UIFont fontWithName: @"Comic Sans MS" size:16];
    
    MSLabel *titleLabel = [[MSLabel alloc] initWithFrame:CGRectMake(7.0f, 1.0f, 307.0f, 75.0f)];
    titleLabel.text = dataQuestions.questionText;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineHeight = 17;
    titleLabel.numberOfLines = 4;
    titleLabel.font = [UIFont fontWithName: @"Comic Sans MS" size:15];
    [self.view addSubview:titleLabel];
    
    questionPoints.text = [NSString stringWithFormat:@"Points: %d", dataQuestions.questionPoints];
    questionPoints.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    questionDate.text = [dateFormat stringFromDate:today];
    questionDate.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    
    answersDataController.questionID = dataQuestions.questionID;
   [answersDataController getAnswers];
    //[answersDataController getAnswersFromLocal];
	
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
    
    checkedAnswer = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFBUser = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"isFBUser"]];
    
    if ([isFBUser isEqualToString:@"Yes"]) {
        btnPostToFB.hidden = NO;
    }
    else {
        btnPostToFB.hidden = YES;
    }
}


- (IBAction)showMoreComment:(id)sender
{
    predixerPlayCommentsViewController *allComments = [[predixerPlayCommentsViewController alloc] init];
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
    
    if ([answersDataController countOfList] > 2) {
            //lineArrow.hidden = NO;
    }
}


- (void)didFinishLoadingUserAnswer
{
    NSLog(@"userAnswerController.countOfList %d", [userAnswerController countOfList]);
    
    if ([userAnswerController countOfList] > 0) {
        
        userAnswer = [userAnswerController objectInListAtIndex:0];
        
        if (userAnswer.questionID == [dataQuestions.questionID intValue]) {
            
            btnSubmitAnswer.enabled = NO;
            
            NSLog(@" userAnswer.answerDate %@",userAnswer.answerDate);
            
            NSArray *arrayDate = [userAnswer.answerDate componentsSeparatedByString:@" "];
            
            NSString *strHour = @"";
            NSString *strMin = @"";
            NSString *strDay = @"";
            
            for (int i=0; i < [arrayDate count]; i++) {
                
                NSLog(@" arrayDate %@",[arrayDate objectAtIndex:i]);
                
                if (i == 1) {
                    NSLog(@" time %@",[arrayDate objectAtIndex:i]);
                    
                    NSArray *arrayTime = [[arrayDate objectAtIndex:i] componentsSeparatedByString:@":"];
                    
                    for (int j=0; j < [arrayTime count]; j++) {
                        
                        if (j==0) {
                            strHour = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                        }
                        else if (j==1) {
                            strMin = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                        }
                    }
                }
                else if (i == 2) {
                    strDay = [NSString stringWithFormat:@"%@", [arrayDate objectAtIndex:i]];
                }
            }
            
            NSLog(@" answerTime %@:%@ %@", strHour, strMin, strDay);
            
            lblAnswerResult.text = [NSString stringWithFormat:@"Answered at %@:%@ %@", strHour, strMin, strDay];
            
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
    
    [userCommentsDataController.tableView reloadData];
    [userCommentsDataController.tableView setNeedsDisplay];
    
    DataComments *dataComments = userCommentsDataController.dataComments;
    
    NSLog(@"dataComments.totalComments %@", dataComments.totalComments);
    
    if ([dataComments.totalComments intValue] <= 1)
    {
        btnViewComments.hidden = YES;
    }
    else
    {
        btnViewComments.hidden = NO;
    }
    
    if (dataComments.totalComments == nil) {
        lblCommentsCount.text = @"0";
    }
    else{
        lblCommentsCount.text = [NSString stringWithFormat:@"%@", dataComments.totalComments];
    }
    
    lblCommentsCount.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
    
    NSLog(@"userComments.commentsCount %d", userCommentsDataController.commentsCount);
    
    [self.view setNeedsDisplay];
}

- (void)didFinishAddingUserComment
{
    [self didFinishLoadingData];
    
    [userCommentsDataController getComments];
    
    if (isPostToFB == YES) {
        
        [self checkPermissions];
    }
    
    txtComment.text = @"";
    lblCharCount.text = @"350";
    
}

- (void)checkPermissions
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         // re-call assuming we now have the permission
                                                         [self checkPermissions];
                                                     }
                                                 }];
    } else {
        // If permissions present, publish the story
        [self publishComment];
    }
}

- (void)publishComment
{
    // Create the parameters dictionary that will keep the data that will be posted.
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"179699488824039" forKey:@"app_id"];
    [params setObject:[NSString stringWithFormat:@"Comment on the prediction: %@", dataQuestions.questionText] forKey:@"name"];
    [params setObject:@"https://www.facebook.com/Predixer" forKey:@"caption"];
    [params setObject:@"http://www.predixer.com/XLogo_small.png" forKey:@"picture"];
    [params setObject:@"https://www.facebook.com/Predixer" forKey:@"link"];
    [params setObject:@"PrediXer is a fun and simple game! Users play by predicting the outcomes of real life events and earn points for a chance to win cash prizes!" forKey:@"description"];
    [params setObject:[NSString stringWithFormat:@"%@", txtComment.text] forKey:@"message"];
    
    // Publish.
    // This is the most important method that you call. It does the actual job, the message posting.
    [[appDelegate facebook]  requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:nil];
}


- (void)didFinishLoadingData
{
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

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 31.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    //REMOVE ALL CELL SUB-VIEWS FIRST
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
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
                selectedButton = rb.tag;
            }
            else {
                
                rb.btn_RadioButton.enabled = NO;
            }
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
            cell.detailTextLabel.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
            cell.detailTextLabel.textColor = [UIColor blackColor];
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
        
        loadingController = [[LoadingController alloc] init];
        loadingController.strLoadingText = @"Submitting your answer...";
        [self.view addSubview:loadingController.view];
        
        /*
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
        */
        
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
    [answersDataController getAnswers];
    
    [self didFinishLoadingData];
    
    btnSubmitAnswer.enabled = NO;
    
    /*
    for (UIView *vw in self.view.subviews) {
        for (UIButton *btn in vw.subviews) {
            btn.enabled = NO;
        }
    }
    
    UIAlertView *bAlert = [[UIAlertView alloc] initWithTitle:@"Submitted!"
                                                     message:@"Your Answer has been submitted. Kindly post your comments below."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
    [bAlert show];
     */
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
        
        loadingController = [[LoadingController alloc] init];
        loadingController.strLoadingText = @"Submitting your comment...";
        [self.view addSubview:loadingController.view];
        
        /*
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
        */
        
        //SUBMIT COMMENT
        addCommentsController = [[DataCommentAddController alloc] init];
        addCommentsController.questionID = dataQuestions.questionID;
        addCommentsController.commentText = txtComment.text;
        
        isAddNewComment = YES;
        
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
    int count = 349;
    
    if ([textView.text length] <= count) {
        lblCharCount.text = [NSString stringWithFormat:@"%d", count - [textView.text length]];
        lblCharCount.font = [UIFont fontWithName: @"Comic Sans MS" size:10];
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
        if (newLength < 350) {
            isReturn = YES;
        }
    }
    
    return isReturn;
}

- (IBAction)postToFB:(id)sender
{
    if (isPostToFB == NO) {
        isPostToFB = YES;
        btnPostToFB.selected = YES;
    }
    else {
        isPostToFB = NO;
        btnPostToFB.selected = NO;
    }
}

@end
