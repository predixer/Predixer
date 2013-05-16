//
//  predixerPlayCommentsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/5/12.
//
//

#import <UIKit/UIKit.h>

@class DataComments;
@class DataCommentsController;
@class DataQuestions;
@class DataUserCommentLike;
@class DataUserCommentLikeController;
@class LoadingController;

@interface predixerPlayCommentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    DataUserCommentLike *dataUserLikes;
    DataUserCommentLikeController *dataUserLikesController;
    LoadingController *loadingController;
    
    IBOutlet UILabel *lblCommentNumber;
    IBOutlet UILabel *questionPoints;
    IBOutlet UILabel *questionDate;
    IBOutlet UITableView *tblComments;
    IBOutlet UIButton *btnMore;
    
    NSMutableArray *arrLineHeight;
    NSString *questionID;
        
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
    
    NSMutableArray *arrLikes;
    
    int pageNumber;
    int likeIndex;
    BOOL isLoadMore;
    BOOL userDidLike;
}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (nonatomic, strong)DataUserCommentLike *dataUserLikes;
@property (nonatomic, strong)DataUserCommentLikeController *dataUserLikesController;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)getComments;
- (void)didFinishLoadingComments;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (void)likeComment:(id)sender;
- (void)didFinishLikeComment;
- (IBAction)loadMore:(id)sender;
- (void)didFinishLoadingUserCommentsAllLike;

@end
