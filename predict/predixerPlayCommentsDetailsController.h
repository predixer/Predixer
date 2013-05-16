//
//  predixerPlayCommentsDetailsController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/24/12.
//
//

#import <UIKit/UIKit.h>

@class DataQuestions;
@class DataComments;
@class DataCommentsController;

@interface predixerPlayCommentsDetailsController : UIViewController {
    
    DataQuestions *dataQuestion;
    DataComments *dataComment;
    DataCommentsController *commentsDataController;
    
    IBOutlet UILabel *lblQuestion;
    IBOutlet UILabel *lblCommentUser;
    IBOutlet UILabel *lblCommentDate;
    IBOutlet UILabel *lblCommentLikes;
    IBOutlet UILabel *lblCommentNumber;
    
    
    IBOutlet UILabel *lblBy;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblComment;
    IBOutlet UILabel *lblLikes;
    
    IBOutlet UITextView *txtComment;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnMoreComments;
    int commentCount;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataComments *dataComment;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (readwrite)int commentCount;

- (id)initWithQuestion:(int)questionID comment:(DataComments *)comment count:(int)count;
- (IBAction)likeComment:(id)sender;
- (IBAction)showMoreComment:(id)sender;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (void)didFinishLikeComment;
- (void)didFinishGettingUserLikeComment;

@end
