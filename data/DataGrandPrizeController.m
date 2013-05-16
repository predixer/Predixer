//
//  DataGrandPrizeController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/2/12.
//
//

#import "DataGrandPrizeController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

@implementation DataGrandPrizeController

@synthesize strGrandPrize;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrPrize count] == 0) {
			arrPrize = [[NSMutableArray alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            nc = [NSNotificationCenter defaultCenter];

		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrPrize != newList) {
		arrPrize = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrPrize count];
}

#pragma mark Fetch from the internet

- (void)getGrandPrize
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetGrandPrize"];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrPrize removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishGettingGrandPrize" object:nil];
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
    
    [nc postNotificationName:@"didFinishGettingGrandPrize" object:nil];
    
    
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
    
    NSString *result = (NSString*)[userInfo objectForKey:@"GetGrandPrizeResult"];
    
    if ([result length] > 0)
    {
        strGrandPrize = [NSString stringWithFormat:@"%@", result];
    }
    else
    {
        strGrandPrize = @"$1,000.00";
    }
    
    [nc postNotificationName:@"didFinishGettingGrandPrize" object:nil];
    
	receivedData = nil;
    
}

@end
