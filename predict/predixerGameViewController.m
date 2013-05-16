//
//  predixerGameViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 3/20/13.
//
//

#import "predixerGameViewController.h"
#import "DataQuestions.h"
#import "DataQuestionsController.h"
#import "DataQuestionAnswers.h"
#import "DataQuestionAnswersController.h"
#import "predixerSettingsViewControllerViewController.h"
#import "LoadingController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "MSLabel.h"
#import "Constants.h"
#import "DataAddImageView.h"
#import "predixerViewControllerImageViewer.h"
#import "HCYoutubeParser.h"
#import "DataUserQuestionAnswerSubmitController.h"
#import "DataUserQuestionAnswerController.h"
#import "DataUserQuestionAnswer.h"
#import "predixerAppDelegate.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface predixerGameViewController ()

@end

@implementation predixerGameViewController

@synthesize dataController;
@synthesize dataQuestions;
@synthesize loadingController;
@synthesize answersDataController;
@synthesize questionAnswers;
@synthesize vwImage;
@synthesize dataImageView;
@synthesize submitAnswer;
@synthesize userAnswerController;
@synthesize userAnswer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (dataController == nil) {
			dataController = [[DataQuestionsController alloc] init];
			
			//NSLog(@"Count at init: %d", [dataController countOfList]);
		}
		
        if (answersDataController == nil) {
			answersDataController = [[DataQuestionAnswersController alloc] init];
			
			//NSLog(@"Count at init: %d", [answersDataController countOfList]);
		}
        
        arrIndex = 0;
        
		nc = [NSNotificationCenter defaultCenter];
		
        /*
		//observer
		[nc addObserver:self
			   selector:@selector(didFinishLoadingData)
				   name:@"didFinishLoadingQuestions"
				 object:nil];
        
        [nc addObserver:self
			   selector:@selector(didBecomeActive:)
				   name:UIApplicationDidBecomeActiveNotification
				 object:nil];
                
        [nc addObserver:self
               selector:@selector(didFinishLoadingQuestionAnswers)
                   name:@"didFinishLoadingQuestionAnswers"
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(didCloseImageView)
                   name:@"didCloseImageView"
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
               selector:@selector(getData)
                   name:@"didFinishLoadingQuestionsToday"
                 object:nil];
         */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; //iOS4
    
    // Do any additional setup after loading the view from its nib.
    [self addObservers];
    
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
    
    vwProgress.progress = 0;
    
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Loading...";
    [self.view addSubview:loadingController.view];
    
    lblQuestion = [[MSLabel alloc] initWithFrame:CGRectMake(7.0f, 4.0f, 307.0f, 80.0f)];
    lblQuestion.backgroundColor = [UIColor clearColor];
    lblQuestion.lineHeight = 20;
    lblQuestion.numberOfLines = 3;
    lblQuestion.font = [UIFont fontWithName: @"Verdana" size:16];
    lblQuestion.textColor = [UIColor colorWithRed:0.02f green:0.32f blue:0.52f alpha:1.0f];
    [self.view addSubview:lblQuestion];
    
    [dataController getQuestionsFromDB];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPrevious:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNext:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingQuestions" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingQuestionAnswers" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didCloseImageView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingUserQuestionAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishSubmittingUserAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingQuestionsToday" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; //iOS4
    
    [self addObservers];
}


- (void)addObservers
{
    [nc addObserver:self
           selector:@selector(didFinishLoadingData)
               name:@"didFinishLoadingQuestions"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didBecomeActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didFinishLoadingQuestionAnswers)
               name:@"didFinishLoadingQuestionAnswers"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(didCloseImageView)
               name:@"didCloseImageView"
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
           selector:@selector(getData)
               name:@"didFinishLoadingQuestionsToday"
             object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
	[dataController getQuestionsFromDB];
}

