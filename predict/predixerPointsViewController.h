//
//  predixerPointsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@class DataUserPoints;
@class DataUserPointsController;

@interface predixerPointsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *items;
    IBOutlet UITableView *tblPoints;
    
    DataUserPointsController *dataController;
	DataUserPoints *dataUserPoints;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataUserPointsController *dataController;
@property (nonatomic, strong)DataUserPoints *dataUserPoints;

- (void)pressBack:(id)sender;
- (void)didFinishLoadingData;
- (void)performDismiss;

@end
