//
//  predixerTopCommentsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <UIKit/UIKit.h>

@class DataTopComments;
@class DataTopCommentsController;
@class LoadingController;

@interface predixerTopCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tblTopComments;
    
    DataTopCommentsController *dataController;
	DataTopComments *dataTopComments;
    LoadingController *loadingController;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataTopCommentsController *dataController;
@property (nonatomic, strong)DataTopComments *dataTopComments;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)pressBack:(id)sender;
- (void)didFinishLoadingData;
- (void)performDismiss;

@end
