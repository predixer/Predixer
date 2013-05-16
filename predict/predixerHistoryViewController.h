//
//  predixerHistoryViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@class DataUserAnswers;
@class DataUserAnswersController;
@class LoadingController;

@interface predixerHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    DataUserAnswers *userAnswers;
    DataUserAnswersController *dataController;
    LoadingController *loadingController;
    
    IBOutlet UITableView *tblPredictions;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataUserAnswersController *dataController;
@property (nonatomic, strong)DataUserAnswers *userAnswers;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)didFinishLoadingData;
- (void)performDismiss;
- (void)pressBack:(id)sender;

@end
