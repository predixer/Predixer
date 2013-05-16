//
//  predixerFBFriendsViewController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/29/12.
//
//

#import "predixerFBFriendsViewController.h"
#import "predixerAppDelegate.h"
#import "DataFriendInviteController.h"
#import "LoadingController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "predixerSettingsViewControllerViewController.h"
#import "Constants.h"

@interface predixerFBFriendsViewController ()
- (void)pressBack:(id)sender;
- (void)pressSettings:(id)sender;
- (IBAction)inviteAllFriends:(id)sender;
- (IBAction)reloadAllFriends:(id)sender;
- (void)didFinishLoadingFacebookFriends:(NSNotification *)notification;
- (void)addSections;
- (void)hideActivityIndicator;
- (NSDictionary *)parseURLParams:(NSString *)query;
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs;
- (void)apiDialogRequestsSendTarget:(NSString *)friendID;
@end

@implementation predixerFBFriendsViewController

@synthesize sections;
@synthesize myData;
@synthesize isFiltered;
@synthesize filteredTableData;
@synthesize selectedFriendID;
@synthesize loadingController;
@synthesize isSystemLogin;
@synthesize selectedFriendName;

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
    

    
    nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(didFinishLoadingFacebookFriends:)
               name:@"didFinishLoadingFacebookFriends"
             object:nil];
    
    
    tblFacebook.delegate = self;
    tblFacebook.dataSource = self;
 
    
    [self getFriends];

}

- (void)getFriends
{
    
    loadingController = [[LoadingController alloc] init];
    loadingController.strLoadingText = @"Loading...";
    [self.view addSubview:loadingController.view];
    
    [self addSections];
    
    if (isSystemLogin == NO) {
        //call facebook graph for friends
        currentAPICall = kAPIGraphUserFriends;
        predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
    }
    else {
        [self systemLogin];
    }
}

- (void)systemLogin
{
    [self hideActivityIndicator];
    
    btnInviteAll.hidden = YES;
    btnReloadFriends.hidden = YES;
    lblFacebook.text = @"Sorry! You have not logged on using Facebook.";
    lblFacebook.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];

}


