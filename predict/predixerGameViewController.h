//
//  predixerGameViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 3/20/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class DataQuestions;
@class DataQuestionsController;
@class DataQuestionAnswers;
@class DataQuestionAnswersController;
@class LoadingController;
@class predixerViewControllerImageViewer;
@class DataAddImageView;
@class MSLabel;
@class DataUserQuestionAnswerSubmitController;
@class DataUserQuestionAnswerController;
@class DataUserQuestionAnswer;

@interface predixerGameViewController : UIViewController {
    
    DataQuestionsController *dataController;
	DataQuestions *dataQuestions;
    DataQuestionAnswers *questionAnswers;
    DataQuestionAnswersController *answersDataController;
    LoadingController *loadingController;
    predixerViewControllerImageViewer *vwImage;
    DataAddImageView *dataImageView;
    DataUserQuestionAnswerSubmitController *submitAnswer;
    DataUserQuestionAnswerController *userAnswerController;
    DataUserQuestionAnswer *userAnswer;
    
    MSLabel *lblAnswer1;
    UIImageView *imgView1;
    
    MSLabel *lblAnswer2;
    UIImageView *imgView2;
    
    MSLabel *lblAnswer3;
    UIImageView *imgView3;
    
    MSLabel *lblAnswer4;
    UIImageView *imgView4;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
    
    MSLabel *lblQuestion;
    IBOutlet UILabel *lblQuestionPoints;
    IBOutlet UILabel *lblQuestionExpiry;
    IBOutlet UILabel *lblQuestionNumber;
    IBOutlet UILabel *lblQuestionHasExpired;
    IBOutlet UILabel *lblAnswerResult;
    IBOutlet UILabel *lblTapNotice;
    IBOutlet UIImageView *vwBackground;
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnSubmitAnswer;
    IBOutlet UIProgressView *vwProgress;
    
    int arrIndex;
    BOOL isNext;
    BOOL isPrevious;
    BOOL hasFetchedUserAnswer;
    
    IBOutlet UILabel *lblCount;
    
    UIImageView *que1;
    UIImageView *que2;
    UIImageView *que3;
    UIImageView *que4;
    UIImageView *answerBkd1;
    UIImageView *answerBkd2;
    UIImageView *answerBkd3;
    UIImageView *answerBkd4;
    
    UILabel *lblAnswerPercent1;
    UILabel *lblAnswerPercent2;
    UILabel *lblAnswerPercent3;
    UILabel *lblAnswerPercent4;
    
    int selectedAnswerID;
    
    int expireHour;
    NSString *expireDay;
    
    MPMoviePlayerViewController *playerController;
    
}

@property (nonatomic, strong)DataQuestionsController *dataController;
@property (nonatomic, strong)DataQuestions *dataQuestions;
@property (nonatomic, strong)DataQuestionAnswers *questionAnswers;
@property (nonatomic, strong)DataQuestionAnswersController *answersDataController;
@property (strong, nonatomic) LoadingController *loadingController;
@property (nonatomic, strong)predixerViewControllerImageViewer *vwImage;
@property (strong, nonatomic)DataAddImageView *dataImageView;
@property (nonatomic, strong)DataUserQuestionAnswerSubmitController *submitAnswer;
@property (nonatomic, strong)DataUserQuestionAnswerController *userAnswerController;
@property (nonatomic, strong)DataUserQuestionAnswer *userAnswer;

- (void)didFinishLoadingData;
- (void)didFinishLoadingQuestionAnswers;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (void)didBecomeActive:(NSNotification *)notification;
- (void)loadDayQuestion;
- (IBAction)loadNext:(id)sender;
- (IBAction)loadPrevious:(id)sender;
- (IBAction)playVideo:(id)sender;
- (void)makeMyProgressBarMoving;
- (void)removeItems;
- (void)showPicture:(id)sender;
- (void)selectPicture1:(id)sender;
- (void)selectPicture2:(id)sender;
- (void)selectPicture3:(id)sender;
- (void)selectPicture4:(id)sender;
- (void)didCloseImageView;
- (BOOL)hasExpird;
- (BOOL) hasExpired:(NSDate*)myDate;
- (IBAction)submitAnswer:(id)sender;
- (void)didFinishSubmittingUserAnswer;
- (void)didFinishLoadingUserAnswer;
- (void)movieFinishedCallback:(NSNotification*)aNotification;
- (void)dismissPlayer:(id)sender;
- (void)updateVideoRotationForCurrentRotationWithAnimation:(bool)animation;
- (void)getData;
- (void)addObservers;
@end
