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
@class DataDrawDate;
@class DataDrawDateController;
@class LoadingController;
@class predixerAppDelegate;
@class predixerLeaderboardViewController;

@interface predixerGameMenuViewController : UIViewController {
    
    IBOutlet UIButton *btnPlayGame;
    IBOutlet UIButton *btnFindFriends;
    IBOutlet UIButton *btnPointsForPrizes;
    IBOutlet UIButton *btnLeagues;
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UILabel *lblDays;
    IBOutlet UILabel *lblHours;
    IBOutlet UILabel *lblMins;
    IBOutlet UILabel *lblSec;
    IBOutlet UILabel *lblDrawDate;
    IBOutlet UIImageView *vwNextDraw;
    
    //Countdown
    NSTimer *timer;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    
    DataFacebookUserController *dataController;
	DataFacebookUser *dataUser;
    DataFacebookUserAdd *addUser;
    DataFacebookUserRecordLogin *updateUserLogin;
    DataDrawDate *dataDrawDate;
    DataDrawDateController *drawDateController;
    LoadingController *loadingController;
    predixerAppDelegate *appDelegate;
    predixerLeaderboardViewController *leaderboard;
    
    NSNotificationCenter *nc;
    facebookAPIViewController *fbApi;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    bool isSystemLogin;
}

@property (strong, nonatomic)facebookAPIViewController *fbApi;
@property (nonatomic, strong)DataFacebookUserController *dataController;
@property (nonatomic, strong)DataFacebookUser *dataUser;
@property (nonatomic, strong)DataFacebookUserAdd *addUser;
@property (nonatomic, strong)DataFacebookUserRecordLogin *updateUserLogin;
@property (nonatomic, strong)DataDrawDate *dataDrawDate;
@property (nonatomic, strong)DataDrawDateController *drawDateController;
@property (strong, nonatomic) LoadingController *loadingController;
@property (nonatomic, strong)predixerAppDelegate *appDelegate;
@property (nonatomic, strong)predixerLeaderboardViewController *leaderboard;
@property (readwrite)bool isSystemLogin;

- (void)didFinishFacebookRequest;
- (void)didFinishLoadingFacebookUser;
- (void)didFinishUpdatingFacebookUserLogin;
- (void)didFinishLoadingData;
- (void)didFinishLoadingDrawDate;
- (void)didSystemLogin;
- (void)performDismiss;
- (IBAction)playGame:(id)sender;
- (IBAction)findFriends:(id)sender;
- (IBAction)howToPlay:(id)sender;
- (IBAction)gotoWinners:(id)sender;
- (IBAction)gotoLeaderboard:(id)sender;
- (void)timerFired;

@end
