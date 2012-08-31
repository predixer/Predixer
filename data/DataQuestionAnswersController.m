//
//  DataQuestionAnswersController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataQuestionAnswersController.h"
#import "DataQuestionAnswers.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

@implementation DataQuestionAnswersController

@synthesize questionAnswers;
@synthesize questionID;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrAnswers count] == 0) {
			arrAnswers = [[NSMutableArray alloc] init];
			questionAnswers = [[DataQuestionAnswers alloc] init];
			receivedData = [[NSMutableData alloc] init];            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrAnswers != newList) {
		arrAnswers = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrAnswers count];
}


- (DataQuestionAnswers *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrAnswers count] != 0) {
        return [arrAnswers objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getAnswers
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    NSLog(@"%@", questionID);
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetQuestionOptions?qid=%@", questionID];
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrAnswers removeAllObjects];
    
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
	[nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];
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
    
    NSArray *arrObjects = [[NSArray alloc] init];
    arrObjects = [userInfo objectForKey:@"GetQuestionOptionsResult"];
    
    for (int i = 0; i < [arrObjects count]; i++) {
		
		NSDictionary *aAnswer= [arrObjects objectAtIndex:i];
		
        NSString *answerId = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerSelectionID"]];
        
        
        NSLog(@"answerid %@", answerId);
        NSLog(@"answerid intValue %d", [answerId intValue]);
        
        if ([answerId isEqualToString:@"<null>"]) {
            answerId = @"0";
        }
        
		NSString *answerText = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerOption"]];
        
        if ([answerText isEqualToString:@"<null>"]) {
            answerText = @"";
        }
        
        NSString *aQuestionID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"QuestionID"]];
        
        if ([aQuestionID isEqualToString:@"<null>"]) {
            aQuestionID = @"";
        }
        
        NSString *isCorrect = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"IsCorrect"]];	
        
        if ([isCorrect isEqualToString:@"<null>"]) {
            isCorrect = @"0";
        }
        
                
        [arrAnswers addObject:[DataQuestionAnswers answerWithID:[answerId intValue] questionID:aQuestionID answerText:answerText isCorrect:[isCorrect boolValue]]];
    }
    
    dataReady = YES;
	
	nc = [NSNotificationCenter defaultCenter]; 
    [nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];
    
	receivedData = nil;
    
}


@end
