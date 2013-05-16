//
//  DataUserCommentLikeController.m
//  predict
//
//  Created by Joel R Ballesteros on 10/11/12.
//
//

#import "DataUserCommentLikeController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataUserCommentLike.h"

@implementation DataUserCommentLikeController

@synthesize dataUserCommentLike;
@synthesize arrComments;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrComments count] == 0) {
			arrComments = [[NSMutableArray alloc] init];
			dataUserCommentLike = [[DataUserCommentLike alloc] init];
			receivedData = [[NSMutableData alloc] init];
            nc = [NSNotificationCenter defaultCenter];
            
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


- (DataUserCommentLike *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrComments count] != 0) {
        return [arrComments objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getUserCommentsLikes:(NSString *)questionID
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetUserCommentAllLike?id=%@&f=%@", questionID, facebookUserID];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrComments removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingUserCommentsAllLike" object:nil];
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
    
    [nc postNotificationName:@"didFinishLoadingUserCommentsAllLike" object:nil];
    
    
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
    
    
    NSArray *arrObjects = [[NSArray alloc] init];
    
    arrObjects = [userInfo objectForKey:@"GetUserCommentAllLikeResult"];
    
    
    for (int i = 0; i < [arrObjects count]; i++) {
        
        NSDictionary *aComment = [arrObjects objectAtIndex:i];
        
        NSString *commentsLikeID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comments_Like_ID"]];
        
        if ([commentsLikeID isEqualToString:@"<null>"]) {
            commentsLikeID = @"0";
        }
        
        NSString *commentsID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comments_ID"]];
        
        if ([commentsID isEqualToString:@"<null>"]) {
            commentsID = @"0";
        }
        
        NSString *questionID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Question_ID"]];
        
        if ([questionID isEqualToString:@"<null>"]) {
            questionID = @"0";
        }
        
        NSString *fbUserID = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"FB_UserID"]];
        
        if ([fbUserID isEqualToString:@"<null>"]) {
            fbUserID = @"";
        }
        
        
        NSString *likeDate = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"LikeDate"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([likeDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            likeDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            addedDate = [dateFormatter dateFromString:likeDate ];
        }
        
        
        [arrComments addObject:[DataUserCommentLike commentLikeWithID:[commentsLikeID intValue] commentID:[commentsID intValue] questionID:[questionID intValue] fbUserID:fbUserID likeDate:addedDate]];
        
    }
    
    [nc postNotificationName:@"didFinishLoadingUserCommentsAllLike" object:nil];
    
	receivedData = nil;
    
}

@end
