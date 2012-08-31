//
//  facebookAPIViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "facebookAPIViewController.h"
#import "FBConnect.h"
#import "predixerAppDelegate.h"
#import "predixerViewController.h"
#import "predixerGameFindFriendsPlayController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "predixerSettingsViewControllerViewController.h"
#import "DataFriendInviteController.h"

@interface facebookAPIViewController ()
- (void)hideMessage;
- (void)showMessage:(NSString *)message;
- (UIImage *)imageForObject:(NSString *)objectID;
- (void)didFinishLoadingFacebookFriends:(NSNotification *)notification;
- (void)addSections;
@end

@implementation facebookAPIViewController

@synthesize savedAPIResult;
@synthesize activityIndicator;
@synthesize messageLabel;
@synthesize messageView;
@synthesize sections;
@synthesize myData;
@synthesize isFiltered;
@synthesize filteredTableData;
@synthesize selectedFriendID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"FACEBOOK";
    
    searchBar.delegate = self;
    sendToMany = NO;
    
    //LEFT NAV BUTTON    
    // Set the custom back button
	UIImage *backButtonNormalImage = [UIImage imageNamed:@"btn_Back.png"];
	UIImage *backButtonHighlightImage = [UIImage imageNamed:@"btn_Back_up.png"];
    
	//create the button and assign the image
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setImage:backButtonNormalImage forState:UIControlStateNormal];
	[backButton setImage:backButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	backButton.frame = CGRectMake(0, 0, backButtonNormalImage.size.width, backButtonNormalImage.size.height);
    
	[backButton addTarget:self action:@selector(pressBack:) forControlEvents:UIControlEventTouchUpInside];
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = customBackBarItem;
    
    //RIGHT NAV BUTTON    
    // Set the custom back button
	UIImage *settingsButtonNormalImage = [UIImage imageNamed:@"btn_Settings.png"];
	UIImage *settingsButtonHighlightImage = [UIImage imageNamed:@"btn_Settings_up.png"];
    
	//create the button and assign the image
	UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[settingsButton setImage:settingsButtonNormalImage forState:UIControlStateNormal];
	[settingsButton setImage:settingsButtonHighlightImage forState:UIControlStateHighlighted];
    
    
	//set the frame of the button to the size of the image (see note below)
	settingsButton.frame = CGRectMake(0, 0, settingsButtonNormalImage.size.width, settingsButtonNormalImage.size.height);
    
	[settingsButton addTarget:self action:@selector(pressSettings:) forControlEvents:UIControlEventTouchUpInside];
    
	//create a UIBarButtonItem with the button as a custom view
	UIBarButtonItem *customSettingsBarItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
	self.navigationItem.rightBarButtonItem = customSettingsBarItem;
    
    
    // Activity Indicator
    int xPosition = (self.view.bounds.size.width / 2.0) - 15.0;
    int yPosition = (self.view.bounds.size.height / 2.0) - 15.0;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 30, 30)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicator];
    
    // Message Label for showing confirmation and status messages
    CGFloat yLabelViewOffset = self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-30;
    messageView = [[UIView alloc]
                   initWithFrame:CGRectMake(0, yLabelViewOffset, self.view.bounds.size.width, 30)];
    messageView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *messageInsetView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.view.bounds.size.width-1, 28)];
    messageInsetView.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                       green:248.0/255.0
                                                        blue:228.0/255.0
                                                       alpha:1];
    messageLabel = [[UILabel alloc]
                    initWithFrame:CGRectMake(4, 1, self.view.bounds.size.width-10, 26)];
    messageLabel.text = @"";
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    messageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                   green:248.0/255.0
                                                    blue:228.0/255.0
                                                   alpha:0.6];
    [messageInsetView addSubview:messageLabel];
    [messageView addSubview:messageInsetView];
    
    messageView.hidden = YES;
    [self.view addSubview:messageView];
    
    tblFacebook.delegate = self;
    tblFacebook.dataSource = self;
    
    [self addSections];
    
    nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self 
           selector:@selector(didFinishLoadingFacebookFriends:) 
               name:@"didFinishLoadingFacebookFriendsWithApp" 
             object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)addSections
{
    self.sections = [[NSMutableDictionary alloc] init];
    
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"A"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"B"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"C"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"D"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"E"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"F"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"G"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"H"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"I"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"J"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"K"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"L"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"M"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"N"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"O"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"P"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Q"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"R"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"S"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"T"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"U"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"V"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"W"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"X"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Y"];
    [self.sections setValue:[[NSMutableArray alloc] init] forKey:@"Z"];
}

