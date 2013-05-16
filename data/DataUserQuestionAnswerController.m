//
//  DataUserQuestionAnswerController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataUserQuestionAnswerController.h"
#import "DataUserQuestionAnswer.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "Constants.h"

@implementation DataUserQuestionAnswerController

@synthesize questionAnswer;
@synthesize questionID;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrAnswer count] == 0) {
			arrAnswer = [[NSMutableArray alloc] init];
			questionAnswer = [[DataUserQuestionAnswer alloc] init];
			receivedData = [[NSMutableData alloc] init];
            nc = [NSNotificationCenter defaultCenter];
            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrAnswer != newList) {
		arrAnswer = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrAnswer count];
}


- (DataUserQuestionAnswer *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrAnswer count] != 0) {
        return [arrAnswer objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getAnswer
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    //NSLog(@"%@", questionID);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetUserQuestionAnswer?fb=%@&que=%@", WebServiceSource, facebookUserID, questionID];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrAnswer removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingUserQuestionAnswer" object:nil];
	} 
}

- (void)getUserAnswer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetQuestionUserAnswer", WebServiceSource];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"escapedUrl %@", escapedUrl);
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  facebookUserID, @"fbuid",
                                  questionID, @"questionid",
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
	
	dataReady = NO;
	[arrAnswer removeAllObjects];
    
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
        [nc postNotificationName:@"didFinishLoadingUserQuestionAnswer" object:nil];
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
    //NSLog(@"ERROR %@", error);
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
    
	[nc postNotificationName:@"didFinishLoadingUserQuestionAnswer" object:nil];
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
    
    
    NSDictionary *aUser= [userInfo objectForKey:@"GetUserQuestionAnswerResult"];
    
    NSString *answerID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"AnswerID"]];
    
    if ([answerID isEqualToString:@"<null>"]) {
        answerID = @"0";
    }
    
    
    NSString *userID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"UserID"]];
    
    if ([userID isEqualToString:@"<null>"]) {
        userID = @"";
    }
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"FBUserID"]];
    
    if ([facebookUserID isEqualToString:@"<null>"]) {
        facebookUserID = @"";
    }
    
    NSString *aQuestionID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"QuestionID"]];
    
    if ([aQuestionID isEqualToString:@"<null>"]) {
        aQuestionID = @"";
    }
    
    NSString *answerSelectionID = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"AnswerSelectionID"]];
    
    if ([answerSelectionID isEqualToString:@"<null>"]) {
        answerSelectionID = @"";
    }
    
    NSString *answerDate = [NSString stringWithFormat:@"%@", [aUser objectForKey:@"AnswerDate"]];
        
    [arrAnswer addObject:[DataUserQuestionAnswer answerWithID:[answerID intValue] userID:userID fbUserID:facebookUserID questionID:[aQuestionID intValue] answerSelectionID:[answerSelectionID intValue] answerDate:answerDate]];
    
    
    dataReady = YES;
	
    [nc postNotificationName:@"didFinishLoadingUserQuestionAnswer" object:nil];
    
	receivedData = nil;
    
}

@end
