//
//  DataFriendInviteController.m
//  predict
//
//  Created by Joel R Ballesteros on 8/26/12.
//
//

#import "DataFriendInviteController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "Constants.h"

@implementation DataFriendInviteController

- (id)init {
	if ((self = [super init])) {
        
        receivedData = [[NSMutableData alloc] init];
        nc = [NSNotificationCenter defaultCenter];

	}
	
	return self;
}

#pragma mark Fetch from the internet
- (void)inviteFriend:(NSString *)inviteeFB name:(NSString *)inviteeName
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@InviteFacebookFriend?fb=%@&fr=%@&nm=%@", WebServiceSource, facebookUserID, inviteeFB, inviteeName];
    
    //NSLog(@"urlString %@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (theConnection)
	{
        //NSLog(@"Connection created successfully");
		receivedData = nil;
		receivedData = [NSMutableData data];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else
	{
        /*
		//Alert user for connection null response
		UIAlertView *baseAlert = [[UIAlertView alloc]
								  initWithTitle:@"Cannot Connect!" message:@"Either the service is down or you don't have an internet connection."
								  delegate:self cancelButtonTitle:@"OK"
								  otherButtonTitles:nil, nil];
		[baseAlert show];*/
        
        [nc postNotificationName:@"didFinishInvitingFBFriend" object:nil];
	}
}


- (void)inviteFacebookFriend:(NSString *)inviteeFB name:(NSString *)inviteeName
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@InviteFriend", WebServiceSource];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"escapedUrl %@", escapedUrl);
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  facebookUserID, @"inviterfb",
                                  inviteeFB, @"inviteefb",
                                  inviteeName, @"inviteeName",
                                  nil];
    
    //SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    //NSString *jsonString = [jsonWriter stringWithObject:myDictionary];
    //NSLog(@"dictionary: %@", jsonString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:myDictionary options:0 error:&error];
    [request setHTTPBody:postdata];
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	//NSLog(@"%@", error);
    
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (theConnection)
	{
        //NSLog(@"Connection created successfully");
		receivedData = nil;
		receivedData = [NSMutableData data];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else
	{
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishInvitingFBFriend" object:nil];
	}

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
    //NSLog(@"%@", error);
	receivedData = nil;
    
    /*
    // inform the user
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
													message:@"There was an error while connecting to the server. "
                          "Either the service is down or you don't have an internet connection."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	[nc postNotificationName:@"didFinishInvitingFBFriend" object:nil];
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
    
    NSString *result = (NSString*)[userInfo objectForKey:@"InviteFacebookFriendResult"];
    
    if ([result intValue] > 0)
    {   //do nothing
        
    }
    else
    {
        //just log
    }
	
	[nc postNotificationName:@"didFinishInvitingFBFriend" object:nil];
    
	receivedData = nil;
    
}

@end
