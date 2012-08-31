//
//  predixerPlayCommentsAllController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@class DataComments;
@class DataCommentsController;
@class DataQuestions;

@interface predixerPlayCommentsAllController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    
    IBOutlet UILabel *lblQuestion;
    IBOutlet UILabel *lblCommentNumber;
    IBOutlet UITableView *tblComments;
    NSString *questionID;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;

- (void)getComments;
- (void)didFinishLoadingComments;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;

@end