- (void)didFinishLoadingData
{
    
    if ([dataController.arrQuestions count] != 0) {
        
        vwProgress.progress = ((float)(arrIndex + 1)/(float)[dataController.arrQuestions count]);
        
        [self loadDayQuestion];
        

    }
    else {
        [self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
        
        lblQuestion.text = @"There is no question set for today.";
        btnPlay.hidden = YES;
        btnNext.enabled = NO;
        btnPrev.enabled = NO;
        lblTapNotice.hidden = YES;
    }
    
    
}

- (void)loadDayQuestion
{
 
    if (loadingController == nil) {
        loadingController = [[LoadingController alloc] init];
        loadingController.strLoadingText = @"Loading...";
        [self.view addSubview:loadingController.view];
    }
    
    /*
    if (IS_IPHONE5 == YES) {
        lblQuestionPoints.frame = CGRectMake(7.0f, 120.0f, 124.0f, 15.0f);
        btnPlay.frame = CGRectMake(141.0f, 107.0f, 37.0f, 37.0f);
        lblQuestionExpiry.frame = CGRectMake(196.0f, 118.0f, 118.0f, 16.0f);
    }*/
    
    btnSubmitAnswer.hidden = YES;
    lblQuestionHasExpired.hidden = YES;
    lblAnswerResult.text = @"";
    lblAnswerResult.hidden = YES;
    
    
    
    //NSLog(@"arrIndex %d", arrIndex);
    //NSLog(@"arrQuestions %d", [dataController.arrQuestions count]);
    
    
    if ([dataController.arrQuestions count] == 1) {
        arrIndex = 0;
    }
    
    dataQuestions = [dataController objectInListAtIndex:arrIndex];
    
    lblQuestion.text = dataQuestions.questionText;
        
    //NSLog(@" questionText %@",dataQuestions.questionText);
        
    lblQuestionPoints.text = [NSString stringWithFormat:@"Points: %d", dataQuestions.questionPoints];
    lblQuestionPoints.font = [UIFont fontWithName: @"Verdana" size:16];
    
    lblQuestionNumber.text = [NSString stringWithFormat:@"Today's %d of %d", arrIndex+1, [dataController.arrQuestions count]];
    
    if (arrIndex == [dataController.arrQuestions count]-1) {
        btnNext.hidden = true;
        btnPrev.hidden = false;
    }
    else {
        btnNext.hidden = false;
        
        if (arrIndex == 0) {
            
            btnPrev.hidden = true;
        }
        else {
            
            btnPrev.hidden = false;
        }
    }
    
    //NSLog(@"%@", dataQuestions.questionDate);
    
    NSArray *arrayDate = [dataQuestions.questionDate componentsSeparatedByString:@" "];
    
    NSString *strHour = @"";
    NSString *strMin = @"";
    NSString *strDay = @"";
    
    for (int i=0; i < [arrayDate count]; i++) {
        
        if (i == 1) {
            
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
    
    //NSLog(@" answerTime %@ %@:%@ %@", dataQuestions.questionDate, strHour, strMin, strDay);
    
    expireHour = [strHour intValue];
    expireDay = strDay;
    
    lblQuestionExpiry.text = [NSString stringWithFormat:@"Expires at %@:%@ %@", strHour, strMin, strDay];
    lblQuestionExpiry.font = [UIFont fontWithName: @"Verdana" size:12];
    
    answersDataController.questionID = dataQuestions.questionID;
    [answersDataController getAnswers];
    
    [self makeMyProgressBarMoving];
    [self.view bringSubviewToFront:loadingController.view];
}

- (IBAction)loadNext:(id)sender
{
    isNext = YES;
    
    if (arrIndex < [dataController.arrQuestions count]-1) {
        arrIndex++;    
        [self loadDayQuestion];
    }

}

- (IBAction)loadPrevious:(id)sender
{
    isPrevious = YES;
    
    if (arrIndex != 0) {
        arrIndex--;
        [self loadDayQuestion];
    }
    else {
        
    }
}

- (void)removeItems {
        
    [lblAnswer1 removeFromSuperview];
    lblAnswer1 = nil;
    [imgView1 removeFromSuperview];
    imgView1 = nil;
    
    [lblAnswer2 removeFromSuperview];
    lblAnswer2 = nil;
    [imgView2 removeFromSuperview];
    imgView2 = nil;
    
    [lblAnswer3 removeFromSuperview];
    lblAnswer3 = nil;
    [imgView3 removeFromSuperview];
    imgView3 = nil;
    
    [lblAnswer4 removeFromSuperview];
    lblAnswer4 = nil;
    [imgView4 removeFromSuperview];
    imgView4 = nil;
    
    [que1 removeFromSuperview];
    que1 = nil;
    [que2 removeFromSuperview];
    que2 = nil;
    [que3 removeFromSuperview];
    que3 = nil;
    [que4 removeFromSuperview];
    que4 = nil;
    
    [answerBkd1 removeFromSuperview];
    answerBkd1 = nil;
    [answerBkd2 removeFromSuperview];
    answerBkd2 = nil;
    [answerBkd3 removeFromSuperview];
    answerBkd3 = nil;
    [answerBkd4 removeFromSuperview];
    answerBkd4 = nil;
    
    [lblAnswerPercent1 removeFromSuperview];
    lblAnswerPercent1 = nil;
    [lblAnswerPercent2 removeFromSuperview];
    lblAnswerPercent2 = nil;
    [lblAnswerPercent3 removeFromSuperview];
    lblAnswerPercent3 = nil;
    [lblAnswerPercent4 removeFromSuperview];
    lblAnswerPercent4 = nil;
}

- (void)makeMyProgressBarMoving {
    
    
    if (isNext) {
        
        vwProgress.progress = ((float)(arrIndex + 1)/(float)[dataController.arrQuestions count]);
    }
    else if (isPrevious) {
        
        vwProgress.progress = ((float)(arrIndex - 1)/(float)[dataController.arrQuestions count]);
    }
    
}

- (void)didFinishLoadingQuestionAnswers
{
    
    if ([answersDataController countOfList] != 0)
    {
        
        [self removeItems];
        
        if (IS_IPHONE5 == YES) {
        
            if ([answersDataController countOfList] == 2) {
                vwBackground.image = [UIImage  imageNamed:@"q_Answer_Bkd_Two"];
                
                for (int i=0; i < [answersDataController countOfList]; i++) {
                    
                    questionAnswers = [answersDataController objectInListAtIndex:i];
                    
                    
                    if (i==0) {
                        
                        lblAnswer1 = [[MSLabel alloc] init];
                        lblAnswer1.text = questionAnswers.answerText;
                        lblAnswer1.backgroundColor = [UIColor clearColor];
                        lblAnswer1.lineHeight = 12;
                        lblAnswer1.numberOfLines = 2;
                        lblAnswer1.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer1.textColor = [UIColor whiteColor];
                        
                        answerBkd1=[[UIImageView alloc] init];
                        answerBkd1.backgroundColor=[UIColor clearColor];
                        answerBkd1.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView1=[[UIImageView alloc] init];
                        imgView1.backgroundColor=[UIColor clearColor];
                        [imgView1 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView1.userInteractionEnabled = YES;
                        imgView1.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView1 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture1:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView1 addGestureRecognizer:doubleTap];
                        
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView1.frame = CGRectMake(7.0f, 216.0f, 150.0f, 136.0f);
                        lblAnswer1.frame = CGRectMake(12.0f, 324.0f, 150.0f, 34.0f);
                        answerBkd1.frame = CGRectMake(6.0f, 325.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView1];
                        [self.view addSubview:answerBkd1];
                        [self.view addSubview:lblAnswer1];
                        
                        que1 = [[UIImageView alloc] initWithFrame:CGRectMake(128.0f, 217.0f, 29.0f, 23.0f)];
                        que1.backgroundColor=[UIColor clearColor];
                        que1.image = [UIImage imageNamed:@"q_Question.png"];
                        que1.hidden = YES;
                        [self.view addSubview:que1];
                        
                        lblAnswerPercent1 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 216.0f, 150.0f, 24.0f)];
                        lblAnswerPercent1.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent1.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent1.hidden = YES;
                        lblAnswerPercent1.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent1.textColor = [UIColor whiteColor];
                        lblAnswerPercent1.shadowColor = [UIColor blackColor];
                        lblAnswerPercent1.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent1.highlighted = YES;
                        lblAnswerPercent1.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent1];
                        
                    }
                    else if (i==1) {
                        
                        lblAnswer2 = [[MSLabel alloc] init];
                        lblAnswer2.text = questionAnswers.answerText;
                        lblAnswer2.backgroundColor = [UIColor clearColor];
                        lblAnswer2.lineHeight = 12;
                        lblAnswer2.numberOfLines = 2;
                        lblAnswer2.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer2.textColor = [UIColor whiteColor];
                        
                        answerBkd2=[[UIImageView alloc] init];
                        answerBkd2.backgroundColor=[UIColor clearColor];
                        answerBkd2.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView2=[[UIImageView alloc] init];
                        imgView2.backgroundColor=[UIColor clearColor];
                        [imgView2 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView2.userInteractionEnabled = YES;
                        imgView2.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView2 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture2:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView2 addGestureRecognizer:doubleTap];
                        
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView2.frame = CGRectMake(164.0f, 216.0f, 150.0f, 136.0f);
                        lblAnswer2.frame = CGRectMake(170.0f, 324.0f, 150.0f, 34.0f);
                        answerBkd2.frame = CGRectMake(164.0f, 325.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView2];
                        [self.view addSubview:answerBkd2];
                        [self.view addSubview:lblAnswer2];
                        
                        que2 = [[UIImageView alloc] initWithFrame:CGRectMake(285.0f, 217.0f, 29.0f, 23.0f)];
                        que2.backgroundColor=[UIColor clearColor];
                        que2.image = [UIImage imageNamed:@"q_Question.png"];
                        que2.hidden = YES;
                        [self.view addSubview:que2];
                        
                        lblAnswerPercent2 = [[UILabel alloc] initWithFrame:CGRectMake(166.0f, 216.0f, 150.0f, 24.0f)];
                        lblAnswerPercent2.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent2.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent2.hidden = YES;
                        lblAnswerPercent2.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent2.textColor = [UIColor whiteColor];
                        lblAnswerPercent2.shadowColor = [UIColor blackColor];
                        lblAnswerPercent2.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent2.highlighted = YES;
                        lblAnswerPercent2.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent2];
                        
                    }
                    
                }
                
            }
            else if ([answersDataController countOfList] > 2) {
                vwBackground.image = [UIImage  imageNamed:@"q_Answer_Bkd_Four"];
                
                
                for (int i=0; i < [answersDataController countOfList]; i++) {
                    
                    questionAnswers = [answersDataController objectInListAtIndex:i];
                    
                    
                    if (i==0) {
                        
                        lblAnswer1 = [[MSLabel alloc] init];
                        lblAnswer1.text = questionAnswers.answerText;
                        lblAnswer1.backgroundColor = [UIColor clearColor];
                        lblAnswer1.lineHeight = 12;
                        lblAnswer1.numberOfLines = 2;
                        lblAnswer1.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer1.textColor = [UIColor whiteColor];
                        
                        answerBkd1=[[UIImageView alloc] init];
                        answerBkd1.backgroundColor=[UIColor clearColor];
                        answerBkd1.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView1=[[UIImageView alloc] init];
                        imgView1.backgroundColor=[UIColor clearColor];
                        [imgView1 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView1.userInteractionEnabled = YES;
                        imgView1.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView1 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture1:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView1 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView1.frame = CGRectMake(7.0f, 143.0f, 150.0f, 137.0f);
                        lblAnswer1.frame = CGRectMake(12.0f, 251.0f, 150.0f, 34.0f);
                        answerBkd1.frame = CGRectMake(6.0f, 252.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView1];
                        [self.view addSubview:answerBkd1];
                        [self.view addSubview:lblAnswer1];
                        
                        que1 = [[UIImageView alloc] initWithFrame:CGRectMake(129.0f, 145.0f, 29.0f, 23.0f)];
                        que1.backgroundColor=[UIColor clearColor];
                        que1.image = [UIImage imageNamed:@"q_Question.png"];
                        que1.hidden = YES;
                        [self.view addSubview:que1];
                        
                        lblAnswerPercent1 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 142.0f, 150.0f, 24.0f)];
                        lblAnswerPercent1.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent1.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent1.hidden = YES;
                        lblAnswerPercent1.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent1.textColor = [UIColor whiteColor];
                        lblAnswerPercent1.shadowColor = [UIColor blackColor];
                        lblAnswerPercent1.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent1.highlighted = YES;
                        lblAnswerPercent1.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent1];
                        
                    }
                    else if (i==1) {
                        
                        lblAnswer2 = [[MSLabel alloc] init];
                        lblAnswer2.text = questionAnswers.answerText;
                        lblAnswer2.backgroundColor = [UIColor clearColor];
                        lblAnswer2.lineHeight = 12;
                        lblAnswer2.numberOfLines = 2;
                        lblAnswer2.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer2.textColor = [UIColor whiteColor];
                        
                        answerBkd2=[[UIImageView alloc] init];
                        answerBkd2.backgroundColor=[UIColor clearColor];
                        answerBkd2.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView2=[[UIImageView alloc] init];
                        imgView2.backgroundColor=[UIColor clearColor];
                        [imgView2 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView2.userInteractionEnabled = YES;
                        imgView2.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView2 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture2:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView2 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView2.frame = CGRectMake(164.0f, 143.0f, 150.0f, 137.0f);
                        lblAnswer2.frame = CGRectMake(170.0f, 251.0f, 150.0f, 34.0f);
                        answerBkd2.frame = CGRectMake(163.0f, 252.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView2];
                        [self.view addSubview:answerBkd2];
                        [self.view addSubview:lblAnswer2];
                        
                        que2 = [[UIImageView alloc] initWithFrame:CGRectMake(286.0f, 145.0f, 29.0f, 23.0f)];
                        que2.backgroundColor=[UIColor clearColor];
                        que2.image = [UIImage imageNamed:@"q_Question.png"];
                        que2.hidden = YES;
                        [self.view addSubview:que2];
                        
                        lblAnswerPercent2 = [[UILabel alloc] initWithFrame:CGRectMake(165.0f, 142.0f, 150.0f, 24.0f)];
                        lblAnswerPercent2.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent2.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent2.hidden = YES;
                        lblAnswerPercent2.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent2.textColor = [UIColor whiteColor];
                        lblAnswerPercent2.shadowColor = [UIColor blackColor];
                        lblAnswerPercent2.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent2.highlighted = YES;
                        lblAnswerPercent2.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent2];
                    }
                    else if (i==2) {
                        
                        lblAnswer3 = [[MSLabel alloc] init];
                        lblAnswer3.text = questionAnswers.answerText;
                        lblAnswer3.backgroundColor = [UIColor clearColor];
                        lblAnswer3.lineHeight = 12;
                        lblAnswer3.numberOfLines = 2;
                        lblAnswer3.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer3.textColor = [UIColor whiteColor];
                        
                        answerBkd3=[[UIImageView alloc] init];
                        answerBkd3.backgroundColor=[UIColor clearColor];
                        answerBkd3.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView3=[[UIImageView alloc] init];
                        imgView3.backgroundColor=[UIColor clearColor];
                        [imgView3 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView3.userInteractionEnabled = YES;
                        imgView3.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView3 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture3:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView3 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView3.frame = CGRectMake(7.0f, 288.0f, 150.0f, 136.0f);
                        lblAnswer3.frame = CGRectMake(12.0f, 394.0f, 150.0f, 34.0f);
                        answerBkd3.frame = CGRectMake(6.0f, 395.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView3];
                        [self.view addSubview:answerBkd3];
                        [self.view addSubview:lblAnswer3];
                        
                        que3 = [[UIImageView alloc] initWithFrame:CGRectMake(128.0f, 290.0f, 29.0f, 23.0f)];
                        que3.backgroundColor=[UIColor clearColor];
                        que3.image = [UIImage imageNamed:@"q_Question.png"];
                        que3.hidden = YES;
                        [self.view addSubview:que3];
                        
                        lblAnswerPercent3 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 287.0f, 150.0f, 24.0f)];
                        lblAnswerPercent3.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent3.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent3.hidden = YES;
                        lblAnswerPercent3.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent3.textColor = [UIColor whiteColor];
                        lblAnswerPercent3.shadowColor = [UIColor blackColor];
                        lblAnswerPercent3.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent3.highlighted = YES;
                        lblAnswerPercent3.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent3];
                    }
                    else if (i==3) {
                        
                        lblAnswer4 = [[MSLabel alloc] init];
                        lblAnswer4.text = questionAnswers.answerText;
                        lblAnswer4.backgroundColor = [UIColor clearColor];
                        lblAnswer4.lineHeight = 12;
                        lblAnswer4.numberOfLines = 2;
                        lblAnswer4.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer4.textColor = [UIColor whiteColor];
                        
                        answerBkd4=[[UIImageView alloc] init];
                        answerBkd4.backgroundColor=[UIColor clearColor];
                        answerBkd4.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView4=[[UIImageView alloc] init];
                        imgView4.backgroundColor=[UIColor clearColor];
                        [imgView4 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView4.userInteractionEnabled = YES;
                        imgView4.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView4 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture4:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView4 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView4.frame = CGRectMake(164.0f, 288.0f, 150.0f, 136.0f);
                        lblAnswer4.frame = CGRectMake(170.0f, 394.0f, 150.0f, 34.0f);
                        answerBkd4.frame = CGRectMake(163.0f, 395.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView4];
                        [self.view addSubview:answerBkd4];
                        [self.view addSubview:lblAnswer4];
                        
                        que4 = [[UIImageView alloc] initWithFrame:CGRectMake(285.0f, 290.0f, 29.0f, 23.0f)];
                        que4.backgroundColor=[UIColor clearColor];
                        que4.image = [UIImage imageNamed:@"q_Question.png"];
                        que4.hidden = YES;
                        [self.view addSubview:que4];
                        
                        lblAnswerPercent4 = [[UILabel alloc] initWithFrame:CGRectMake(166.0f, 288.0f, 150.0f, 24.0f)];
                        lblAnswerPercent4.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent4.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent4.hidden = YES;
                        lblAnswerPercent4.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent4.textColor = [UIColor whiteColor];
                        lblAnswerPercent4.shadowColor = [UIColor blackColor];
                        lblAnswerPercent4.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent4.highlighted = YES;
                        lblAnswerPercent4.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent4];
                    }
                    
                }
                
            }
        }
        else { // IPHONE 4
            
            if ([answersDataController countOfList] == 2) {
                vwBackground.image = [UIImage  imageNamed:@"q_Answer_Bkd_Two"];
                
                for (int i=0; i < [answersDataController countOfList]; i++) {
                    
                    questionAnswers = [answersDataController objectInListAtIndex:i];
                    
                    
                    if (i==0) {
                        
                        lblAnswer1 = [[MSLabel alloc] init];
                        lblAnswer1.text = questionAnswers.answerText;
                        lblAnswer1.backgroundColor = [UIColor clearColor];
                        lblAnswer1.lineHeight = 12;
                        lblAnswer1.numberOfLines = 2;
                        lblAnswer1.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer1.textColor = [UIColor whiteColor];
                        
                        answerBkd1=[[UIImageView alloc] init];
                        answerBkd1.backgroundColor=[UIColor clearColor];
                        answerBkd1.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView1=[[UIImageView alloc] init];
                        imgView1.backgroundColor=[UIColor clearColor];
                        [imgView1 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView1.userInteractionEnabled = YES;
                        imgView1.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView1 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture1:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView1 addGestureRecognizer:doubleTap];
                        
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView1.frame = CGRectMake(7.0f, 179.0f, 150.0f, 114.0f);
                        lblAnswer1.frame = CGRectMake(12.0f, 263.0f, 150.0f, 34.0f);
                        answerBkd1.frame = CGRectMake(6.0f, 264.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView1];
                        [self.view addSubview:answerBkd1];
                        [self.view addSubview:lblAnswer1];
                        
                        que1 = [[UIImageView alloc] initWithFrame:CGRectMake(128.0f, 180.0f, 29.0f, 23.0f)];
                        que1.backgroundColor=[UIColor clearColor];
                        que1.image = [UIImage imageNamed:@"q_Question.png"];
                        que1.hidden = YES;
                        [self.view addSubview:que1];
                        
                        lblAnswerPercent1 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 179.0f, 150.0f, 24.0f)];
                        lblAnswerPercent1.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent1.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent1.hidden = YES;
                        lblAnswerPercent1.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent1.textColor = [UIColor whiteColor];
                        lblAnswerPercent1.shadowColor = [UIColor blackColor];
                        lblAnswerPercent1.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent1.highlighted = YES;
                        lblAnswerPercent1.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent1];

                        
                    }
                    else if (i==1) {
                        
                        lblAnswer2 = [[MSLabel alloc] init];
                        lblAnswer2.text = questionAnswers.answerText;
                        lblAnswer2.backgroundColor = [UIColor clearColor];
                        lblAnswer2.lineHeight = 12;
                        lblAnswer2.numberOfLines = 2;
                        lblAnswer2.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer2.textColor = [UIColor whiteColor];
                        
                        answerBkd2=[[UIImageView alloc] init];
                        answerBkd2.backgroundColor=[UIColor clearColor];
                        answerBkd2.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView2=[[UIImageView alloc] init];
                        imgView2.backgroundColor=[UIColor clearColor];
                        [imgView2 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView2.userInteractionEnabled = YES;
                        imgView2.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView2 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture2:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView2 addGestureRecognizer:doubleTap];
                        
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView2.frame = CGRectMake(164.0f, 179.0f, 150.0f, 114.0f);
                        lblAnswer2.frame = CGRectMake(170.0f, 263.0f, 150.0f, 34.0f);
                        answerBkd2.frame = CGRectMake(164.0f, 264.0f, 150.0f, 30.0f);
                        [self.view addSubview:imgView2];
                        [self.view addSubview:answerBkd2];
                        [self.view addSubview:lblAnswer2];
                        
                        que2 = [[UIImageView alloc] initWithFrame:CGRectMake(285.0f, 180.0f, 29.0f, 23.0f)];
                        que2.backgroundColor=[UIColor clearColor];
                        que2.image = [UIImage imageNamed:@"q_Question.png"];
                        que2.hidden = YES;
                        [self.view addSubview:que2];
                        
                        lblAnswerPercent2 = [[UILabel alloc] initWithFrame:CGRectMake(166.0f, 179.0f, 150.0f, 24.0f)];
                        lblAnswerPercent2.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent2.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent2.hidden = YES;
                        lblAnswerPercent2.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent2.textColor = [UIColor whiteColor];
                        lblAnswerPercent2.shadowColor = [UIColor blackColor];
                        lblAnswerPercent2.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent2.highlighted = YES;
                        lblAnswerPercent2.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent2];
                    }
                    
                }

            }
            else if ([answersDataController countOfList] > 2) {
                vwBackground.image = [UIImage  imageNamed:@"q_Answer_Bkd_Four"];
                
                
                
                for (int i=0; i < [answersDataController countOfList]; i++) {
                    
                    questionAnswers = [answersDataController objectInListAtIndex:i];
                    
                    
                    if (i==0) {
                        
                        lblAnswer1 = [[MSLabel alloc] init];
                        lblAnswer1.text = questionAnswers.answerText;
                        lblAnswer1.backgroundColor = [UIColor clearColor];
                        lblAnswer1.lineHeight = 12;
                        lblAnswer1.numberOfLines = 2;
                        lblAnswer1.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer1.textColor = [UIColor whiteColor];
                        
                        answerBkd1=[[UIImageView alloc] init];
                        answerBkd1.backgroundColor=[UIColor clearColor];
                        answerBkd1.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView1=[[UIImageView alloc] init];
                        imgView1.backgroundColor=[UIColor clearColor];
                        [imgView1 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView1.userInteractionEnabled = YES;
                        imgView1.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView1 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture1:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView1 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView1.frame = CGRectMake(7.0f, 119.0f, 150.0f, 114.0f);
                        lblAnswer1.frame = CGRectMake(12.0f, 202.0f, 150.0f, 34.0f);
                        answerBkd1.frame = CGRectMake(6.0f, 204.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView1];
                        [self.view addSubview:answerBkd1];
                        [self.view addSubview:lblAnswer1];
                        
                        que1 = [[UIImageView alloc] initWithFrame:CGRectMake(129.0f, 120.0f, 29.0f, 23.0f)];
                        que1.backgroundColor=[UIColor clearColor];
                        que1.image = [UIImage imageNamed:@"q_Question.png"];
                        que1.hidden = YES;
                        [self.view addSubview:que1];
                        
                        lblAnswerPercent1 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 119.0f, 150.0f, 24.0f)];
                        lblAnswerPercent1.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent1.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent1.hidden = YES;
                        lblAnswerPercent1.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent1.textColor = [UIColor whiteColor];
                        lblAnswerPercent1.shadowColor = [UIColor blackColor];
                        lblAnswerPercent1.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent1.highlighted = YES;
                        lblAnswerPercent1.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent1];
                        
                    }
                    else if (i==1) {
                        
                        lblAnswer2 = [[MSLabel alloc] init];
                        lblAnswer2.text = questionAnswers.answerText;
                        lblAnswer2.backgroundColor = [UIColor clearColor];
                        lblAnswer2.lineHeight = 12;
                        lblAnswer2.numberOfLines = 2;
                        lblAnswer2.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer2.textColor = [UIColor whiteColor];
                        
                        answerBkd2=[[UIImageView alloc] init];
                        answerBkd2.backgroundColor=[UIColor clearColor];
                        answerBkd2.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView2=[[UIImageView alloc] init];
                        imgView2.backgroundColor=[UIColor clearColor];
                        [imgView2 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView2.userInteractionEnabled = YES;
                        imgView2.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView2 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture2:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView2 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView2.frame = CGRectMake(164.0f, 119.0f, 150.0f, 114.0f);
                        lblAnswer2.frame = CGRectMake(170.0f, 203.0f, 150.0f, 34.0f);
                        answerBkd2.frame = CGRectMake(163.0f, 204.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView2];
                        [self.view addSubview:answerBkd2];
                        [self.view addSubview:lblAnswer2];
                        
                        que2 = [[UIImageView alloc] initWithFrame:CGRectMake(286.0f, 120.0f, 29.0f, 23.0f)];
                        que2.backgroundColor=[UIColor clearColor];
                        que2.image = [UIImage imageNamed:@"q_Question.png"];
                        que2.hidden = YES;
                        [self.view addSubview:que2];
                        
                        lblAnswerPercent2 = [[UILabel alloc] initWithFrame:CGRectMake(165.0f, 119.0f, 150.0f, 24.0f)];
                        lblAnswerPercent2.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent2.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent2.hidden = YES;
                        lblAnswerPercent2.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent2.textColor = [UIColor whiteColor];
                        lblAnswerPercent2.shadowColor = [UIColor blackColor];
                        lblAnswerPercent2.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent2.highlighted = YES;
                        lblAnswerPercent2.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent2];
                    }
                    else if (i==2) {
                        
                        lblAnswer3 = [[MSLabel alloc] init];
                        lblAnswer3.text = questionAnswers.answerText;
                        lblAnswer3.backgroundColor = [UIColor clearColor];
                        lblAnswer3.lineHeight = 12;
                        lblAnswer3.numberOfLines = 2;
                        lblAnswer3.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer3.textColor = [UIColor whiteColor];
                        
                        answerBkd3=[[UIImageView alloc] init];
                        answerBkd3.backgroundColor=[UIColor clearColor];
                        answerBkd3.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView3=[[UIImageView alloc] init];
                        imgView3.backgroundColor=[UIColor clearColor];
                        [imgView3 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView3.userInteractionEnabled = YES;
                        imgView3.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView3 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture3:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView3 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView3.frame = CGRectMake(7.0f, 239.0f, 150.0f, 114.0f);
                        lblAnswer3.frame = CGRectMake(12.0f, 324.0f, 150.0f, 34.0f);
                        answerBkd3.frame = CGRectMake(6.0f, 324.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView3];
                        [self.view addSubview:answerBkd3];
                        [self.view addSubview:lblAnswer3];
                        
                        que3 = [[UIImageView alloc] initWithFrame:CGRectMake(128.0f, 240.0f, 29.0f, 23.0f)];
                        que3.backgroundColor=[UIColor clearColor];
                        que3.image = [UIImage imageNamed:@"q_Question.png"];
                        que3.hidden = YES;
                        [self.view addSubview:que3];
                        
                        lblAnswerPercent3 = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 239.0f, 150.0f, 24.0f)];
                        lblAnswerPercent3.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent3.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent3.hidden = YES;
                        lblAnswerPercent3.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent3.textColor = [UIColor whiteColor];
                        lblAnswerPercent3.shadowColor = [UIColor blackColor];
                        lblAnswerPercent3.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent3.highlighted = YES;
                        lblAnswerPercent3.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent3];
                    }
                    else if (i==3) {
                        
                        lblAnswer4 = [[MSLabel alloc] init];
                        lblAnswer4.text = questionAnswers.answerText;
                        lblAnswer4.backgroundColor = [UIColor clearColor];
                        lblAnswer4.lineHeight = 12;
                        lblAnswer4.numberOfLines = 2;
                        lblAnswer4.font = [UIFont fontWithName: @"Verdana" size:14];
                        lblAnswer4.textColor = [UIColor whiteColor];
                        
                        answerBkd4=[[UIImageView alloc] init];
                        answerBkd4.backgroundColor=[UIColor clearColor];
                        answerBkd4.image = [UIImage imageNamed:@"bkd_Answer_Select"];
                        
                        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Uploads/%@", WebsiteURL, questionAnswers.imageName];
                        
                        //NSLog(@"questionAnswers.imageName %@",questionAnswers.imageName);
                        //NSLog(@"urlString %@",urlString);
                        
                        imgView4=[[UIImageView alloc] init];
                        imgView4.backgroundColor=[UIColor clearColor];
                        [imgView4 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                        imgView4.userInteractionEnabled = YES;
                        imgView4.tag = questionAnswers.answerID;
                        
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
                        singleTap.numberOfTapsRequired = 1;
                        [imgView4 addGestureRecognizer:singleTap];
                        
                        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPicture4:)];
                        doubleTap.numberOfTapsRequired = 2;
                        [imgView4 addGestureRecognizer:doubleTap];
                        [singleTap requireGestureRecognizerToFail:doubleTap];
                        
                        imgView4.frame = CGRectMake(164.0f, 239.0f, 150.0f, 114.0f);
                        lblAnswer4.frame = CGRectMake(170.0f, 324.0f, 150.0f, 34.0f);
                        answerBkd4.frame = CGRectMake(163.0f, 324.0f, 152.0f, 30.0f);
                        [self.view addSubview:imgView4];
                        [self.view addSubview:answerBkd4];
                        [self.view addSubview:lblAnswer4];
                        
                        que4 = [[UIImageView alloc] initWithFrame:CGRectMake(285.0f, 240.0f, 29.0f, 23.0f)];
                        que4.backgroundColor=[UIColor clearColor];
                        que4.image = [UIImage imageNamed:@"q_Question.png"];
                        que4.hidden = YES;
                        [self.view addSubview:que4];
                        
                        lblAnswerPercent4 = [[UILabel alloc] initWithFrame:CGRectMake(166.0f, 239.0f, 150.0f, 24.0f)];
                        lblAnswerPercent4.text = [NSString stringWithFormat:@"%.0f%%", questionAnswers.answerPercent * 100];
                        lblAnswerPercent4.backgroundColor = [UIColor clearColor];
                        lblAnswerPercent4.hidden = YES;
                        lblAnswerPercent4.font = [UIFont fontWithName: @"Verdana" size:13];
                        lblAnswerPercent4.textColor = [UIColor whiteColor];
                        lblAnswerPercent4.shadowColor = [UIColor blackColor];
                        lblAnswerPercent4.shadowOffset = CGSizeMake(0,1);
                        lblAnswerPercent4.highlighted = YES;
                        lblAnswerPercent4.highlightedTextColor = [UIColor greenColor];
                        [self.view addSubview:lblAnswerPercent4];
                    }
                    
                }

            }
            
        }
    
    }
    
    
    [self.view bringSubviewToFront:loadingController.view];
    
    
    
    if (userAnswerController == nil) {
        userAnswerController = [[DataUserQuestionAnswerController alloc]init];
    }
    
    
    userAnswerController.questionID = dataQuestions.questionID;
    [userAnswerController getAnswer];
        
}

