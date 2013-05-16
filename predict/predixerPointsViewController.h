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
@class LoadingController;
@class DataLeaderboard;
@class DataLeaderboardController;

@interface predixerPointsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *items;
    IBOutlet UITableView *tblPoints;
    IBOutlet UILabel *lblWeek;
    
    DataUserPointsController *dataController;
	DataUserPoints *dataUserPoints;
    LoadingController *loadingController;
    DataLeaderboardController *leaderboardDataController;
    DataLeaderboard *dataLeaderboard;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataUserPointsController *dataController;
@property (nonatomic, strong)DataUserPoints *dataUserPoints;
@property (strong, nonatomic)LoadingController *loadingController;
@property (nonatomic, strong)DataLeaderboardController *leaderboardDataController;
@property (nonatomic, strong)DataLeaderboard *dataLeaderboard;

- (void)pressBack:(id)sender;
- (void)didFinishLoadingData;
- (void)performDismiss;
- (void)didFinishLoadingUserLeaderboard;

@end
