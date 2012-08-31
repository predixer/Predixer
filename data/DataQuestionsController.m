//
//  DataQuestionsController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataQuestionsController.h"
#import "DataQuestions.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

@implementation DataQuestionsController

@synthesize questionsData;
@synthesize categoryID;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrQuestions count] == 0) {
			arrQuestions = [[NSMutableArray alloc] init];
			questionsData = [[DataQuestions alloc] init];
			receivedData = [[NSMutableData alloc] init];            
		}
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrQuestions != newList) {
		arrQuestions = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrQuestions count];
}


- (DataQuestions *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrQuestions count] != 0) {
        return [arrQuestions objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getQuestions
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    NSLog(@"%@", categoryID);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetQuestions?cid=%@&dt=%@", categoryID, dateString];
        
    NSLog(@"%@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrQuestions removeAllObjects];
    
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
	[nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];   
    
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
   
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@" JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    for (id key in userInfo) {        
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSArray *arrObjects = [[NSArray alloc] init];
    arrObjects = [userInfo objectForKey:@"GetQuestionsResult"];
    
    for (int i = 0; i < [arrObjects count]; i++) {
		
		NSDictionary *aQuestion= [arrObjects objectAtIndex:i];
		
        NSString *questionId = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionsID"]];
        
        if ([questionId isEqualToString:@"<null>"]) {
            questionId = @"0";
        }
        
		NSString *dataCategoryId = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"CategoryID"]];
        
        if ([dataCategoryId isEqualToString:@"<null>"]) {
            dataCategoryId = @"";
        }
        
        NSString *questionText = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"Question"]];
        
        if ([questionText isEqualToString:@"<null>"]) {
            questionText = @"";
        }
        
        NSString *questionPoints = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionPoints"]];	
        
        if ([questionPoints isEqualToString:@"<null>"]) {
            questionPoints = @"0";
        }
        
        NSString *dateAdded = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"DateAdded"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([dateAdded isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateAdded = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            addedDate = [dateFormatter dateFromString:dateAdded ];
        }
        
        NSString *dateUpdated = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"DateUpdated"]];
        NSDate *updatedDate = [[NSDate alloc] init];
        
        if ([dateUpdated isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateUpdated = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            updatedDate = [dateFormatter dateFromString:dateUpdated];
        }
        
        [arrQuestions addObject:[DataQuestions questionWithID:questionId categoryID:dataCategoryId question:questionText questionPoints:[questionPoints intValue] dateAdded:addedDate dateUpdated:updatedDate]];
    }
    
    dataReady = YES;
	
	nc = [NSNotificationCenter defaultCenter]; 
    [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
    
	receivedData = nil;
    
}

@end
