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
#import "DataLoad.h"
#import "Constants.h"

@implementation DataQuestionAnswersController

@synthesize questionAnswers;
@synthesize questionID;
@synthesize isGetHistory;
@synthesize arrAnswers;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrAnswers count] == 0) {
			arrAnswers = [[NSMutableArray alloc] init];
			questionAnswers = [[DataQuestionAnswers alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            isGetHistory = NO;
            
            nc = [NSNotificationCenter defaultCenter];

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
    
    //NSLog(@"%@", questionID);
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetQuestionOptions?qid=%@", WebServiceSource, questionID];
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"escapedUrl %@", escapedUrl);
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
    dataReady = NO;
	[arrAnswers removeAllObjects];
    
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
        
        [nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];
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
    
    [nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];
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
    arrObjects = [userInfo objectForKey:@"GetQuestionOptionsResult"];
    
    int totalAnswers = 0;
    
    for (int i = 0; i < [arrObjects count]; i++) {
		
		NSDictionary *aAnswer= [arrObjects objectAtIndex:i];
		
        NSString *answerId = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswerSelectionID"]];
        
        
        //NSLog(@"answerid %@", answerId);
        //NSLog(@"answerid intValue %d", [answerId intValue]);
        
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
        
        NSString *answersCount = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"AnswersCount"]];
        
        //NSLog(@"answersCount %@", answersCount);
        //NSLog(@"answersCount intValue %d", [answersCount intValue]);
        
        if ([answersCount isEqualToString:@"<null>"]) {
            answersCount = @"0";
        }
        else {
             totalAnswers = totalAnswers + [answersCount intValue];
        }
        
        NSString *imageName = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"ImageName"]];
        
        //NSLog(@"imageName %@", imageName);
        
        if ([imageName isEqualToString:@"<null>"]) {
            imageName = @"";
        }
        
        NSString *description = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"Description"]];
        
        if ([description isEqualToString:@"<null>"]) {
            description = @"";
        }
        
        NSString *link = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"Link"]];
        
        if ([link isEqualToString:@"<null>"]) {
            link = @"";
        }
        
        NSString *imageID = [NSString stringWithFormat:@"%@", [aAnswer objectForKey:@"ImageID"]];
        
        //NSLog(@"imageID %@", [aAnswer objectForKey:@"ImageID"]);
        
        if ([imageID isEqualToString:@"<null>"]) {
            imageID = @"";
        }
        
        //NSLog(@"imageID %@", imageID);
        
        [arrAnswers addObject:[DataQuestionAnswers answerWithID:[answerId intValue] questionID:aQuestionID answerText:answerText isCorrect:[isCorrect boolValue] answersCount:[answersCount intValue] answerPercent:0.0f imageName:imageName description:description link:link imageID:imageID]];
        
        
    }
    
    for (DataQuestionAnswers *answer in arrAnswers) {
        
        //NSLog(@"answer.answersCount %d", answer.answersCount);
        //NSLog(@"totalAnswers %d", totalAnswers);
        //NSLog(@"answerPercent %f", (float)answer.answersCount / totalAnswers);
        
        if (answer.answersCount == 0 && totalAnswers == 0) {
            answer.answerPercent = 0.0f;
        }
        else if (totalAnswers == 0)
        {
            answer.answerPercent = 0.0f;
        }
        else
        {
            answer.answerPercent = (float)answer.answersCount / totalAnswers;
        }
        
        //NSLog(@"answer.answerPercent %f", answer.answerPercent);
    }
    
    dataReady = YES;


    [nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];

    
	receivedData = nil;
    
}

- (void)loadToLocal:(NSString*)sqlCommand
{
    sqlite3 *db;
	
	if(sqlite3_open([[DataLoad getDBPath] UTF8String], &db) == SQLITE_OK)
	{
        
        const char *sql = [sqlCommand UTF8String];
		//const char *sql = (const char *)sqlCommand;
        //const char *sql = "REPLACE INTO res_string VALUES (17,1,1,'Event Test')";
        
		sqlite3_stmt *stmt;
		
        // NSLog(@"%s", sql);
        
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK)
		{
            if (sqlite3_step(stmt) == SQLITE_DONE)
            {
                //NSLog(@"Successful data operation");
            }
            else
            {
                //NSLog(@"Error updating data operations.");
            }
		}
        else
        {
            //NSLog(@"Error: '%s'", sqlite3_errmsg(db));
        }
		sqlite3_finalize(stmt);
	}
	sqlite3_close(db);
    
    
    
}

- (void)getAnswersFromLocal
{
    sqlite3 *db;
	
	if(sqlite3_open([[DataLoad getDBPath] UTF8String], &db) == SQLITE_OK)
	{
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM pred_Questions_Selections WHERE Question_ID=\"%@\"", questionID];
        
        const char *sql = [querySQL UTF8String];
        
		sqlite3_stmt *stmt;
		
        //NSLog(@"%s", sql);
        
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK)
		{
            [arrAnswers removeAllObjects];
            
            int totalAnswers = 0;
            
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {   
                //answerID
                char *answerIDChars = (char *)sqlite3_column_text(stmt, 0);
                if(answerIDChars == NULL)
                {
                    questionAnswers.answerID = 0;
                }
                else
                {
                    questionAnswers.answerID = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] intValue];
                }
                
                //questionID
                char *questionIDChars = (char *)sqlite3_column_text(stmt, 1);
                if(questionIDChars == NULL)
                {
                    questionAnswers.questionID = @"0";
                }
                else
                {
                    questionAnswers.questionID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                }
                
                //answerText
                char *answerTextChars = (char *)sqlite3_column_text(stmt, 2);
                if(answerTextChars == NULL)
                {
                    questionAnswers.answerText = @"";
                }
                else
                {
                    questionAnswers.answerText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                }

                //isCorrect
                char *isCorrecthars = (char *)sqlite3_column_text(stmt, 3);
                if(isCorrecthars == NULL)
                {
                    questionAnswers.isCorrect = NO;
                }
                else
                {
                    questionAnswers.isCorrect = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] boolValue];
                }
                
                    //answerID
                char *answerCountChars = (char *)sqlite3_column_text(stmt, 4);
                if(answerCountChars == NULL)
                {
                    questionAnswers.answersCount = 0;
                }
                else
                {
                    questionAnswers.answersCount = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)] intValue];
                    
                    totalAnswers = totalAnswers + questionAnswers.answersCount;
                }
                
                //NSLog(@"questionAnswers.answerText %@", questionAnswers.answerText);
                                
                [arrAnswers addObject:[DataQuestionAnswers answerWithID:questionAnswers.answerID questionID:questionAnswers.questionID answerText:questionAnswers.answerText isCorrect:questionAnswers.isCorrect answersCount:questionAnswers.answersCount answerPercent:0.0f imageName:questionAnswers.imageName description:questionAnswers.description link:questionAnswers.link imageID:@"0"]];
            }
            
            //NSLog(@"totalAnswers %d", totalAnswers);
            
            for (DataQuestionAnswers *answer in arrAnswers) {
                
                answer.answerPercent = answer.answersCount / totalAnswers;
                
                //NSLog(@"answer.answerPercent %f", answer.answerPercent);
            }
		}
        else
        {
            //NSLog(@"Error: '%s'", sqlite3_errmsg(db));
        }
		sqlite3_finalize(stmt);
	}
	sqlite3_close(db);
    
    [nc postNotificationName:@"didFinishLoadingQuestionAnswers" object:nil];

}

@end
