//
//  predixerFBFriendsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/29/12.
//
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

typedef enum apiCall {
    kAPIGraphUserFriends,
    kDialogRequestsSendToTarget,
    kDialogRequestsSendToSelect
} apiCall;

@class LoadingController;

@interface predixerFBFriendsViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>  {
    
    int currentAPICall;
    
    LoadingController *loadingController;
    
    NSMutableDictionary *sections;
    NSMutableArray *myData;
    NSMutableArray* filteredTableData;
    NSMutableArray *friendsIDs;
    NSString *selectedFriendID;
    NSString *selectedFriendName;
    
    IBOutlet UILabel *lblFacebook;
    IBOutlet UITableView *tblFacebook;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *btnInviteAll;
    IBOutlet UIButton *btnReloadFriends;
    
    NSNotificationCenter *nc;
    
    bool isFiltered;
    bool sendToMany;
    
    bool isSystemLogin;
    
}
@property(readwrite)bool isSystemLogin;

@property (strong, nonatomic) NSMutableArray *myData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSString *selectedFriendID;
@property (strong, nonatomic) NSString *selectedFriendName;
@property (strong, nonatomic) LoadingController *loadingController;

- (void)systemLogin;
- (void)getFriends;
@end
