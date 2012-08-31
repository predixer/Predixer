//
//  facebookAPIViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <CoreLocation/CoreLocation.h>

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kAPIGraphUserFriendsWithApp,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

@interface facebookAPIViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    int currentAPICall;
    
    NSMutableArray *savedAPIResult;
    NSMutableDictionary *sections;  
    NSMutableArray *myData;
    NSMutableArray* filteredTableData;
    NSMutableArray *friendsIDs;
    NSString *selectedFriendID;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *messageLabel;
    UIView *messageView;
    
    IBOutlet UILabel *lblFacebook;
    IBOutlet UITableView *tblFacebook;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *btnInviteAll;
    
    NSNotificationCenter *nc;
    
    bool isFiltered;
    bool sendToMany;
}

@property (strong, nonatomic) NSMutableArray *savedAPIResult;
@property (strong, nonatomic) NSMutableArray *myData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (strong, nonatomic) NSMutableDictionary *sections;  
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *messageView;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSString *selectedFriendID;

- (void)userDidGrantPermission;

- (void)userDidNotGrantPermission;

- (void)getUserFriends;
- (void)getAppUsersFriendsNotUsing;
- (void)getAppUsersFriendsUsing;
- (void)getUserFriendsWithApp;
- (void)apiLogout;
- (void)apiDialogRequestsSendTarget:(NSString *)friendID;
- (void)apiDialogFeedUser;

- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (IBAction)inviteAllFriends:(id)sender;

@end
