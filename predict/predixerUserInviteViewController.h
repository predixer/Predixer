//
//  predixerUserInviteViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <UIKit/UIKit.h>

@class DataFBInviteSignUp;
@class DataFBInviteSignUpController;
@class LoadingController;

@interface predixerUserInviteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tblUserInvites;
    
    DataFBInviteSignUpController *dataController;
	DataFBInviteSignUp *dataUserInvites;
    LoadingController *loadingController;
    
	UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataFBInviteSignUpController *dataController;
@property (nonatomic, strong)DataFBInviteSignUp *dataUserInvites;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)pressBack:(id)sender;
- (void)didFinishLoadingData;
- (void)performDismiss;


@end
