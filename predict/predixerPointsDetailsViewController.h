//
//  predixerPointsDetailsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import <UIKit/UIKit.h>

@class DataUserAnswers;
@class DataUserAnswersController;

@interface predixerPointsDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
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
