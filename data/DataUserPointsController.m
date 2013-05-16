//
//  DataUserPointsController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import "DataUserPointsController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataUserPoints.h"
#import "Constants.h"

@implementation DataUserPointsController

@synthesize userPoints;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrUserPoints count] == 0) {
			arrUserPoints = [[NSMutableArray alloc] init];
			userPoints = [[DataUserPoints alloc] init];
			receivedData = [[NSMutableData alloc] init];
            nc = [NSNotificationCenter defaultCenter];
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrUserPoints != newList) {
		arrUserPoints = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrUserPoints count];
}


- (DataUserPoints *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrUserPoints count] != 0) {
        return [arrUserPoints objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getPoints
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fbUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    //NSLog(@"%@", fbUserID);
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetUserTotalPoints?fb=%@", WebServiceSource, fbUserID];
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    dataReady = NO;
	[arrUserPoints removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingUserPoints" object:nil];
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
    
	[nc postNotificationName:@"didFinishLoadingUserPoints" object:nil];
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
    
    
    NSDictionary *aUser= [userInfo objectForKey:@"GetUserTotalPointsResult"];
    
    NSString *recordId = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FBRecordID"]];
    
    if ([recordId isEqualToString:@"<null>"]) {
        recordId = @"0";
    }    
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FBUserID"]];
    
    if ([facebookUserID isEqualToString:@"<null>"]) {
        facebookUserID = @"";
    }
    
    NSString *topCommentPoints = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"TopCommentPoints"]];
    
    if ([topCommentPoints isEqualToString:@"<null>"]) {
        topCommentPoints = @"0";
    }
    
    NSString *invitePoints = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"InvitePoints"]];
    
    if ([invitePoints isEqualToString:@"<null>"]) {
        invitePoints = @"0";
    }
    
    NSString *totalPredictPoints = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"TotalPredictPoints"]];
    
    if ([totalPredictPoints isEqualToString:@"<null>"]) {
        totalPredictPoints = @"0";
    }
    
    NSString *grandTotalPoints = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"GrandTotalPoints"]];
    
    if ([grandTotalPoints isEqualToString:@"<null>"]) {
        grandTotalPoints = @"0";
    }
    
    NSString *drawPoints = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"DrawPoints"]];
    
    if ([drawPoints isEqualToString:@"<null>"]) {
        drawPoints = @"0";
    }
    
    [arrUserPoints addObject:[DataUserPoints recordWithID:recordId facebookUserID:facebookUserID topCommentPoints:topCommentPoints invitePoints:invitePoints totalPredictPoints:totalPredictPoints grandTotalPoints:grandTotalPoints drawPoints:drawPoints]];
    
    
    dataReady = YES;
	
    [nc postNotificationName:@"didFinishLoadingUserPoints" object:nil];
    
	receivedData = nil;
    
}


@end