- (void)performDismiss
{
    [loadingController.view removeFromSuperview];
    loadingController = nil;
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

- (void)didBecomeActive:(NSNotification *)notification
{
    if (vwImage != nil) {
        [self didCloseImageView];
    }
}

- (void)showPicture:(id)sender
{
    UIGestureRecognizer *clicked = (UIGestureRecognizer *) sender;
    //NSLog(@"single tap %d", clicked.view.tag);
    
    NSString *urlString;
    NSString *imgDesc;
    NSString *imgLink;
    NSString *imgID;
    
    for(UISwipeGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        gestureRecognizer.enabled = NO;
    }
    
    for (DataQuestionAnswers *ans in answersDataController.arrAnswers) {
        
        if (ans.answerID == clicked.view.tag) {
            urlString = [[NSString alloc] initWithFormat:@"http://www.predixer.com/Uploads/%@",ans.imageName];
            
            imgDesc = [[NSString alloc] initWithFormat:@"%@",ans.description];
            
            imgLink = [[NSString alloc] initWithFormat:@"%@",ans.link];
            
            imgID = [[NSString alloc] initWithFormat:@"%@",ans.imageID];
        }
    }
    
    vwImage = [[predixerViewControllerImageViewer alloc] init:urlString description:imgDesc link:imgLink imgID:imgID];
    vwImage.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    vwImage.view.backgroundColor = [UIColor yellowColor];
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                           [self.view addSubview:vwImage.view];
                       } completion:nil];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (dataImageView == nil) {
        dataImageView = [[DataAddImageView alloc] init];
        
        //NSLog(@"imgID %@", imgID);
        
        [dataImageView addImageView:imgID isImageView:true];
    }
    

    
    
}

