//
//  DataFacebookUserController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataFacebookUserController.h"
#import "DataFacebookUser.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "Constants.h"

@implementation DataFacebookUserController

@synthesize facebookUser;
@synthesize fbUserID;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrUser count] == 0) {
			arrUser = [[NSMutableArray alloc] init];
			facebookUser = [[DataFacebookUser alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            nc = [NSNotificationCenter defaultCenter];

		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrUser != newList) {
		arrUser = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrUser count];
}


- (DataFacebookUser *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrUser count] != 0) {
        return [arrUser objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getFBUser
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    //NSLog(@"%@", fbUserID);
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetFacebookUser?fb=%@", WebServiceSource, fbUserID];
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrUser removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingFacebookUser" object:nil];
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
    
	[nc postNotificationName:@"didFinishLoadingFacebookUser" object:nil];
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
    
    
    NSDictionary *aUser= [userInfo objectForKey:@"GetFacebookUserResult"];
    
    NSString *recordId = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FBRecordID"]];
    
    if ([recordId isEqualToString:@"<null>"]) {
        recordId = @"0";
    }
    
    
    NSString *userID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"UserID"]];
    
    if ([userID isEqualToString:@"<null>"]) {
        userID = @"";
    }
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookUserID"]];
    
    if ([facebookUserID isEqualToString:@"<null>"]) {
        facebookUserID = @"";
    }
    
    NSString *facebookUserEmail = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookUserEmail"]];
    
    if ([facebookUserEmail isEqualToString:@"<null>"]) {
        facebookUserEmail = @"";
    }
    
    NSString *facebookName = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookName"]];
    
    if ([facebookName isEqualToString:@"<null>"]) {
        facebookName = @"";
    }
    
    NSString *facebookFirstName = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookFirstName"]];
    
    if ([facebookFirstName isEqualToString:@"<null>"]) {
        facebookFirstName = @"";
    }
    
    NSString *facebookLastName = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookLastName"]];
    
    if ([facebookLastName isEqualToString:@"<null>"]) {
        facebookLastName = @"";
    }
    
    NSString *facebookUserName = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookUserName"]];
    
    if ([facebookUserName isEqualToString:@"<null>"]) {
        facebookUserName = @"";
    }
    
    NSString *facebookUserGender = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookUserGender"]];
    
    if ([facebookUserGender isEqualToString:@"<null>"]) {
        facebookUserGender = @"";
    }
    
    NSString *facebookUserLocation = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FacebookUserLocation"]];
    
    if ([facebookUserLocation isEqualToString:@"<null>"]) {
        facebookUserLocation = @"";
    }
    
    NSString *dateEntered = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"DateEntered"]];
    NSDate *addedDate = [[NSDate alloc] init];
    
    if ([dateEntered isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateEntered = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        addedDate = [dateFormatter dateFromString:dateEntered ];
    }
    
    NSString *lastLogin = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"LastLogin"]];
    NSDate *updatedDate = [[NSDate alloc] init];
    
    if ([lastLogin isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        lastLogin = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        updatedDate = [dateFormatter dateFromString:lastLogin];
    }
    
    [arrUser addObject:[DataFacebookUser recordWithID:recordId userID:userID facebookUserID:facebookUserID facebookUserEmail:facebookUserEmail facebookName:facebookName facebookUserFirstName:facebookFirstName facebookUserLastName:facebookLastName facebookUserName:facebookUserName facebookUserGender:facebookUserGender facebookUserLocation:facebookUserLocation dateEntered:addedDate lastLogin:updatedDate]];

    
    dataReady = YES;
	
    [nc postNotificationName:@"didFinishLoadingFacebookUser" object:nil];
    
	receivedData = nil;
    
}


@end
