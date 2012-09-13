//
//  predixerPlayNewsDetailsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@class DataQuestions;
@class DataQuestionAnswers;
@class DataQuestionAnswersController;
@class DataUserQuestionAnswerController;
@class DataUserQuestionAnswer;
@class DataUserQuestionAnswerSubmitController;
@class DataCommentAddController;
@class predixerPlayCommentsController;

@interface predixerPlayNewsDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RadioButtonDelegate, UITextViewDelegate> {
    
    DataQuestions *dataQuestions;
    DataQuestionAnswers *questionAnswers;
    DataQuestionAnswersController *answersDataController;
    DataUserQuestionAnswerController *userAnswerController;
    DataUserQuestionAnswer *userAnswer;
    DataUserQuestionAnswerSubmitController *submitAnswer;
    DataCommentAddController *addCommentsController;
    predixerPlayCommentsController *userCommentsDataController;
    
    IBOutlet UITableView *tblListAnswer;
    IBOutlet UITableView *tblListComments;
    IBOutlet UILabel *lblQuestion;
    IBOutlet UILabel *lblAnswerResult;
    IBOutlet UILabel *lblCharCount;
    IBOutlet UILabel *lblCommentsCount;
    IBOutlet UILabel *questionPoints;
    IBOutlet UILabel *questionDate;
    IBOutlet UITextView *txtComment;
    IBOutlet UIButton *btnSubmitAnswer;
    IBOutlet UIButton *btnSubmitComment;
    IBOutlet UIButton *btnViewComments;
    IBOutlet UIImageView *lineArrow;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
    
    int selectedAnswerID;
    
    BOOL checkedAnswer;
}

@property (nonatomic, strong)DataQuestionAnswersController *answersDataController;
@property (nonatomic, strong)DataQuestionAnswers *questionAnswers;
@property (nonatomic, strong)DataQuestions *dataQuestions;
@property (nonatomic, strong)DataUserQuestionAnswerController *userAnswerController;
@property (nonatomic, strong)DataUserQuestionAnswer *userAnswer;
@property (nonatomic, strong)DataUserQuestionAnswerSubmitController *submitAnswer;
@property (nonatomic, strong)predixerPlayCommentsController *userCommentsDataController;
@property (nonatomic, strong)DataCommentAddController *addCommentsController;
@property (readwrite)int selectedAnswerID;
@property (nonatomic, strong)IBOutlet UITableView *tblListAnswer;
@property (nonatomic, strong)IBOutlet UITableView *tblListComments;

- (id)initWithQuestion:(DataQuestions *)question;
- (void)didFinishLoadingQuestionAnswers;
- (void)didFinishLoadingData;
- (void)didFinishSubmittingUserAnswer;
- (void)didFinishLoadingUserAnswer;
- (void)didFinishAddingUserComment;
- (void)didFinishLoadingCommentsToTable;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (IBAction)submitAnswer:(id)sender;
- (IBAction)submitComment:(id)sender;
- (IBAction)showMoreComment:(id)sender;

@end