- (void)didCloseImageView
{
    [vwImage.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];
    
    dataImageView = nil;
    
    for(UISwipeGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        gestureRecognizer.enabled = YES;
    }
}

- (void)selectPicture1:(id)sender
{
    UIGestureRecognizer *clicked = (UIGestureRecognizer *) sender;
    //NSLog(@"double tap selectPicture1 %d", clicked.view.tag);
    
    selectedAnswerID = clicked.view.tag;
    
    que1.hidden = NO;
    que2.hidden = YES;
    que3.hidden = YES;
    que4.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSDate *date = [dateFormat dateFromString:dataQuestions.questionDate];
    //NSLog(@"%@", date);
    
    if ([self hasExpired:date] == YES) {
        btnSubmitAnswer.hidden = YES;
        lblQuestionHasExpired.hidden = NO;

        lblAnswerPercent1.hidden = NO;
        lblAnswerPercent2.hidden = NO;
        lblAnswerPercent3.hidden = NO;
        lblAnswerPercent4.hidden = NO;
        
        //NSLog(@"Question has expired");
    }
    else {
        btnSubmitAnswer.hidden = NO;
        lblQuestionHasExpired.hidden = YES;
    }
    
    
}

- (void)selectPicture2:(id)sender
{
    UIGestureRecognizer *clicked = (UIGestureRecognizer *) sender;
    //NSLog(@"double tap selectPicture2 %d", clicked.view.tag);
    
    selectedAnswerID = clicked.view.tag;
    
    que1.hidden = YES;
    que2.hidden = NO;
    que3.hidden = YES;
    que4.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSDate *date = [dateFormat dateFromString:dataQuestions.questionDate];
    //NSLog(@"%@", date);
    
    if ([self hasExpired:date] == YES) {
        btnSubmitAnswer.hidden = YES;
        lblQuestionHasExpired.hidden = NO;
        
        lblAnswerPercent1.hidden = NO;
        lblAnswerPercent2.hidden = NO;
        lblAnswerPercent3.hidden = NO;
        lblAnswerPercent4.hidden = NO;
        
        //NSLog(@"Question has expired");
    }
    else {
        btnSubmitAnswer.hidden = NO;
        lblQuestionHasExpired.hidden = YES;
    }
}

