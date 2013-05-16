//
//  predixerViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataSystemUser;
@class DataSystemUserController;
@class LoadingController;
@class predixerAppDelegate;
@class predixerGameMenuViewController;
@class DataAddDeviceToken;

@interface predixerViewController : UIViewController <UITextFieldDelegate> {
    
    DataSystemUser *dataUser;
    DataSystemUserController *dataController;
    LoadingController *loadingController;
    predixerAppDelegate *appDelegate;
    predixerGameMenuViewController *menu;
    DataAddDeviceToken *deviceTokenController;
    
    IBOutlet UIButton *btnFacebook;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UILabel *lblFailed;
    IBOutlet UIImageView *vwNoInternet;
    
    IBOutlet UIImageView *bkdLogin;
    
    NSArray *permissions;
    NSNotificationCenter *nc;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
}

@property (strong, nonatomic) DataSystemUser *dataUser;
@property (strong, nonatomic) DataSystemUserController *dataController;
@property (strong, nonatomic) LoadingController *loadingController;
@property (strong, nonatomic) predixerAppDelegate *appDelegate;
@property (strong, nonatomic) predixerGameMenuViewController *menu;
@property (strong, nonatomic) NSArray *permissions;
@property (strong, nonatomic) DataAddDeviceToken *deviceTokenController;

- (IBAction)pressFacebook:(id)sender;
- (IBAction)pressSubmit:(id)sender;
- (void)performDismiss;
- (void)showLoggedIn;
- (void)didFinishSystemUserLogin;
-(BOOL) isValidEmail:(NSString *)checkString;

@end
