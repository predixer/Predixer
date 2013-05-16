//
//  predixerAppDelegate.h
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class predixerViewController;
@class DataAddDeviceToken;

@interface predixerAppDelegate : UIResponder <UIApplicationDelegate, FBRequestDelegate,FBDialogDelegate, FBSessionDelegate> {
    
    UINavigationController *navigationController;	
    NSMutableDictionary *userPermissions;
    
    BOOL pushNotifReg;
    BOOL didEnterBackGround;
    int bagdeNum;
    NSMutableData *receivedData;
    
    DataAddDeviceToken *deviceTokenController;
    
    BOOL isDoneAuthorizing;
    BOOL hasPostPermission;
    
    BOOL isCheckFacebookPermission;
    BOOL isAskFacebookPermission;
    BOOL isFinishingPermission;
    BOOL hasUserDetails;
    BOOL isDeauthorize;
    BOOL hasInternetConnection;
    BOOL didGetQuestions;
    NSDate *lastQuestionDate;
    
    
    NSNotificationCenter *nc;
    
    int postNumber;
    int answerNumber;
    
    NSString *appDeviceToken;
    
    BOOL isMoviePlay;
    BOOL isPictureShow;
}

@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) predixerViewController *viewController;
@property (strong, nonatomic) NSMutableDictionary *userPermissions;
@property (strong, nonatomic) DataAddDeviceToken *deviceTokenController;
@property (readwrite)BOOL hasPostPermission;
@property (readwrite)BOOL isCheckFacebookPermission;
@property (readwrite)BOOL isAskFacebookPermission;
@property (readwrite)BOOL isFinishingPermission;
@property (readwrite)int postNumber;
@property (readwrite)int answerNumber;
@property (readwrite)BOOL isDeauthorize;
@property (readwrite)BOOL hasInternetConnection;
@property (readwrite)BOOL didGetQuestions;
@property (strong, nonatomic)NSDate *lastQuestionDate;
@property (strong, nonatomic)NSString *appDeviceToken;
@property (readwrite)BOOL isMoviePlay;
@property (readwrite)BOOL isPictureShow;

- (void)checkPermissions;
- (void)askPermission;
- (void)apiGraphMe;
- (void)logout;
- (void)deauthorize;

@end
