//
//  predixerAppDelegate.m
//  predict
//
//  Created by Joel R Ballesteros on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "predixerAppDelegate.h"
#import "predixerViewController.h"
#import "DataLoad.h"
#import "DataQuestionsController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataAddDeviceToken.h"
#import "CheckConnection.h"


// Your Facebook APP Id
static NSString* kAppId = @"179699488824039";

@implementation predixerAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController;
@synthesize userPermissions;
@synthesize deviceTokenController;
@synthesize facebook;
@synthesize hasPostPermission;
@synthesize isCheckFacebookPermission;
@synthesize isAskFacebookPermission;
@synthesize isFinishingPermission;
@synthesize postNumber;
@synthesize isDeauthorize;
@synthesize didGetQuestions;
@synthesize lastQuestionDate;
@synthesize hasInternetConnection;
@synthesize answerNumber;
@synthesize appDeviceToken;
@synthesize isMoviePlay;
@synthesize isPictureShow;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [DataLoad copyDatabaseIfNeeded];
    nc = [NSNotificationCenter defaultCenter];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[predixerViewController alloc] initWithNibName:@"predixerViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];

	[self.navigationController setNavigationBarHidden:YES];
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    hasInternetConnection = [CheckConnection hasConnectivity];
    //NSLog(@"hasInternetConnection %d", hasInternetConnection);
    
    if (hasInternetConnection == YES) {
        // Initialize Facebook
        facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
        //[facebook enableFrictionlessRequests];
        
        didGetQuestions = NO;
        DataQuestionsController *question = [[DataQuestionsController alloc] init];
        [question getQuestionsToday];
        
        //NSLog(@"pushNotifReg ? %d",pushNotifReg);
        //NSLog(@"Registering for push notifications...");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    
    if (deviceTokenController == nil) {
        deviceTokenController = [[DataAddDeviceToken alloc] init];
    }
    
        
    isAskFacebookPermission = NO;
    isCheckFacebookPermission = NO;
    postNumber = 1;
    answerNumber = 1;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; //iOS4
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    

    return YES;
    
}

- (void)checkPermissions
{
    isCheckFacebookPermission = YES;
    isAskFacebookPermission = NO;
    
    [facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}

- (void)askPermission
{
    isAskFacebookPermission = YES;
    isCheckFacebookPermission = NO;
    
    NSArray *extendedPermissions = [[NSArray alloc] initWithObjects:@"publish_stream",@"publish_actions", nil];
    [facebook authorize:extendedPermissions];
}

- (void)apiGraphMe {
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)deauthorize
{
    //https://graph.facebook.com/me/permissions/email
    
    isDeauthorize = YES;    
    isCheckFacebookPermission = NO;
    isAskFacebookPermission = NO;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"publish_stream" forKey:@"permission"];
    [params setObject:@"delete" forKey:@"method"];
    
    [facebook requestWithGraphPath:@"me/permissions" andParams:params andDelegate:self];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    hasInternetConnection = [CheckConnection hasConnectivity];
    //NSLog(@"hasInternetConnection %d", hasInternetConnection);
    
    if (hasInternetConnection == YES) {
        
        DataQuestionsController *question = [[DataQuestionsController alloc] init];
        [question getQuestionsToday];
        
        /*
        if([lastQuestionDate compare:[NSDate date]] == NSOrderedSame)
        {
            // if same date, don't check anymore
        }
        else {
            
            if (didGetQuestions == NO) {
                DataQuestionsController *question = [[DataQuestionsController alloc] init];
                [question getQuestionsToday];
            }
        }*/
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [[self facebook] extendAccessTokenIfNeeded];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}



#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
   [self storeAuthData:[facebook accessToken] expiresAt:[facebook expirationDate]];

    if (isAskFacebookPermission == NO) {
        
        [self apiGraphMe];
        [self.viewController showLoggedIn];
    }
    
    if (isAskFacebookPermission == YES) {
        
        isFinishingPermission = YES;
        
        [self checkPermissions];        
    }
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    //NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    //[pendingApiCallsController userDidNotGrantPermission];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    //pendingApiCallsController = nil;
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    isDoneAuthorizing = NO;
    hasPostPermission = NO;
    isCheckFacebookPermission = NO;
    isAskFacebookPermission = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)logout
{
    hasUserDetails = NO;
    [facebook logout:self];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    /*
     UIAlertView *alertView = [[UIAlertView alloc]
     initWithTitle:@"Auth Exception"
     message:@"Your session has expired."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil,
     nil];
     [alertView show];
     */
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response %@", response);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    //NSLog(@"Facebook JSON Response: %@", result);
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    
    if (isCheckFacebookPermission == YES && isAskFacebookPermission == NO && isDeauthorize == NO) {        
        
        NSArray *arrayResult = [result objectForKey:@"data"];
        
        for (int i = 0; i < [arrayResult count]; i++) {
            
            NSDictionary *aData = [arrayResult objectAtIndex:i];
            
            
            NSString *publish_stream = [NSString stringWithFormat:@"%@", [aData objectForKey:@"publish_stream"]];
            
            //NSLog(@"%@", publish_stream);
            
            if ([publish_stream isEqualToString:@"(null)"]) {
                hasPostPermission = NO;
            }
            else {
                hasPostPermission = YES;
            }
        }
        
        if (isFinishingPermission == YES) {
            [nc postNotificationName:@"didFinishFacebookAuthorization" object:nil];
        }
        
    }
    else if (isDeauthorize == YES && isCheckFacebookPermission == NO && isAskFacebookPermission == NO) {
        
        NSDictionary *responseInfo = result;
        //NSLog(@"%@", [responseInfo objectForKey:@"result"]);
        
        if ([[responseInfo objectForKey:@"result"] boolValue] == YES) {
            hasPostPermission = NO;
        }
        
        isDeauthorize = NO;
    }
    else if (isCheckFacebookPermission == NO && isAskFacebookPermission == NO && isDeauthorize == NO) {
        
        isCheckFacebookPermission = NO;
        isAskFacebookPermission = NO;
        
        
        NSDictionary *responseInfo = result;
        
        //NSLog(@"fb response %@",response);
        
        if (responseInfo.count > 0)
        {
            // Check and retrieve authorization information
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"id"] forKey:@"fbId"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"email"] forKey:@"fbEmail"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"name"] forKey:@"fbName"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"first_name"] forKey:@"fbFirstName"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"last_name"] forKey:@"fbLastName"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"username"] forKey:@"fbUsername"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseInfo objectForKey:@"gender"] forKey:@"fbGender"];
            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"isFBUser"];
            
            
            NSDictionary *aLocation = [responseInfo objectForKey:@"location"];
            
            
            NSString *str = [aLocation objectForKey:@"name"];
            
            str = [str stringByReplacingOccurrencesOfString:@"\u00f1"
                                                 withString:@"ñ"];
            
            //NSLog(@"arrlocation item: %@", str);
            
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fbLocation"];
            
            [[NSUserDefaults standardUserDefaults] setValue:facebook.accessToken forKey:@"FBAccessTokenKey"];
            [[NSUserDefaults standardUserDefaults] setValue:facebook.expirationDate forKey:@"FBExpirationDateKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if (appDeviceToken != nil) {
                //save token to database
                [deviceTokenController addToken:appDeviceToken];
            }
        }
        
        [self checkPermissions];
        
        if (hasUserDetails == NO) {
            [nc postNotificationName:@"didFinishFacebookLoginRequest" object:nil];
            hasUserDetails = YES;
        }
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    //NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    //NSLog(@"Err code: %d", [error code]);
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
    
    
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    //NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
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