- (void)didFinishLoadingFacebookFriends:(NSNotification *)notification
{
    [self addSections];
    
    myData = [[NSMutableArray alloc] init];
    myData = (NSMutableArray*)[notification object];
    NSLog(@"result %d", [myData count]);
    
    
    friendsIDs = [[NSMutableArray alloc] init];
    
    // Loop again and sort the books into their respective keys
    for (NSDictionary *dict in self.myData)
    {
        [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
        [friendsIDs addObject:[dict objectForKey:@"id"]];
        NSLog(@"IDs %@", [dict objectForKey:@"id"]);
    }    
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }    
    
    [tblFacebook reloadData];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Helper Methods
/*
 * This method is called to store the check-in permissions
 * in the app session after the permissions have been updated.
 */
- (void)updateCheckinPermissions {
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate userPermissions] setObject:@"1" forKey:@"user_checkins"];
    [[delegate userPermissions] setObject:@"1" forKey:@"publish_checkins"];
}

/*
 * This method shows the activity indicator and
 * deactivates the table to avoid user input.
 */
- (void)showActivityIndicator {
    if (![activityIndicator isAnimating]) {
        [activityIndicator startAnimating];
    }
}

/*
 * This method hides the activity indicator
 * and enables user interaction once more.
 */
- (void)hideActivityIndicator {
    if ([activityIndicator isAnimating]) {
        [activityIndicator stopAnimating];
        lblFacebook.text = @"";
    }
}

/*
 * Helper method to return the picture endpoint for a given Facebook
 * object. Useful for displaying user, friend, or location pictures.
 */
- (UIImage *)imageForObject:(NSString *)objectID {
    // Get the object image
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    return image;
}

/*
 * This method is used to display API confirmation and
 * error messages to the user.
 */
- (void)showMessage:(NSString *)message {
    CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";
                                                  }
                                              }];
                         }
                     }];
}

/*
 * This method hides the message, only needed if view closed
 * and animation still going on.
 */
- (void)hideMessage {
    messageView.hidden = YES;
    messageLabel.text = @"";
}

/*
 * This method handles any clean up needed if the view
 * is about to disappear.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Hide the activitiy indicator
    [self hideActivityIndicator];
    // Hide the message.
    [self hideMessage];
    myData = nil;
    sections = nil;
}

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

#pragma mark - Facebook API Calls
/*
 * Graph API: Method to get the user's friends.
 */
- (void)apiGraphFriends {
    [self showActivityIndicator];
    // Do not set current API as this is commonly called by other methods
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)apiGraphFriendsWithApp {
    [self showActivityIndicator];
    // Do not set current API as this is commonly called by other methods
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"/me/friends?fields=installed,name" andDelegate:self];
}

/*
 * Graph API: Method to get the user's permissions for this app.
 */
- (void)apiGraphUserPermissions {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPermissions;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}

/*
 * Dialog: Authorization to grant the app check-in permissions.
 */
- (void)apiPromptCheckinPermissions {
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *checkinPermissions = [[NSArray alloc] initWithObjects:@"user_checkins", @"publish_checkins", nil];
    [[delegate facebook] authorize:checkinPermissions];
}

/*
 * --------------------------------------------------------------------------
 * Login and Permissions
 * --------------------------------------------------------------------------
 */

/*
 * iOS SDK method that handles the logout API call and flow.
 */
- (void)apiLogout {
    currentAPICall = kAPILogout;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}

/*
 * Graph API: App unauthorize
 */
