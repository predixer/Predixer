//
//  predixerPlayCommentsOneController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/9/12.
//
//

#import <UIKit/UIKit.h>

@class DataComments;
@class DataCommentsController;
@class DataQuestions;
@class DataUserCommentLike;
@class DataUserCommentLikeController;
@class LoadingController;

@interface predixerPlayCommentsOneController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	
    //comments
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    DataUserCommentLike *dataUserLikes;
    DataUserCommentLikeController *dataUserLikesController;
    LoadingController *loadingController;
    
    NSString *questionID;
    int commentsCount;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;

    int likeIndex;
    BOOL userDidLike;
}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (nonatomic, strong)DataUserCommentLike *dataUserLikes;
@property (nonatomic, strong)DataUserCommentLikeController *dataUserLikesController;
@property (nonatomic, strong)NSString *questionID;
@property (readwrite) int commentsCount;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)getComments;
- (void)didFinishLoadingTopComments;
- (void)likeComment:(id)sender;
- (void)didFinishLikeComment;
- (void)performDismiss;
- (void)didFinishLoadingUserCommentsAllLike;

@end
