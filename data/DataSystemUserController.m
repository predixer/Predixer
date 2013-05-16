//
//  DataSystemUserController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/1/12.
//
//

#import "DataSystemUserController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataSystemUser.h"
#import "Constants.h"

@implementation DataSystemUserController

@synthesize sysUser;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrSystemUser count] == 0) {
			arrSystemUser = [[NSMutableArray alloc] init];
			sysUser = [[DataSystemUser alloc] init];
			receivedData = [[NSMutableData alloc] init];
            nc = [NSNotificationCenter defaultCenter];

		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrSystemUser != newList) {
		arrSystemUser = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrSystemUser count];
}


- (DataSystemUser *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrSystemUser count] != 0) {
        return [arrSystemUser objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)checkSystemUser:(NSString *)email pwd:(NSString *)pwd
{
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@Login?em=%@&pw=%@", WebServiceSource, email, pwd];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"escapedUrl %@", escapedUrl);
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         email, @"em",
                         pwd, @"pw",
                         nil];

     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    /*
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/Login?em=%@&pw=%@", email, pwd];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	*/
    
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrSystemUser removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishSystemUserLogin" object:nil];
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
    
    [nc postNotificationName:@"didFinishSystemUserLogin" object:nil];
    
    
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
    
    
    //NSDictionary *aUser = [userInfo objectForKey:@"LoginResult"];
    
    NSString *userID = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"UserID"]];
    //NSLog(@"userID: %@",userID);
          
    if ([userID isEqualToString:@"<null>"]) {
        userID = @"0";
    }
    
    NSString *userName = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"UserName"]];
    //NSLog(@"userName: %@",userName);
    
    if ([userName isEqualToString:@"<null>"]) {
        userName = @"0";
    }
    
    NSString *email = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"Email"]];
    //NSLog(@"email: %@",email);
    
    if ([email isEqualToString:@"<null>"]) {
        email = @"0";
    }
    
    NSString *dateEntered = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"DateEntered"]];
    NSDate *addedDate = [[NSDate alloc] init];
    
    if ([dateEntered isEqualToString:@"<null>"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateEntered = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        addedDate = [dateFormatter dateFromString:dateEntered ];
        
        //NSLog(@"addedDate %@", addedDate);
    }
    
    NSString *wrongPW = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"isWrongPassword"]];
    
    if ([wrongPW isEqualToString:@"<null>"]) {
        wrongPW = @"No";
    }
    
    [arrSystemUser addObject:[DataSystemUser recordWithID:userID userName:userName email:email dateEntered:addedDate isWrongPassword:wrongPW]];
    
    
	receivedData = nil;
    
    [nc postNotificationName:@"didFinishSystemUserLogin" object:nil];
    
    
}

@end