- (void)apiGraphUserPermissionsDelete {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPermissionsDelete;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Passing empty (no) parameters unauthorizes the entire app. To revoke individual permissions
    // add a permission parameter with the name of the permission to revoke.
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    [[delegate facebook] requestWithGraphPath:@"me/permissions"
                                    andParams:params
                                andHttpMethod:@"DELETE"
                                  andDelegate:self];
}

/*
 * Dialog: Authorization to grant the app user_likes permission.
 */
- (void)apiPromptExtendedPermissions {
    currentAPICall = kDialogPermissionsExtended;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *extendedPermissions = [[NSArray alloc] initWithObjects:@"user_likes", nil];
    [[delegate facebook] authorize:extendedPermissions];
}

/**
 * --------------------------------------------------------------------------
 * News Feed
 * --------------------------------------------------------------------------
 */

/*
 * Dialog: Feed for the user
 */
- (void)apiDialogFeedUser {
    currentAPICall = kDialogFeedUser;
    SBJSON *jsonWriter = [SBJSON new];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Have Fun with Predixer",@"name",@"http://www.predixer.com/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm using Predixer for iOS app", @"name",
                                   @"Predixer for iOS.", @"caption",
                                   @"I would like to play a Predixer game with you on your iPhone. If you haven't done so, click here to download from the app store. Just use your Facebook account to start playing.", @"description",                                   @"http://www.predixer.com/", @"link",
                                   @"http://www.yellowboat.org/Icon.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
    
}

/*
 * Helper method to first get the user's friends then
 * pick one friend and post on their wall.
 */
- (void)getFriendsCallAPIDialogFeed {
    // Call the friends API first, then set up for targeted Feed Dialog
    currentAPICall = kAPIFriendsForDialogFeed;
    [self apiGraphFriends];
}

/*
 * Dialog: Feed for friend
 */
- (void)apiDialogFeedFriend:(NSString *)friendID {
    currentAPICall = kDialogFeedFriend;
    SBJSON *jsonWriter = [SBJSON new];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Have Fun with Predixer",@"name",@"http://www.predixer.com/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm using Predixer for iOS app", @"name",
                                   @"Predixer for iOS.", @"caption",
                                   @"I would like to play a Predixer game with you on your iPhone. If you haven't done so, click here to download from the app store. Just use your Facebook account to start playing.", @"description",                                   @"http://www.predixer.com/", @"link",
                                   @"http://www.predixer.com/Icon.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
    
}

/*
 * --------------------------------------------------------------------------
 * Requests
 * --------------------------------------------------------------------------
 */

/*
 * Dialog: Requests - send to all.
 */
- (void)apiDialogRequestsSendToMany {
    currentAPICall = kDialogRequestsSendToMany;
    SBJSON *jsonWriter = [SBJSON new];
    NSDictionary *gift = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"5", @"social_karma",
                          @"1", @"badge_of_awesomeness",
                          nil];
    
    NSString *giftStr = [jsonWriter stringWithObject:gift];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Have fun with your friends at Predixer!",  @"message",
                                   @"Check this out", @"notification_text",
                                   giftStr, @"data",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * API: Legacy REST for getting the friends using the app. This is a helper method
 * being used to target app requests in follow-on examples.
 */
- (void)apiRESTGetAppUsers {
    [self showActivityIndicator];
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"friends.getAppUsers", @"method",
                                   nil];
    [[delegate facebook] requestWithParams:params
                               andDelegate:self];
}