- (void)selectPicture3:(id)sender
{
    UIGestureRecognizer *clicked = (UIGestureRecognizer *) sender;
    //NSLog(@"double tap selectPicture3 %d", clicked.view.tag);
    
    selectedAnswerID = clicked.view.tag;
    
    que1.hidden = YES;
    que2.hidden = YES;
    que3.hidden = NO;
    que4.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSDate *date = [dateFormat dateFromString:dataQuestions.questionDate];
    //NSLog(@"%@", date);
    
    if ([self hasExpired:date] == YES) {
        btnSubmitAnswer.hidden = YES;
        lblQuestionHasExpired.hidden = NO;
        
        lblAnswerPercent1.hidden = NO;
        lblAnswerPercent2.hidden = NO;
        lblAnswerPercent3.hidden = NO;
        lblAnswerPercent4.hidden = NO;
        
        //NSLog(@"Question has expired");
    }
    else {
        btnSubmitAnswer.hidden = NO;
        lblQuestionHasExpired.hidden = YES;
    }
}

- (void)selectPicture4:(id)sender
{
    UIGestureRecognizer *clicked = (UIGestureRecognizer *) sender;
    //NSLog(@"double tap selectPicture4 %d", clicked.view.tag);
    
    selectedAnswerID = clicked.view.tag;
    
    que1.hidden = YES;
    que2.hidden = YES;
    que3.hidden = YES;
    que4.hidden = NO;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSDate *date = [dateFormat dateFromString:dataQuestions.questionDate];
    //NSLog(@"%@", date);
    
    if ([self hasExpired:date] == YES) {
        btnSubmitAnswer.hidden = YES;
        lblQuestionHasExpired.hidden = NO;
        
        lblAnswerPercent1.hidden = NO;
        lblAnswerPercent2.hidden = NO;
        lblAnswerPercent3.hidden = NO;
        lblAnswerPercent4.hidden = NO;
        
        //NSLog(@"Question has expired");
    }
    else {
        btnSubmitAnswer.hidden = NO;
        lblQuestionHasExpired.hidden = YES;
    }
}