#pragma mark -- push notification--


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if (pushNotifReg) return;
    
    NSString *strDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    //NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken %@",strDeviceToken);
    
    NSString *strToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    //NSLog(@"strToken %@", strToken);
    
    appDeviceToken = [NSString stringWithFormat:@"%@", strToken];
    
    //save token to database
    [deviceTokenController addToken:strToken];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    //NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    //NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //NSLog(@"didReceiveRemoteNotification");
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    
    //NSString *sound = [apsInfo objectForKey:@"sound"];
    //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //NSString *badge = [apsInfo objectForKey:@"badge"];
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    bagdeNum = [[apsInfo objectForKey:@"badge"] integerValue];
    //NSLog(@"bagdeNum  %d", bagdeNum);
    //    }
    if (![alert isEqualToString:@""]) {
        
        if (!didEnterBackGround) {
            [self alertNotice:@"PrediXer Alert" withMSG:[NSString stringWithFormat:@"%@",alert] cancleButtonTitle:@"OK" otherButtonTitle:@""];
        }
        
    }
    
    
    
	//[self addMessageFromRemoteNotification:userInfo updateUI:YES];
    
    
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	return;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    //NSLog(@"Connected: %@", data);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //NSLog(@"%@", error);
    
    // receivedData is declared as a method instance elsewhere
    
	receivedData = nil;
    
    // inform the user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
													message:@"There was an error while connecting to the server."
                          "Either the service is down or you don't have an internet connection."
												   delegate:nil
										  cancelButtonTitle:@"Continue"
										  otherButtonTitles:nil];
	[alert show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
	
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	//NSLog(@"Login JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    /*
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }*/
    
    NSString *resStr =[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"response"]];
    if ([resStr isEqualToString:@"200"]) {
        pushNotifReg = YES;
    }
    else  if ([resStr isEqualToString:@"400"]) {
        //        [self alertNotice:@"" withMSG:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"message"]] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
        pushNotifReg = YES;
    }
    
    receivedData = nil;
}

-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle{
    
    //NSLog(@"alert notice");
    UIAlertView *alert;
    if([otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title1 = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *alertTitle = [alertView title];
    if ([alertTitle isEqual:@"PrediXer Alert"]) {
        if ([title1 isEqualToString:@"OK"]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }    
}

/*
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (isMoviePlay || isPictureShow) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}*/

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    if(self.isMoviePlay == YES) //shouldRotate is my flag
    {
        //self.isMoviePlay = NO;
        return (UIInterfaceOrientationMaskAll);
    }
    else {
        return (UIInterfaceOrientationMaskPortrait);
    }
}


@end
