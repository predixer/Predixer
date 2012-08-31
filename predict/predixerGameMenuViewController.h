//
//  predixerGameMenuViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class facebookAPIViewController;
@class DataFacebookUser;
@class DataFacebookUserController;
@class DataFacebookUserAdd;
@class DataFacebookUserRecordLogin;

@interface predixerGameMenuViewController : UIViewController {
    
    IBOutlet UIButton *btnPlayGame;
    IBOutlet UIButton *btnFindFriends;
    IBOutlet UIButton *btnPointsForPrizes;
    IBOutlet UIButton *btnLeagues;
    IBOutlet UIScrollView *scroll;
    
    
    DataFacebookUserController *dataController;
	DataFacebookUser *dataUser;
    DataFacebookUserAdd *addUser;
    DataFacebookUserRecordLogin *updateUserLogin;
    
    NSNotificationCenter *nc;
    facebookAPIViewController *fbApi;
    
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
}

@property (strong, nonatomic)facebookAPIViewController *fbApi;
@property (nonatomic, strong)DataFacebookUserController *dataController;
@property (nonatomic, strong)DataFacebookUser *dataUser;
@property (nonatomic, strong)DataFacebookUserAdd *addUser;
@property (nonatomic, strong)DataFacebookUserRecordLogin *updateUserLogin;

- (void)didFinishFacebookRequest;
- (void)didFinishLoadingFacebookUser;
- (void)didFinishUpdatingFacebookUserLogin;
- (void)didFinishLoadingData;
- (void)performDismiss;
- (IBAction)playGame:(id)sender;
- (IBAction)findFriends:(id)sender;
- (IBAction)pointsForPrizes:(id)sender;
- (IBAction)gotoLeagues:(id)sender;

@end
