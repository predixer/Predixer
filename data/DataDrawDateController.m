//
//  DataDrawDateController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/28/12.
//
//

#import "DataDrawDateController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataDrawDate.h"

@implementation DataDrawDateController

@synthesize dataDraw;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrDraw count] == 0) {
			arrDraw = [[NSMutableArray alloc] init];
			dataDraw = [[DataDrawDate alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            nc = [NSNotificationCenter defaultCenter];
            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrDraw != newList) {
		arrDraw = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrDraw count];
}


- (DataDrawDate *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrDraw count] != 0) {
        return [arrDraw objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getDrawDate
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetDrawDate"];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrDraw removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingDrawDate" object:nil];
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
    
    [nc postNotificationName:@"didFinishLoadingDrawDate" object:nil];
    
    
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
        
    NSDictionary *aDrawDate = [userInfo objectForKey:@"GetDrawDateResult"];
    
    NSString *drawID = [NSString stringWithFormat:@"%@", [aDrawDate objectForKey:@"DrawID"]];
    
    if ([drawID isEqualToString:@"<null>"]) {
        drawID = @"0";
    }
    
    NSString *drawDate = [NSString stringWithFormat:@"%@", [aDrawDate objectForKey:@"DrawDate"]];
    NSDate *addedDrawDate = [[NSDate alloc] init];
    
    if ([drawDate isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        drawDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        addedDrawDate = [dateFormatter dateFromString:drawDate ];
        
        // NSLog(@"addedDrawDate %@", addedDrawDate);
    }
    
    NSString *dateEntered = [NSString stringWithFormat:@"%@", [aDrawDate objectForKey:@"DateEntered"]];
    NSDate *addedDate = [[NSDate alloc] init];
    
    if ([dateEntered isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateEntered = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        addedDate = [dateFormatter dateFromString:dateEntered ];
        
        //NSLog(@"addedDate %@", addedDate);
    }
    
    NSString *dateUpdated = [NSString stringWithFormat:@"%@", [aDrawDate objectForKey:@"DateUpdated"]];
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
    
    [arrDraw addObject:[DataDrawDate drawWithID:[drawID intValue] drawDate:addedDrawDate dateEntered:addedDate dateUpdated:updatedDate]];

    
    [nc postNotificationName:@"didFinishLoadingDrawDate" object:nil];
    
	receivedData = nil;
    
}


@end
