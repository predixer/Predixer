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
@class LoadingController;

@interface predixerPointsDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
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
@property (strong, nonatomic)LoadingController *loadingController;

- (void)didFinishLoadingData;
- (void)performDismiss;
- (void)pressBack:(id)sender;

@end
