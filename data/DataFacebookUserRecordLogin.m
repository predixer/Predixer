//
//  DataFacebookUserRecordLogin.m
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataFacebookUserRecordLogin.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

@implementation DataFacebookUserRecordLogin

@synthesize fbUserID;

- (id)init {
	if ((self = [super init])) {
        
        receivedData = [[NSMutableData alloc] init];            
        
	}
	
	return self;
}

#pragma mark Fetch from the internet

- (void)updateFBUserLoginRecord
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/UpdateFacebookUserLogin?fb=%@", fbUserID];
    
    NSLog(@"urlString %@", urlString);
     NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
    
	if (theConnection)
	{
        NSLog(@"Connection created successfully");
		receivedData = nil;
		receivedData = [NSMutableData data];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else
	{
		//Alert user for connection null response
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Cannot Connect!" message:@"Either the service is down or you don't have an internet connection." 
								  delegate:self cancelButtonTitle:@"OK" 
								  otherButtonTitles:nil, nil]; 
		[baseAlert show];
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
    NSLog(@"%@", error);
	receivedData = nil;
    
    // inform the user
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
													message:@"There was an error while connecting to the server."
                          "Either the service is down or you don't have an internet connection."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    nc = [NSNotificationCenter defaultCenter]; 
	[nc postNotificationName:@"didFinishUpdatingFacebookUserLogin" object:nil];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];   
    
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@"Login JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    for (id key in userInfo) {        
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSString *result = (NSString*)[userInfo objectForKey:@"UpdateFacebookUserLoginResult"];
    
    if ([result intValue] > 0)
    {   //do nothing
        
    }
    else
    {
        //just log
    }  
    
    dataReady = YES;
	
    nc = [NSNotificationCenter defaultCenter]; 
	[nc postNotificationName:@"didFinishUpdatingFacebookUserLogin" object:nil];
    
	receivedData = nil;
    
}

@end
