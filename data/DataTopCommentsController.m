//
//  DataTopCommentsController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import "DataTopCommentsController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataTopComments.h"

@implementation DataTopCommentsController

@synthesize topComments;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrComments count] == 0) {
			arrComments = [[NSMutableArray alloc] init];
			topComments = [[DataTopComments alloc] init];
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


- (DataTopComments *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrComments count] != 0) {
        return [arrComments objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getTopComments
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.predixer.com/svc/predixerservice.svc/GetUserTopComments?fb=%@", facebookUserID];
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"escapedUrl %@", escapedUrl);
    
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
        
        [nc postNotificationName:@"didFinishLoadingUserTopComments" object:nil];
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
    
    [nc postNotificationName:@"didFinishLoadingUserTopComments" object:nil];

    
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
    
    arrObjects = [userInfo objectForKey:@"GetUserTopCommentsResult"];
    
    
    for (int i = 0; i < [arrObjects count]; i++) {
        
        NSDictionary *aComment = [arrObjects objectAtIndex:i];
        
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
        
        NSString *comment = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Comment"]];
        
        if ([comment isEqualToString:@"<null>"]) {
            comment = @"";
        }
        
        NSString *commentDate = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"CommentDate"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([commentDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            commentDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            addedDate = [dateFormatter dateFromString:commentDate ];
        }
        
        NSString *question = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"Question"]];
        
        if ([question isEqualToString:@"<null>"]) {
            question = @"";
        }
        
        NSString *questionPoints = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"QuestionPoints"]];
        
        if ([questionPoints isEqualToString:@"<null>"]) {
            questionPoints = @"0";
        }
        
        NSString *questionDate = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"QuestionDate"]];
        NSDate *dateQuestion = [[NSDate alloc] init];
        
        if ([questionDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            questionDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            dateQuestion = [dateFormatter dateFromString:questionDate ];
        }
        
        NSString *totalLikes = [NSString stringWithFormat:@"%@", [aComment objectForKey:@"TotalLikes"]];
        
        if ([totalLikes isEqualToString:@"<null>"]) {
            totalLikes = @"0";
        }
        
        
        [arrComments addObject:[DataTopComments commentWithID:[commentsID intValue] questionID:[questionID intValue] fbUserID:fbUserID comment:comment commentDate:addedDate question:question questionPoints:[questionPoints intValue] questionDate:dateQuestion totalLikes:[totalLikes intValue]]];
        
    }
    
    [nc postNotificationName:@"didFinishLoadingUserTopComments" object:nil];
    
	receivedData = nil;
    
}

@end