- (IBAction)playVideo:(id)sender
{
    NSURL *urlToLoad;
    //NSLog(@"dataQuestions.videoURL %@", dataQuestions.videoURL);
    
    NSURL *url = [NSURL URLWithString:dataQuestions.videoURL];
    NSDictionary *video = [HCYoutubeParser h264videosWithYoutubeURL:url];
    
    urlToLoad = [NSURL URLWithString:[video objectForKey:@"medium"]];
    //NSLog(@"urlToLoad %@", urlToLoad);
    
    /*
    urlToLoad = [NSURL URLWithString:[video objectForKey:@"small"]];
    NSLog(@"urlToLoad %@", urlToLoad);
    urlToLoad = [NSURL URLWithString:[video objectForKey:@"high"]];
    NSLog(@"urlToLoad %@", urlToLoad);
    */
    
    if (urlToLoad) {
        
        // Initialize the movie player view controller with a video URL string
        playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:urlToLoad];
        
        // Remove the movie player view controller from the "playback did finish" notification observers
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:playerController.moviePlayer];
        
        playerController.wantsFullScreenLayout = YES;
        playerController.moviePlayer.controlStyle = MPMovieControlStyleDefault;
        playerController.moviePlayer.shouldAutoplay = YES;
        //playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        //[self.navigationController setNavigationBarHidden:YES];
        //[playerController.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
        //[playerController.view setFrame:self.view.bounds];
        //[playerController.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
        
        // Start playback
        [playerController.moviePlayer prepareToPlay];
        [playerController.moviePlayer play];
        
        // Present the movie player view controller
        //[self presentModalViewController:playerController animated:YES];
        [self presentMoviePlayerViewControllerAnimated:playerController];
        //[self.view addSubview:playerController.view];
        //[self.navigationController presentModalViewController:playerController animated:YES];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btnStopPlay.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissPlayer:) forControlEvents:UIControlEventTouchDown];
        
        if (IS_IPHONE5 == YES) {
            button.frame = CGRectMake(518.0f, 280.0f, 33.0, 34.0);
        }
        else {
            button.frame = CGRectMake(430.0f, 280.0f, 33.0, 34.0);
        }
        
        [playerController.view addSubview:button];
        
        [self updateVideoRotationForCurrentRotationWithAnimation:YES];
    }
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    MPMoviePlayerController *player = [aNotification object];
    
    [player stop];
    
    // Obtain the reason why the movie playback finished
    //NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Remove this class from the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    // Dismiss the view controller
    //[self dismissModalViewControllerAnimated:YES];
    //[playerController.view removeFromSuperview];
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void)dismissPlayer:(id)sender
{
    [self dismissMoviePlayerViewControllerAnimated];
}

