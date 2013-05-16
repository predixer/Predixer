//
//  predixerGameFindFriendsViewController.h
//  predict
//
//  Created by Joel R Ballesteros on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class predixerGameFindFriendsPlayController;
@class predixerGameFindFriendsInviteController;

@interface predixerGameFindFriendsViewController : UIViewController
{
    predixerGameFindFriendsPlayController *friendsPlay;
    predixerGameFindFriendsInviteController *friendsInvite;
    
    NSMutableArray *friendsData;
    NSMutableArray *friendsWithAppData;
    NSMutableArray *friendsWithNoAppData;
    
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnInvite;
    IBOutlet UIButton *btnShare;
}

@property (strong, nonatomic) predixerGameFindFriendsPlayController *friendsPlay;
@property (strong, nonatomic) predixerGameFindFriendsInviteController *friendsInvite;
@property (strong, nonatomic) NSMutableArray *friendsData;
@property (strong, nonatomic) NSMutableArray *friendsWithAppData;
@property (strong, nonatomic) NSMutableArray *friendsWithNoAppData;

- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (IBAction)pressPlay:(id)sender;
- (IBAction)pressInvite:(id)sender;
- (IBAction)pressShare:(id)sender;

@end
