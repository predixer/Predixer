//
//  predixerHistoryDetailsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 4/2/13.
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
@class DataUserQuestionAnswerController;
@class DataUserQuestionAnswer;

@interface predixerHistoryDetailsViewController : UIViewController {
    
    DataQuestionsController *dataController;
	DataQuestions *dataQuestions;
    DataQuestionAnswers *questionAnswers;
    DataQuestionAnswersController *answersDataController;
    LoadingController *loadingController;
    predixerViewControllerImageViewer *vwImage;
    DataAddImageView *dataImageView;
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
    IBOutlet UILabel *lblQuestionHasExpired;
    IBOutlet UILabel *lblAnswerResult;
    IBOutlet UILabel *lblTapNotice;
    IBOutlet UIImageView *vwBackground;
    

    IBOutlet UIButton *btnPlay;
    IBOutlet UIProgressView *vwProgress;
    
    int arrIndex;
    
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
    NSString *aQuestionID;
    
    MPMoviePlayerViewController *playerController;
    
}

@property (nonatomic, strong)DataQuestionsController *dataController;
@property (nonatomic, strong)DataQuestions *dataQuestions;
@property (nonatomic, strong)DataQuestionAnswers *questionAnswers;
@property (nonatomic, strong)DataQuestionAnswersController *answersDataController;
@property (nonatomic, strong)LoadingController *loadingController;
@property (nonatomic, strong)predixerViewControllerImageViewer *vwImage;
@property (nonatomic, strong)DataAddImageView *dataImageView;
@property (nonatomic, strong)DataUserQuestionAnswerController *userAnswerController;
@property (nonatomic, strong)DataUserQuestionAnswer *userAnswer;
@property (nonatomic, strong)NSString *aQuestionID;

- (id)initWithQuestion:(NSString *)questionID;
- (void)didFinishLoadingQuestion;
- (void)didFinishLoadingQuestionAnswers;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)didBecomeActive:(NSNotification *)notification;
- (void)loadDayQuestion;
- (IBAction)playVideo:(id)sender;
- (void)removeItems;
- (void)showPicture:(id)sender;
- (void)selectPicture1:(id)sender;
- (void)selectPicture2:(id)sender;
- (void)selectPicture3:(id)sender;
- (void)selectPicture4:(id)sender;
- (void)didCloseImageView;
- (BOOL)hasExpired;
- (void)didFinishLoadingUserAnswer;
- (void)movieFinishedCallback:(NSNotification*)aNotification;
- (void)dismissPlayer:(id)sender;
- (void)updateVideoRotationForCurrentRotationWithAnimation:(bool)animation;


@end
