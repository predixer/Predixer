//
//  DataCommentsController.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataCommentsController.h"
#import "DataComments.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"


@implementation DataCommentsController

@synthesize commentsData;
@synthesize questionID;
@synthesize commentID;
@synthesize userDidLike;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrComments count] == 0) {
			arrComments = [[NSMutableArray alloc] init];
			commentsData = [[DataComments alloc] init];
			receivedData = [[NSMutableData alloc] init];            
		}
        
        
	}
	
	return self;
}

// Custom set accessor to ensure the new list is mutable
- (void)setList:(NSMutableArray *)newList {
	
	if (arrComments != newList) {
		arrComments = [newList mutableCopy];
	}
}

// Accessor methods for list
- (unsigned)countOfList {
	return [arrComments count];
}


- (DataComments *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrComments count] != 0) {
        return [arrComments objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)likeComment
{
    isLike = YES;
    isTopComments = NO;
    isUserCommentLike = NO;
    userDidLike = NO;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/AddCommentsLike?id=%@&f=%@", commentID, facebookUserID];
    
    NSLog(@"urlString %@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"escapedUrl %@", escapedUrl);
    
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

- (void)getTopComments
{
    isTopComments = YES;
    isLike = NO;
    isUserCommentLike = NO;
    userDidLike = NO;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSLog(@"questionID %@", questionID);
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetQuestionUserTopComments?qid=%@", questionID];
    NSLog(@"urlString %@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    dataReady = NO;
	[arrComments removeAllObjects];
    
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


- (void)getComments
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    NSLog(@"questionID %@", questionID);

    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetQuestionUserComments?qid=%@", questionID];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString %@", urlString);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrComments removeAllObjects];
    
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

- (void)getUserCommentLike
{
    isUserCommentLike = YES;
    isLike = NO;
    isTopComments = NO;
    userDidLike = NO;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetUserCommentLike?id=%@&f=%@", commentID, facebookUserID];
    
    NSLog(@"urlString %@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"escapedUrl %@", escapedUrl);
    
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
	
    if (isLike == NO) {
        [nc postNotificationName:@"didFinishLoadingComments" object:nil];
    }
    else if (isTopComments == YES)
    {
        [nc postNotificationName:@"didFinishLoadingTopComments" object:nil];
    }
    else if (isLike == YES)
    {
        [nc postNotificationName:@"didFinishLikeComment" object:nil];
    }
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
    
    if (isLike == NO && isTopComments == NO && isUserCommentLike == NO) {
        NSArray *arrObjects = [[NSArray alloc] init];
        arrObjects = [userInfo objectForKey:@"GetQuestionUserCommentsResult"];
        
        for (int i = 0; i < [arrObjects count]; i++) {
            
            NSDictionary *aComment = [arrObjects objectAtIndex:i];
            
            NSString *commentId = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comments_ID"]];
            
            if ([commentId isEqualToString:@"<null>"]) {
                commentId = @"0";
            }
            
            NSString *dataQuestionId = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Question_ID"]];
            
            if ([dataQuestionId isEqualToString:@"<null>"]) {
                dataQuestionId = @"";
            }
            
            NSString *userID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"User_ID"]];
            
            if ([userID isEqualToString:@"<null>"]) {
                userID = @"";
            }
            
            NSString *fbUserID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"FB_UserID"]];
            
            if ([fbUserID isEqualToString:@"<null>"]) {
                fbUserID = @"";
            }
            
            NSString *fbName = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Facebook_Name"]];
            
            if ([fbName isEqualToString:@"<null>"]) {
                fbName = @"";
            }
            
            NSString *fbEmail = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Facebook_UserEmail"]];
            
            if ([fbEmail isEqualToString:@"<null>"]) {
                fbEmail = @"";
            }
            
            NSString *comment = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comment"]];
            NSLog(@"Comment %@", comment);
            
            if ([comment isEqualToString:@"<null>"]) {
                comment = @"";
            }
            
            NSString *commentDate = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"CommentDate"]];
            
            if ([commentDate isEqualToString:@"<null>"]) {
                commentDate = @"";
            }
            
            NSString *totalLike = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"TotalLikes"]];
            
            if ([totalLike isEqualToString:@"<null>"]) {
                totalLike = @"0";
            }
            
            [arrComments addObject:[DataComments commentWithID:commentId questionID:dataQuestionId userID:userID fbUserID:fbUserID fbName:fbName fbUserEmail:fbEmail comment:comment commentDate:commentDate totalLikes:totalLike]];
        }
        
        
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishLoadingComments" object:nil];
        
    }
    if (isTopComments == YES && isUserCommentLike == NO && isLike == NO) {
        NSArray *arrObjects = [[NSArray alloc] init];
        arrObjects = [userInfo objectForKey:@"GetQuestionUserTopCommentsResult"];
        
        for (int i = 0; i < [arrObjects count]; i++) {
            
            NSDictionary *aComment = [arrObjects objectAtIndex:i];
            
            NSString *commentId = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comments_ID"]];
            
            if ([commentId isEqualToString:@"<null>"]) {
                commentId = @"0";
            }
            
            NSString *dataQuestionId = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Question_ID"]];
            
            if ([dataQuestionId isEqualToString:@"<null>"]) {
                dataQuestionId = @"";
            }
            
            NSString *userID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"User_ID"]];
            
            if ([userID isEqualToString:@"<null>"]) {
                userID = @"";
            }
            
            NSString *fbUserID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"FB_UserID"]];
            
            if ([fbUserID isEqualToString:@"<null>"]) {
                fbUserID = @"";
            }
            
            NSString *fbName = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Facebook_Name"]];
            
            if ([fbName isEqualToString:@"<null>"]) {
                fbName = @"";
            }
            
            NSString *fbEmail = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Facebook_UserEmail"]];
            
            if ([fbEmail isEqualToString:@"<null>"]) {
                fbEmail = @"";
            }
            
            NSString *comment = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comment"]];
            NSLog(@"Comment %@", comment);
            
            if ([comment isEqualToString:@"<null>"]) {
                comment = @"";
            }
            
            NSString *commentDate = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"CommentDate"]];
            
            if ([commentDate isEqualToString:@"<null>"]) {
                commentDate = @"";
            }
            
            NSString *totalLike = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"TotalLikes"]];
            
            if ([totalLike isEqualToString:@"<null>"]) {
                totalLike = @"0";
            }
            
            [arrComments addObject:[DataComments commentWithID:commentId questionID:dataQuestionId userID:userID fbUserID:fbUserID fbName:fbName fbUserEmail:fbEmail comment:comment commentDate:commentDate totalLikes:totalLike]];
        }
        
        
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishLoadingTopComments" object:nil];
        
    }
    else if (isUserCommentLike == YES && isLike == NO && isTopComments == NO)
    {
        
        
        NSString *result = (NSString*)[userInfo objectForKey:@"GetUserCommentLikeResult"];
        NSLog(@"like result %@", result);
        
        if ([result intValue] > 0)
        {   //do nothing
            if ([result intValue] == 1)
            {
                userDidLike = YES;
            }
        }
        else
        {
            //just log
        }
        
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishGettingUserLikeComment" object:nil];
        
    }
    
    else if (isLike == YES && isUserCommentLike == NO && isTopComments == NO)
    {   
        
        NSString *result = (NSString*)[userInfo objectForKey:@"AddCommentsLikeResult"];
        
        if ([result intValue] > 0)
        {   //do nothing
            
        }
        else
        {
            //just log
        }  
        
        nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"didFinishLikeComment" object:nil];
        
    }
    
    dataReady = YES;
	
	receivedData = nil;
    
}

@end
