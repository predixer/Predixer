//
//  DataUserAnswersController.m
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import "DataUserAnswersController.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "DataUserAnswers.h"
#import "Constants.h"

@implementation DataUserAnswersController

@synthesize userAnswer;
@synthesize isGetCorrectAnswers;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrAnswer count] == 0) {
			arrAnswer = [[NSMutableArray alloc] init];
			userAnswer = [[DataUserAnswers alloc] init];
			receivedData = [[NSMutableData alloc] init];

            isGetCorrectAnswers = NO;
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


- (DataUserAnswers *)objectInListAtIndex:(unsigned)theIndex {
    
    if ([arrAnswer count] != 0) {
        return [arrAnswer objectAtIndex:theIndex];
    }
    else
    {
        return 0;
    }
}

#pragma mark Fetch from the internet

- (void)getUserAnswers
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    NSString *facebookUserID = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"fbId"]];
    
    NSString *urlString =@"";
    
    if (isGetCorrectAnswers == YES) {
        urlString = [NSString stringWithFormat:@"%@GetUserAnswersCorrect?fb=%@", WebServiceSource, facebookUserID];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@GetUserAnswersAll?fb=%@", WebServiceSource, facebookUserID];
    }
    
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
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
        
        
        if (isGetCorrectAnswers == YES) {
            [nc postNotificationName:@"didFinishLoadingUserAnswersCorrect" object:nil];
        }
        else if (isGetCorrectAnswers == NO)
        {
            [nc postNotificationName:@"didFinishLoadingUserAnswersAll" object:nil];
        }
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
    
    
    if (isGetCorrectAnswers == YES) {
        [nc postNotificationName:@"didFinishLoadingUserAnswersCorrect" object:nil];
    }
    else if (isGetCorrectAnswers == NO)
    {
        [nc postNotificationName:@"didFinishLoadingUserAnswersAll" object:nil];
    }
    
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
    
    if (isGetCorrectAnswers == YES) {
        
        arrObjects = [userInfo objectForKey:@"GetUserAnswersCorrectResult"];
     }
    else if (isGetCorrectAnswers == NO) {
        
        arrObjects = [userInfo objectForKey:@"GetUserAnswersAllResult"];
    }

        
    for (int i = 0; i < [arrObjects count]; i++) {
        
        NSDictionary *aAnswer = [arrObjects objectAtIndex:i];
        
        NSString *fbUserID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"FBUserID"]];
        
        if ([fbUserID isEqualToString:@"<null>"]) {
            fbUserID = @"";
        }
        
        NSString *categoryID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"CategoryID"]];
        
        if ([categoryID isEqualToString:@"<null>"]) {
            categoryID = @"0";
        }
        
        NSString *categoryName = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"CategoryName"]];
        
        if ([categoryName isEqualToString:@"<null>"]) {
            categoryName = @"";
        }
        
        
        NSString *questionID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"QuestionID"]];
        
        if ([questionID isEqualToString:@"<null>"]) {
            questionID = @"0";
        }
        
        NSString *question = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"Question"]];
        
        if ([question isEqualToString:@"<null>"]) {
            question = @"";
        }
        
        NSString *questionPoints = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"QuestionPoints"]];
        
        if ([questionPoints isEqualToString:@"<null>"]) {
            questionPoints = @"0";
        }
        
        NSString *answerID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerID"]];
        
        if ([answerID isEqualToString:@"<null>"]) {
            answerID = @"0";
        }
        
        NSString *answerSelectionID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerSelectionID"]];
        
        if ([answerSelectionID isEqualToString:@"<null>"]) {
            answerSelectionID = @"0";
        }
        
        NSString *answerOption = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerOption"]];
        
        if ([answerOption isEqualToString:@"<null>"]) {
            answerOption = @"0";
        }
        
        NSString *answerDate = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerDate"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([answerDate isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            answerDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            addedDate = [dateFormatter dateFromString:answerDate ];
        }
        
        NSString *isCorrect = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"isCorrect"]];
        
        if ([isCorrect isEqualToString:@"<null>"]) {
            isCorrect = @"0";
        }
        
        //NSLog(@"isCorrect %@ %d", isCorrect, [isCorrect boolValue]);
        
        NSString *isAnswerSet = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"isAnswerSet"]];
        
        if ([isAnswerSet isEqualToString:@"<null>"]) {
            isAnswerSet = @"0";
        }
        
        
        //NSLog(@"isAnswerSet %@ %d", isAnswerSet, [isAnswerSet boolValue]);
        
        [arrAnswer addObject:[DataUserAnswers answerWithID:[answerID intValue] answerSelectionID:[answerSelectionID intValue] answerOption:answerOption isCorrect:[isCorrect boolValue] answerDate:addedDate fbUserID:fbUserID categoryID:[categoryID intValue] categoryName:categoryName questionID:[questionID intValue] question:question questionPoints:[questionPoints intValue] isAnswerSet:[isAnswerSet boolValue]]];
        
    }
    
    
    if (isGetCorrectAnswers == YES) {
        [nc postNotificationName:@"didFinishLoadingUserAnswersCorrect" object:nil];
    }
    else if (isGetCorrectAnswers == NO)
    {
        [nc postNotificationName:@"didFinishLoadingUserAnswersAll" object:nil];
    }
    
	receivedData = nil;
    
}

@end
