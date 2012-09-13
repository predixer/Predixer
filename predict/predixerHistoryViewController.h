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

@interface predixerHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    DataUserAnswers *userAnswers;
    DataUserAnswersController *dataController;
    
    IBOutlet UITableView *tblPredictions;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataUserAnswersController *dataController;
@property (nonatomic, strong)DataUserAnswers *userAnswers;

- (void)didFinishLoadingData;
- (void)performDismiss;
- (void)pressBack:(id)sender;

@end
