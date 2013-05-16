//
//  DataHowToController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/24/12.
//
//

#import "DataHowToController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataHowTo.h"
#import "Constants.h"

@implementation DataHowToController

@synthesize howTo;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrData count] == 0) {
			arrData = [[NSMutableArray alloc] init];
            howTo = [[DataHowTo alloc] init];
            nc = [NSNotificationCenter defaultCenter];

		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrData != newList) {
		arrData = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrData count];
}

- (DataHowTo *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrData count] != 0) {
        return [arrData objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

/*
- (NSString *)objectInListAtIndex:(unsigned)theIndex
{
    if ([arrData count] != 0) {
        return [arrData objectAtIndex:theIndex];
    }
    else
    {
        return @"";
    }
}
*/

#pragma mark Fetch from the internet

- (void)getHowToText
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetHowTo", WebServiceSource];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrData removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishGettingHowTo" object:nil];
	}
}

- (void)getHowTo
{
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    /*
    if ([filemgr fileExistsAtPath: @"howto.txt" ] == YES)
        NSLog (@"File exists");
    else
        NSLog (@"File not found");
    */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/HowTo.txt"];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrData removeAllObjects];
    
	if (theConnection)
	{
        //NSLog(@"Connection created successfully");
		receivedData = nil;
        receivedData = [[NSMutableData alloc] init];
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
        
        [nc postNotificationName:@"didFinishGettingHowTo" object:nil];
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
    //NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 	//NSLog(@"data Response: %@", response);
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
    
    [nc postNotificationName:@"didFinishGettingHowTo" object:nil];
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
	
    //Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@"Response: %@", response);
	
    //Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    /*
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }*/
    
    NSDictionary *aHowTo = [userInfo objectForKey:@"GetHowToResult"];
    
    NSString *howToText = [NSString stringWithFormat:@"%@", [aHowTo objectForKey:@"HowToText"]];
    NSLog(@"howToText %@", howToText);
    
    if ([howToText isEqualToString:@"<null>"]) {
        howToText = @"";
    }
    
    NSString *dateUpdated = [NSString stringWithFormat:@"%@", [aHowTo objectForKey:@"DateUpdated"]];
    NSDate *updatedDate = [[NSDate alloc] init];
    
    if ([dateUpdated isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateUpdated = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        updatedDate = [dateFormatter dateFromString:dateUpdated ];
        
        //NSLog(@"updatedDate %@", updatedDate);
    }
    
    [arrData addObject:[DataHowTo howToWithText:howToText dateUpdated:updatedDate]];

    
    /* for getting text file
    if (response != nil) {        
        [arrData addObject:response];
    }
	  */
    
    
   [nc postNotificationName:@"didFinishGettingHowTo" object:nil];
    
	receivedData = nil;
    
}

@end