- (BOOL) hasExpird
{
    BOOL expired = NO;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
    NSString *strTime = [dateFormat stringFromDate:today];
    
    //NSLog(@"strTime %@", strTime);
    
    NSArray *arrayDate = [strTime componentsSeparatedByString:@" "];
    
    NSString *strTodayHour = @"";
    NSString *strTodayMin = @"";
    NSString *strToDay = @"";
    
    for (int i=0; i < [arrayDate count]; i++) {
        
        if (i == 1) {
            
            NSArray *arrayTime = [[arrayDate objectAtIndex:i] componentsSeparatedByString:@":"];
            
            for (int j=0; j < [arrayTime count]; j++) {
                
                if (j==0) {
                    strTodayHour = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                }
                else if (j==1) {
                    strTodayMin = [NSString stringWithFormat:@"%@", [arrayTime objectAtIndex:j]];
                }
            }
        }
        else if (i == 2) {
            strToDay = [NSString stringWithFormat:@"%@", [arrayDate objectAtIndex:i]];
        }
    }
    
    if ([strTodayHour intValue] >= expireHour && [strToDay isEqualToString:expireDay]) {
        expired = YES;
    }
    
    return expired;
}

- (BOOL) hasExpired:(NSDate*)myDate
{
    if(myDate == nil)
    {
        return false;
    }
    NSDate *now = [NSDate date];
    
    //NSLog(@"%d", !([now compare:myDate] == NSOrderedAscending));
    
    return !([now compare:myDate] == NSOrderedAscending);
}