/*
 * Dialog: Requests - send to friends not currently using the app.
 */
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs {
    currentAPICall = kDialogRequestsSendToSelect;
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm playing PrediXer for iOS. It's a great app! Try is now!",  @"message",
                                   @"Let's play Predixer!", @"notification_text",
                                   selectIDsStr, @"suggestions",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Dialog: Requests - send to friends not currently using the app.
 */
- (void)apiDialogRequestsSendToNonAppUsers:(NSString *)userID  {
    currentAPICall = kDialogRequestsSendToSelect;

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm playing PrediXer for iOS. It's a great app! Try is now!",  @"message",
                                   @"Let's play Predixer!", @"notification_text",
                                   userID, @"to",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}


/*
 * Dialog: Requests - send to select users, in this case friends
 * that are currently using the app.
 */
- (void)apiDialogRequestsSendToUsers:(NSArray *)selectIDs {
    currentAPICall = kDialogRequestsSendToSelect;
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"It's your turn to visit the Predixer for iOS app.",  @"message",
                                   selectIDsStr, @"suggestions",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Dialog: Requests - send to select users, in this case friends
 * that are currently using the app.
 */
- (void)apiDialogRequestsSendToAppUsers:(NSString *)userID {
    currentAPICall = kDialogRequestsSendToSelect;

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm playing PrediXer game with you on your iPhone. If you haven't done so, click here to download from the app store. Just use your Facebook account to start playing.",  @"message",
                                   @"Let's play Predixer!", @"notification_text",
                                   userID, @"suggestions",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Dialog: Request - send to a targeted friend.
 */
- (void)apiDialogRequestsSendTarget:(NSString *)friendID {
    currentAPICall = kDialogRequestsSendToTarget;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"I would like to play a Predixer game with you on your iPhone.",  @"message",
                                   @"http://www.predixer.com/", @"link",
                                   @"http://www.predixer.com/Icon.png", @"picture",
                                   friendID, @"to",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];
}

/*
 * Helper method to get friends using the app which will in turn
 * send a request to NON users.
 */
- (void)getAppUsersFriendsNotUsing {
    currentAPICall = kAPIGetAppUsersFriendsNotUsing;
    [self apiRESTGetAppUsers];
}

/*
 * Helper method to get friends using the app which will in turn
 * send a request to current app users.
 */
- (void)getAppUsersFriendsUsing {
    currentAPICall = kAPIGetAppUsersFriendsUsing;
    [self apiRESTGetAppUsers];
}

/*
 * Helper method to get the users friends which will in turn
 * pick one to send a request.
 */
- (void)getUserFriendTargetDialogRequest {
    currentAPICall = kAPIFriendsForTargetDialogRequests;
    [self apiGraphFriends];
}

/*
 * API: Enable frictionless in the SDK, retrieve friends enabled for frictionless send
 */
- (void)enableFrictionlessAppRequests {
    predixerAppDelegate *delegate = 
    (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Enable frictionless app requests
    [[delegate facebook] enableFrictionlessRequests];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Enabled Frictionless Requests"
                              message:@"Request actions such as\n"
                              @"Send Request and Send Invite\n"
                              @"now support frictionless behavior."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

/*
 * --------------------------------------------------------------------------
 * Graph API
 * --------------------------------------------------------------------------
 */

/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void)apiGraphMe {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphMe;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

/*
 * Graph API: Get the user's friends
 */
- (void)getUserFriends {
    currentAPICall = kAPIGraphUserFriends;
    [self apiGraphFriends];
}

/*
 * Graph API: Get the user's friends
 */
- (void)getUserFriendsWithApp {
    currentAPICall = kAPIGraphUserFriendsWithApp;
    [self apiGraphFriendsWithApp];
}

/*
 * Graph API: Get the user's check-ins
 */
- (void)apiGraphUserCheckins {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserCheckins;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/checkins" andDelegate:self];
}

/*
 * Helper method to check the user permissions which were stored in the app session
 * when the app was started. After the check decide on whether to prompt for user
 * check-in permissions first or get the check-in information.
 */
- (void)getPermissionsCallUserCheckins {
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate userPermissions] objectForKey:@"user_checkins"]) {
        [self apiGraphUserCheckins];
    } else {
        currentAPICall = kDialogPermissionsCheckinForRecent;
        [self apiPromptCheckinPermissions];
    }
}

/*
 * Graph API: Search query to get nearby location.
 */
- (void)apiGraphSearchPlace:(CLLocation *)location {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphSearchPlace;
    /*
    NSString *centerLocation = [[NSString alloc] initWithFormat:@"%f,%f",
                                location.coordinate.latitude,
                                location.coordinate.longitude];
    */
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",  @"type",
                                   @"centerLocation", @"center",
                                   @"1000",  @"distance",
                                   nil];
    
    [[delegate facebook] requestWithGraphPath:@"search" andParams:params andDelegate:self];
}

