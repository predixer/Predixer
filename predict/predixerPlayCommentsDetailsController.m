//
//  predixerPlayCommentsDetailsController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/24/12.
//
//

#import "predixerPlayCommentsDetailsController.h"
#import "DataQuestions.h"
#import "DataComments.h"
#import "DataCommentsController.h"
#import "predixerPlayCommentsAllController.h"
#import "predixerSettingsViewControllerViewController.h"

@interface predixerPlayCommentsDetailsController ()

@end

@implementation predixerPlayCommentsDetailsController

@synthesize dataQuestion;
@synthesize dataComment;
@synthesize commentCount;
@synthesize commentsDataController;

- (id)initWithQuestion:(int)questionID comment:(DataComments *)comment count:(int)count
{
    
    if ((self = [super init])) {
                
        if (nil != comment) {
            dataComment = [[DataComments alloc]init];
            dataComment = comment;
        }
        
        if (commentsDataController == nil) {
            commentsDataController = [[DataCommentsController alloc] init];
            
            NSLog(@"Count commentsDataController: %d", [commentsDataController countOfList]);
        }
        
        commentCount = count;
        
        nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(didFinishLikeComment)
                   name:@"didFinishLikeComment"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didFinishGettingUserLikeComment)
                   name:@"didFinishGettingUserLikeComment"
                 object:nil];

    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLikeComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishGettingUserLikeComment" object:nil];
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
    
    lblQuestion.font = [UIFont fontWithName: @"Comic Sans MS" size:16];
    lblCommentDate.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblCommentLikes.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblCommentNumber.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblCommentUser.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    txtComment.font = [UIFont fontWithName: @"Comic Sans MS" size:14];
    
    lblBy.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblComment.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblDate.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    lblLikes.font = [UIFont fontWithName: @"Comic Sans MS" size:13];
    
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
    
    lblCommentUser.text = dataComment.fbName;
    lblCommentDate.text = dataComment.commentDate;
    lblCommentNumber.text = [NSString stringWithFormat:@"%d", commentCount];
    lblCommentLikes.text = @"";
    txtComment.text = dataComment.comment;
    lblCommentLikes.text = dataComment.totalLikes;
    
    
    btnLike.hidden = YES;
    
    commentsDataController.commentID = dataComment.commentID;
    NSLog(@"comment ID %@", dataComment.commentID);
    [commentsDataController getUserCommentLike];
    
    
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

- (IBAction)likeComment:(id)sender
{
    baseAlert = [[UIAlertView alloc] initWithTitle:@"Liking..."
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
    
    commentsDataController.commentID = dataComment.commentID;
    [commentsDataController likeComment];
}

- (IBAction)showMoreComment:(id)sender
{
    predixerPlayCommentsAllController *allComments = [[predixerPlayCommentsAllController alloc] init];
    allComments.dataQuestion = dataQuestion;
    
    [self.navigationController pushViewController:allComments animated:YES];
}

- (void)didFinishLikeComment
{
    if ([lblCommentLikes.text length] == 0)
    {
        lblCommentLikes.text = @"1";
    }
    else if ([lblCommentLikes.text length] > 0) {
        
        int likes = [lblCommentLikes.text intValue];
        
        lblCommentLikes.text = [NSString stringWithFormat:@"%d", likes + 1];
    }
    
    btnLike.hidden = YES;
    
  [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];   
}

- (void)didFinishGettingUserLikeComment
{
    if (commentsDataController.userDidLike == YES) {
        btnLike.enabled = NO;
        btnLike.hidden = YES;
    }
    else
    {
        btnLike.hidden = NO;
    }
}

- (void)performDismiss
{
    if (baseAlert != nil)
    {
        [aiv stopAnimating];
        [baseAlert dismissWithClickedButtonIndex:0 animated:NO];
        baseAlert = nil;
    }
    
    // inform the user
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Thank you for liking!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
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