- (IBAction)submitAnswer:(id)sender
{
    
    if (selectedAnswerID != 0) {
        
        loadingController = [[LoadingController alloc] init];
        loadingController.strLoadingText = @"Submitting your answer...";
        [self.view addSubview:loadingController.view];
        
        //SUBMIT ANSWER
        submitAnswer = [[DataUserQuestionAnswerSubmitController alloc] init];
        submitAnswer.questionId = dataQuestions.questionID;
        submitAnswer.answerId = [NSString stringWithFormat:@"%d",selectedAnswerID];
        //[submitAnswer submitQuestionAnswer];
        [submitAnswer submitUserAnswer];
        
    }
    else {
        UIAlertView *bAlert = [[UIAlertView alloc] initWithTitle:@"No Answer!"
                                                         message:@"Please select your answer first by double tapping a picture."
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [bAlert show];
    }
    
    
}

- (void)didFinishSubmittingUserAnswer {
    
    [answersDataController getAnswers];

    btnSubmitAnswer.hidden = YES;
}

- (void)didFinishLoadingUserAnswer {
    
	[self performSelector:@selector(performDismiss) withObject:nil afterDelay:0.0f];
    
    hasFetchedUserAnswer = YES;
    
    if ([userAnswerController countOfList] > 0) {
        
        userAnswer = [userAnswerController objectInListAtIndex:0];
        
        if (userAnswer.questionID == [dataQuestions.questionID intValue]) {
            
            
            //NSLog(@" userAnswer.answerDate %@",userAnswer.answerDate);
            
            NSArray *arrayDate = [userAnswer.answerDate componentsSeparatedByString:@" "];
            
            NSString *strHour = @"";
            NSString *strMin = @"";
            NSString *strDay = @"";
            
            for (int i=0; i < [arrayDate count]; i++) {
                
                //NSLog(@" arrayDate %@",[arrayDate objectAtIndex:i]);
                
                if (i == 1) {
                    //NSLog(@" time %@",[arrayDate objectAtIndex:i]);
                    
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
            
            //NSLog(@" answerTime %@:%@ %@", strHour, strMin, strDay);
            
            lblAnswerResult.text = [NSString stringWithFormat:@"Answered at %@:%@ %@", strHour, strMin, strDay];
            lblAnswerResult.hidden = NO;
            
            btnSubmitAnswer.hidden = YES;
            
            //NSLog(@"imgView1 %d %d", userAnswer.answerSelectionID, imgView1.tag);
            
            //NSLog(@"imgView2 %d %d", userAnswer.answerSelectionID, imgView2.tag);
            
            //NSLog(@"imgView3 %d %d", userAnswer.answerSelectionID, imgView3.tag);
            
            //NSLog(@"imgView4 %d %d", userAnswer.answerSelectionID, imgView4.tag);
            
            if (userAnswer.answerSelectionID == imgView1.tag) {
                que1.hidden = NO;
                
            }
            else if (userAnswer.answerSelectionID == imgView2.tag) {
                que2.hidden = NO;
                
            }
            else if (userAnswer.answerSelectionID == imgView3.tag) {
                que3.hidden = NO;
                
                
            }
            else if (userAnswer.answerSelectionID == imgView4.tag) {
                que4.hidden = NO;
                
            }
            
            //REMOVE DOUBLE TAP
            
            if (imgView1.gestureRecognizers.count == 2) {
                [imgView1 removeGestureRecognizer:[imgView1.gestureRecognizers objectAtIndex:1]];
            }
            
            if (imgView2.gestureRecognizers.count == 2) {
                [imgView2 removeGestureRecognizer:[imgView2.gestureRecognizers objectAtIndex:1]];
            }
            
            if (imgView3.gestureRecognizers.count == 2) {
                [imgView3 removeGestureRecognizer:[imgView3.gestureRecognizers objectAtIndex:1]];
            }
            
            if (imgView4.gestureRecognizers.count == 2) {
                [imgView4 removeGestureRecognizer:[imgView4.gestureRecognizers objectAtIndex:1]];
            }
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormat setLocale:usLocale];
            [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
            NSDate *date = [dateFormat dateFromString:dataQuestions.questionDate];
            //NSLog(@"%@", date);
            
            if ([self hasExpired:date] == YES) {
            
                lblAnswerPercent1.hidden = NO;
                lblAnswerPercent2.hidden = NO;
                lblAnswerPercent3.hidden = NO;
                lblAnswerPercent4.hidden = NO;

                
                //NSLog(@"Question has expired");
            }
            else {
                lblAnswerPercent1.hidden = YES;
                lblAnswerPercent2.hidden = YES;
                lblAnswerPercent3.hidden = YES;
                lblAnswerPercent4.hidden = YES;
            }
            

        }        
                
    }

}

- (void)updateVideoRotationForCurrentRotationWithAnimation:(bool)animation
{
    CGSize containerSize  = playerController.view.frame.size;   // Container NOT rotated!
    float  videoWidth     = 0;                     // Keep 16x9 aspect ratio
    float  videoHeight    = 0;

    
    if (IS_IPHONE5 == YES) {
          videoWidth     = 568;                     // Keep 16x9 aspect ratio
          videoHeight    = 320;

    }
    else {
          videoWidth     = 480;                     // Keep 16x9 aspect ratio
          videoHeight    = 320;
    }
    
    
    if( animation )
    {
        [UIView beginAnimations:@"swing" context:nil];
        [UIView setAnimationDuration:0.25];
    }
    
    switch( self.interfaceOrientation )
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            playerController.view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
            
            // This video player is rotated so flip width and height, but the container view
            // isn't rotated!
            [playerController.view setFrame:CGRectMake((containerSize.width-videoHeight)/2,
                                                    (containerSize.height-videoWidth)/2,
                                                    videoHeight,
                                                    videoWidth)];
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            playerController.view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            
            // This video player isn't rotated
            [playerController.view setFrame:CGRectMake((containerSize.width-videoWidth)/2,
                                                    (containerSize.height-videoHeight)/2,
                                                    videoWidth,
                                                    videoHeight)];
            break;
    }
    
    if( animation )
        [UIView commitAnimations];
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateVideoRotationForCurrentRotationWithAnimation:YES];
}

@end