/*
 * Method called when user location found. Calls the search API with the most
 * recent location reading.
 */
- (void)processLocationData {
    // Stop updating location information
    //[locationManager stopUpdatingLocation];
    //locationManager.delegate = nil;
    
    // Call the API to get nearby search results
    //[self apiGraphSearchPlace:mostRecentLocation];
}

/*
 * Helper method to kick off GPS to get the user's location.
 */
- (void)getNearby {
    /*
    [self showActivityIndicator];
    // A warning if the user turned off location services.
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
    // Start the location manager
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    // Time out if it takes too long to get a reading.
    [self performSelector:@selector(processLocationData) withObject:nil afterDelay:15.0];
     */
}

/*
 * Helper method to check the user permissions which were stored in the app session
 * when the app was started. After the check decide on whether to prompt for user
 * check-in permissions first or get the user's location which will in turn search
 * for nearby places the user can then check-in to.
 */
- (void)getPermissionsCallNearby {
    /*
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate userPermissions] objectForKey:@"publish_checkins"]) {
        [self getNearby];
    } else {
        currentAPICall = kDialogPermissionsCheckinForPlaces;
        [self apiPromptCheckinPermissions];
    }
     */
}

/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void)apiGraphUserPhotosPost {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserPhotosPost;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Download a sample photo
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/images/devsite/iphone_connect_btn.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img  = [[UIImage alloc] initWithData:data];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   nil];
    
    [[delegate facebook] requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

/*
 * Graph API: Post a video to the user's wall.
 */
- (void)apiGraphUserVideosPost {
    [self showActivityIndicator];
    currentAPICall = kAPIGraphUserVideosPost;
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Download a sample video
    NSURL *url = [NSURL URLWithString:@"https://developers.facebook.com/attachment/sample.mov"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   data, @"video.mov",
                                   @"video/quicktime", @"contentType",
                                   @"Video Test Title", @"title",
                                   @"Video Test Description", @"description",
								   nil];
	[[delegate facebook] requestWithGraphPath:@"me/videos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    [self hideActivityIndicator];
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    switch (currentAPICall) {
        case kAPIGraphUserPermissionsDelete:
        {
            [self showMessage:@"User uninstalled app"];
            predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
            [delegate facebook].accessToken = nil;
            [delegate facebook].expirationDate = nil;
            
            // Notify the root view about the logout.
            predixerViewController *rootViewController = (predixerViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
            [rootViewController fbDidLogout];
            break;
        }
        case kAPIFriendsForDialogFeed:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // Check that the user has friends
            if ([resultData count] > 0) {
                // Pick a random friend to post the feed to
                int randomNumber = arc4random() % [resultData count];
                [self apiDialogFeedFriend: 
                 [[resultData objectAtIndex: randomNumber] objectForKey: @"id"]];
            } else {
                [self showMessage:@"You do not have any friends to post to."];
            }
            break;
        }
        case kAPIGetAppUsersFriendsNotUsing:
        {
            // Save friend results
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithArray:result copyItems:YES];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
            }
            
            // Set up to get friends
            currentAPICall = kAPIFriendsForDialogRequests;
            [self apiGraphFriends];
            break;
        }
        case kAPIGetAppUsersFriendsUsing:
        {
            NSLog(@"kAPIGetAppUsersFriendsUsing");
            NSLog(@"result %@", result);
            

            NSMutableArray *friendsWithApp = [[NSMutableArray alloc] initWithCapacity:1];
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                [friendsWithApp addObjectsFromArray:result];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                [friendsWithApp addObject: [result stringValue]];
            }
            
            
            if ([friendsWithApp count] > 0) {
                [self apiDialogRequestsSendToUsers:friendsWithApp];
                
            } else {
                [self showMessage:@"None of your friends are using the app."];
            }

            
            break;
        }
        case kAPIFriendsForDialogRequests:
        {
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] == 0) {
                [self showMessage:@"You have no friends to select."];
            } else {
                NSMutableArray *friendsWithoutApp = [[NSMutableArray alloc] initWithCapacity:1];
                // Loop through friends and find those who do not have the app
                for (NSDictionary *friendObject in resultData) {
                    BOOL foundFriend = NO;
                    for (NSString *friendWithApp in savedAPIResult) {
                        if ([[friendObject objectForKey:@"id"] isEqualToString:friendWithApp]) {
                            foundFriend = YES;
                            break;
                        }
                    }
                    if (!foundFriend) {
                        [friendsWithoutApp addObject:[friendObject objectForKey:@"id"]];
                    }
                }
                if ([friendsWithoutApp count] > 0) {
                    [self apiDialogRequestsSendToNonUsers:friendsWithoutApp];
                } else {
                    [self showMessage:@"All your friends are using the app."];
                }
            }
            break;
        }
        case kAPIFriendsForTargetDialogRequests:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // got friends?
            if ([resultData count] > 0) { 
                // pick a random one to send a request to
                int randomIndex = arc4random() % [resultData count];	
                NSString* randomFriend = 
                [[resultData objectAtIndex: randomIndex] objectForKey: @"id"];
                [self apiDialogRequestsSendTarget:randomFriend];
            } else {
                [self showMessage: @"You have no friends to select."];
            }
            break;
        }
        case kAPIGraphMe:
        {
             /*
              
            NSString *nameID = [[NSString alloc] initWithFormat: @"%@ (%@)", 
                                [result objectForKey:@"name"], 
                                [result objectForKey:@"id"]];
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id",
                                         nameID, @"name",
                                         [result objectForKey:@"picture"], @"details",
                                         nil], nil];

            
            // Show the basic user information in a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Your Information"
                                                    data:userData
                                                    action:@""];
            [self.navigationController pushViewController:controller animated:YES];
            */
            
            break;
        }
        case kAPIGraphUserFriends:
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count] && i < 5000; i++) {
                    [friends addObject:[resultData objectAtIndex:i]];
                }
                
                // Show the friend information in a new view controller
                [nc postNotificationName:@"didFinishLoadingFacebookFriends" object:friends];
                
            } else {
                [self showMessage:@"You have no friends."];
                lblFacebook.text = @"Add Friends to Facebook first.";
            }

            break;
        }
        case kAPIGraphUserFriendsWithApp:
        {
            NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count] && i < 5000; i++) {
                    [friends addObject:[resultData objectAtIndex:i]];
                }
                
                // Show the friend information in a new view controller
                [nc postNotificationName:@"didFinishLoadingFacebookFriendsWithApp" object:friends];
                
            } else {
                [self showMessage:@"None of your friends are using the app."];
                lblFacebook.text = @"None of your friends are using the app.";
            }
            
            break;
        }
        case kAPIGraphUserCheckins:
        {
            /*
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                NSString *placeID = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"id"];
                NSString *placeName = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"name"];
                NSString *checkinMessage = [[resultData objectAtIndex:i] objectForKey:@"message"] ?
                [[resultData objectAtIndex:i] objectForKey:@"message"] : @"";
                [places addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   placeID,@"id",
                                   placeName,@"name",
                                   checkinMessage,@"details",
                                   nil]];
            }
            // Show the user's recent check-ins a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Recent Check-ins"
                                                    data:places
                                                    action:@"recentcheckins"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            [places release];
             */
            break;
        }
        case kAPIGraphSearchPlace:
        {
            /*
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                [places addObject:[resultData objectAtIndex:i]];
            }
            // Show the places nearby in a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Nearby"
                                                    data:places
                                                    action:@"places"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            [places release];
             */
            
            break;
        }
        case kAPIGraphUserPhotosPost:
        {
            [self showMessage:@"Photo uploaded successfully."];
            break;
        }
        case kAPIGraphUserVideosPost:
        {
            [self showMessage:@"Video uploaded successfully."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [self hideActivityIndicator];
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (currentAPICall) {
        case kDialogFeedUser:
        case kDialogFeedFriend:
        {
            // Successful posts return a post_id
            if ([params valueForKey:@"post_id"]) {
                [self showMessage:@"Published feed successfully."];
                NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
            }
            break;
        }
        case kDialogRequestsSendToMany:
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            NSMutableArray *requestIDs = [[NSMutableArray alloc] init];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"request_ids"]) {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            
            NSLog(@"Request ID(s): %@", requestIDs);
            
            if ([requestIDs count] > 0) {
                [self showMessage:@"Sent request successfully."];
                NSLog(@"Request ID(s): %@", requestIDs);
            }

            DataFriendInviteController *invite = [[DataFriendInviteController alloc] init];
            
            if (sendToMany == YES) {
                
                for (int i = 0; i < [friendsIDs count]; i++) {
                    [invite inviteFriend:[friendsIDs objectAtIndex:i]];
                }
            }
            else
            {
                [invite inviteFriend:selectedFriendID];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

/**
 * Called when the user granted additional permissions.
 */
- (void)userDidGrantPermission {
    // After permissions granted follow up with next API call
    switch (currentAPICall) {
        case kDialogPermissionsCheckinForRecent:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // retrieve recent check-ins
            [self updateCheckinPermissions];
            [self apiGraphUserCheckins];
            break;
        }
        case kDialogPermissionsCheckinForPlaces:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // get nearby locations
            [self updateCheckinPermissions];
            [self getNearby];
            break;
        }
        case kDialogPermissionsExtended:
        {
            // In the sample test for getting user_likes
            // permssions, echo that success.
            [self showMessage:@"Permissions granted."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)userDidNotGrantPermission {
    [self showMessage:@"Extended permissions not granted."];
}

- (void)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSettings:(id)sender
{
    predixerSettingsViewControllerViewController *settings = [[predixerSettingsViewControllerViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - UITableView Datasource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    
    return rowCount;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; 
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:0.92f green:0.97f blue:0.98f alpha:1] : [UIColor clearColor];
    cell.backgroundColor = color;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24.0f)];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bkd_section.png"]];    
    headerImage.frame = CGRectMake(0, 0, tableView.bounds.size.width, 24.0f);
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, headerImage.bounds.size.width, 18)];
    lblHeader.text = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];    
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor clearColor];
    lblHeader.font = [UIFont boldSystemFontOfSize:16];
    
    [headerImage addSubview:lblHeader];
    [headerView addSubview:headerImage];
    
    return headerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.row >= 0)
    {
        NSDictionary *dict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text = [dict objectForKey:@"name"];            
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.text = @"Invite to PrediXer!"; 
        
        
        // The object's image
        //cell.imageView.image = [self imageForObject:[dict objectForKey:@"id"]];
        
        NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",[dict objectForKey:@"id"]];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSDictionary *dict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    NSLog(@"ID %@", [dict objectForKey:@"id"]);
    
    
    selectedFriendID = [dict objectForKey:@"id"];
    
    [self apiDialogRequestsSendTarget:[dict objectForKey:@"id"]];
    
    
    //[self apiDialogRequestsSendToNonAppUsers:[dict objectForKey:@"id"]];
    
    //NSMutableArray *friend = [[NSMutableArray alloc] initWithCapacity:1];
    //[friend addObject: [dict objectForKey:@"id"]];
    //[self apiDialogRequestsSendToUsers:friend];
    

}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    theSearchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar {
    
    theSearchBar.text = @"";
    theSearchBar.showsCancelButton = NO;
    [theSearchBar resignFirstResponder];
    [tblFacebook reloadData];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar 
{
    if(theSearchBar.text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in self.myData)
        {
            NSRange nameRange = [[dict objectForKey:@"name"] rangeOfString:theSearchBar.text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredTableData addObject:dict];
            }            
        }  
        
        [sections removeAllObjects];
        [self addSections];
        
        // Loop again and sort the books into their respective keys
        for (NSDictionary *dict in self.filteredTableData)
        {
            [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
        }    
        
        // Sort each section array
        for (NSString *key in [self.sections allKeys])
        {
            [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        }    
    }
    
    [tblFacebook reloadData];
    
    
    theSearchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (IBAction)inviteAllFriends:(id)sender
{
    sendToMany = YES;
    [self apiDialogRequestsSendToNonUsers:friendsIDs];
}

@end
