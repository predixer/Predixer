//
//  predixerLeaderboardViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 4/3/13.
//
//

#import <UIKit/UIKit.h>

@class DataLeaderboard;
@class DataLeaderboardController;
@class LoadingController;

@interface predixerLeaderboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UILabel *lblWeek;
    IBOutlet UITableView *tblLeaderboard;
    
    DataLeaderboardController *dataController;
    DataLeaderboard *dataLeaderboard;
    LoadingController *loadingController;
    
     NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataLeaderboardController *dataController;
@property (nonatomic, strong)DataLeaderboard *dataLeaderboard;
@property (strong, nonatomic)LoadingController *loadingController;

- (void)didFinishLoadingLeaderboard;
- (void)performDismiss;
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (void)getWeek;
@end