- (void)addSections
{
    if (sections != nil) {
        sections = nil;
    }
    
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
    myData = [(NSMutableArray*)[notification object] copy];
    //NSLog(@"my data count  %d", [myData count]);
    
    
    friendsIDs = [[NSMutableArray alloc] init];
    
    // Loop again and sort the items into their respective keys
    for (NSDictionary *dict in self.myData)
    {
        [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
        [friendsIDs addObject:[dict objectForKey:@"id"]];
        //NSLog(@"Facebook IDs %@", [dict objectForKey:@"id"]);
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

/*
 * This method handles any clean up needed if the view
 * is about to disappear.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //myData = nil;
    //sections = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didFinishLoadingFacebookFriends" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    lblHeader.font = [UIFont fontWithName: @"Verdana Bold" size:16];
    
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
        
        //NSLog(@"sections count %d", [sections count]);
        
        cell.textLabel.text = [dict objectForKey:@"name"];
        cell.textLabel.font = [UIFont fontWithName: @"Verdana" size:14];
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

    
    NSDictionary *dict = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    //NSLog(@"ID %@", [dict objectForKey:@"id"]);
    
    
    selectedFriendID = [dict objectForKey:@"id"];
    selectedFriendName = [dict objectForKey:@"name"];
    
    [self apiDialogRequestsSendTarget:[dict objectForKey:@"id"]];
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
        isFiltered = false;
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
        
        // Loop again and sort the items into their respective keys
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


- (IBAction)reloadAllFriends:(id)sender
{
    isFiltered = false;
    
    [sections removeAllObjects];
    [self addSections];
    
    // Loop again and sort the items into their respective keys
    for (NSDictionary *dict in self.myData)
    {
        [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
        [friendsIDs addObject:[dict objectForKey:@"id"]];
        //NSLog(@"Facebook IDs %@", [dict objectForKey:@"id"]);
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
    
    [tblFacebook reloadData];
}

/*
 * Dialog: Request - send to a targeted friend.
 */
- (void)apiDialogRequestsSendTarget:(NSString *)friendID {
    //NSLog(@"friendID %@", friendID);
    
    currentAPICall = kDialogRequestsSendToTarget;
    
NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"179699488824039", @"app_id",
                                   @"I would like to invite you to play PrediXer.", @"name",
                                   @"PrediXer is a fun and simple game! Users play by predicting the outcomes of real life events and earn points for a chance to win cash prizes!", @"description",
                                   @"https://www.facebook.com/Predixer/", @"link",
                                   @"http://www.predixer.com/XLogo_small.png", @"picture",
                                   @" ", @"caption",
                                   @"I would like to invite you to play PrediXer.", @"message",
                                   friendID, @"to",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
                    andDelegate:self];

}

/*
 * Dialog: Requests - send to friends not currently using the app.
 */
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs {
    currentAPICall = kDialogRequestsSendToSelect;
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    //NSLog(@"selectIDsStr %@", selectIDsStr);
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"179699488824039", @"app_id",
                                   @"I would like to invite you to play PrediXer.", @"name",
                                   @"PrediXer is a fun and simple game! Users play by predicting the outcomes of real life events and earn points for a chance to win cash prizes!", @"description",
                                   @"https://www.facebook.com/Predixer/", @"link",
                                   @"http://www.predixer.com/XLogo_small.png", @"picture",
                                   @" ", @"caption",
                                   @"I would like to invite you to play PrediXer.", @"message",
                                   selectIDsStr, @"suggestion",
                                   nil];
    
    predixerAppDelegate *delegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"apprequests"
                      andParams:params
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
                lblFacebook.text = @"You have no friends. Add Friends to Facebook first.";
                lblFacebook.hidden = NO;
            }
            
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
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    
    lblFacebook.text = @"Sorry! Either you have no friends or you are not using Facebook.";
    lblFacebook.hidden = NO;
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */


- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        //NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (currentAPICall) {
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return the id of the request
            // and ids of recipients.
            NSMutableArray *recipientIDs = [[NSMutableArray alloc] init];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"to["]) {
                    
                    
                    //NSLog(@"Request ID: %@", [params objectForKey:@"request"]);
                    //NSLog(@"Request ID: %@", [params objectForKey:paramKey]);
                    
                    [recipientIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([params objectForKey:@"request"]){
                //NSLog(@"Request ID: %@", [params objectForKey:@"request"]);
            }
            if ([recipientIDs count] > 0) {
                //NSLog(@"Sent request successfully. Recipient ID(s): %@", recipientIDs);
            }
            
            DataFriendInviteController *invite = [[DataFriendInviteController alloc] init];
            
            if (sendToMany == YES) {
                
                /*
                for (int i = 0; i < [friendsIDs count]; i++) {
                    [invite inviteFriend:[friendsIDs objectAtIndex:i]];
                }*/
                
                for (NSDictionary *dict in self.myData)
                {
                    [[self.sections objectForKey:[[dict objectForKey:@"name"] substringToIndex:1]] addObject:dict];
                    
                    
                    //NSLog(@" id/name %@ %@", [dict objectForKey:@"id"], [dict objectForKey:@"name"]);
                    
                    //[invite inviteFriend:[dict objectForKey:@"id"] name:[dict objectForKey:@"name"]];
                    
                    [invite inviteFacebookFriend:[dict objectForKey:@"id"] name:[dict objectForKey:@"name"]];
                }

            }
            else
            {
                //NSLog(@" id/name %@ %@", selectedFriendID, selectedFriendName);
                //[invite inviteFriend:selectedFriendID name:selectedFriendName];
                
                [invite inviteFacebookFriend:selectedFriendID name:selectedFriendName];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    //NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    
    lblFacebook.text = @"Sorry! Either you have no friends or you are not using Facebook.";
    lblFacebook.hidden = NO;
}

- (void)hideActivityIndicator {
    if (loadingController.view.hidden == NO) {
        loadingController.view.hidden = YES;
    }
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
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

@end
