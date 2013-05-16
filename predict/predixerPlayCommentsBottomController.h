//
//  predixerPlayCommentsBottomController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/8/12.
//
//

#import <UIKit/UIKit.h>

@class DataComments;
@class DataCommentsController;
@class DataQuestions;

@interface predixerPlayCommentsBottomController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	
    //comments
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    
    NSString *questionID;
    int commentsCount;
    NSMutableArray *arrLineHeight;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
    
    int pageNumber;
    int likeIndex;
    IBOutlet UIButton *btnLoadMore;
    BOOL isLoadMore;
    BOOL isAddNewComment;

}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (nonatomic, strong)NSString *questionID;
@property (readwrite) int commentsCount;
@property (readwrite) BOOL isAddNewComment;
@property (readwrite) BOOL isLoadMore;

- (void)getComments;
- (void)didFinishLoadingTopComments;
- (void)likeComment:(id)sender;
- (void)didFinishLikeComment;
- (void)performDismiss;
- (IBAction)loadMore:(id)sender;
- (void)didFinishLoadingComments;

@end
