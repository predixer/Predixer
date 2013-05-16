//
//  predixerAccountViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import <UIKit/UIKit.h>

@class DataFacebookUser;
@class DataFacebookUserController;
@class LoadingController;

@interface predixerAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tblAccount;
    IBOutlet UIButton *btnLogout;
    IBOutlet UIButton *btnBack;
    
    DataFacebookUser *fbUser;
    DataFacebookUserController *dataController;
    LoadingController *loadingController;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataFacebookUserController *dataController;
@property (nonatomic, strong)DataFacebookUser *fbUser;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)didFinishLoadingData;
- (void)performDismiss;
- (IBAction)logout:(id)sender;
- (void)pressBack:(id)sender;

@end
