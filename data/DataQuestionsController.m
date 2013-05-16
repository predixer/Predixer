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
#import "DataLoad.h"
#import "DataQuestionAnswersController.h"
#import "predixerAppDelegate.h"
#import "Constants.h"

@implementation DataQuestionsController

@synthesize questionsData;
@synthesize categoryID;
@synthesize arrQuestions;

- (id)init {
	if ((self = [super init])) {
        
		if ([arrQuestions count] == 0) {
			arrQuestions = [[NSMutableArray alloc] init];
			questionsData = [[DataQuestions alloc] init];
			receivedData = [[NSMutableData alloc] init];
            
            isGetToday = NO;
            isGetOneQuestion = NO;
            nc = [NSNotificationCenter defaultCenter];

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
    isGetToday = NO;
    isGetOneQuestion = NO;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //NSLog(@"%@", categoryID);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetQuestions?cid=%@&dt=%@", WebServiceSource, categoryID, dateString];
    
    //NSLog(@"%@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrQuestions removeAllObjects];
    
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
	}
}

- (void)getQuestion:(NSString *)questionID
{
    isGetToday = NO;
    isGetOneQuestion = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetQuestionById?qid=%@", WebServiceSource, questionID];
    
    //NSLog(@"%@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];
	[request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[arrQuestions removeAllObjects];
    
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
	}
}

- (void)getQuestionsToday
{
    isGetToday = YES;
    isGetOneQuestion = NO;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
    
    //NSLog(@"%@", categoryID);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *urlString = [NSString stringWithFormat:@"%@GetQuestionsToday?dt=%@", WebServiceSource, dateString];
        
    //NSLog(@"%@", urlString);
    
    NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:escapedUrl]];  
	[request setHTTPMethod:@"GET"];  
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //NSLog(@"%@", [request allHTTPHeaderFields]);
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	
	[arrQuestions removeAllObjects];
    
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
        
        
        if (isGetToday == NO && isGetOneQuestion == NO) {
            [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
        }
        else if (isGetToday == YES && isGetOneQuestion == NO){
            
            [nc postNotificationName:@"didFinishLoadingQuestionsToday" object:nil];
        }
        else if (isGetToday == NO && isGetOneQuestion == YES){
            
            [nc postNotificationName:@"didFinishLoadingQuestion" object:nil];
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
        
    
    if (isGetToday == NO && isGetOneQuestion == NO) {
        [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
    }
    else if (isGetToday == YES && isGetOneQuestion == NO){
        
        [nc postNotificationName:@"didFinishLoadingQuestionsToday" object:nil];
    }
    else if (isGetToday == NO && isGetOneQuestion == YES){
        
        [nc postNotificationName:@"didFinishLoadingQuestion" object:nil];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];   
    
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
   
	//Transform response to string
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	//NSLog(@" JSON Response: %@", response);
	
	//Parse response for JSON values and save to dictionary
	NSDictionary *userInfo = [response JSONValue];
    
    /*
    for (id key in userInfo) {        
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }*/
    
    NSArray *arrObjects = [[NSArray alloc] init];
    
    
    if (isGetToday == NO && isGetOneQuestion == NO) {
        arrObjects = [userInfo objectForKey:@"GetQuestionsResult"];
    }
    else if (isGetToday == YES && isGetOneQuestion == NO){
        
        arrObjects = [userInfo objectForKey:@"GetQuestionsTodayResult"];
        
        if ([arrObjects count] > 0) {
            predixerAppDelegate *appDelegate = (predixerAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.didGetQuestions = YES;
            appDelegate.lastQuestionDate = [NSDate date];
        }
    }
    
    if (isGetToday == NO && isGetOneQuestion == YES)
    {   //FOR ONE QUESTION
        NSDictionary *aQuestion= [userInfo objectForKey:@"GetQuestionByIdResult"];
        
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
        
        questionText = [questionText stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
        
        NSString *questionPoints = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionPoints"]];
        
        if ([questionPoints isEqualToString:@"<null>"]) {
            questionPoints = @"0";
        }
        
        NSString *questionDate = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionDate"]];
        
        if ([questionDate isEqualToString:@"<null>"]) {
            questionDate = [NSString stringWithFormat:@"%@", [NSDate date]];
        }
        
        
        NSString *dateAdded = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"DateAdded"]];
        NSDate *addedDate = [[NSDate alloc] init];
        
        if ([dateAdded isEqualToString:@"<null>"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateAdded = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
            
        }
        else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
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
        
        NSString *imageName = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"ImageName"]];
        
        if ([imageName isEqualToString:@"<null>"]) {
            imageName = @"";
        }
        
        NSString *videoURL = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"VideoURL"]];
        
        if ([videoURL isEqualToString:@"<null>"]) {
            videoURL = @"0";
        }
        
        [arrQuestions addObject:[DataQuestions questionWithID:questionId categoryID:dataCategoryId question:questionText questionPoints:[questionPoints intValue] questionDate:questionDate dateAdded:addedDate dateUpdated:updatedDate imageName:imageName videoURL:videoURL]];
    }
    else{
        
        //FOR ARRAY OF QUESTIONS
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
            
            questionText = [questionText stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
            
            
            NSString *questionPoints = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionPoints"]];
            
            if ([questionPoints isEqualToString:@"<null>"]) {
                questionPoints = @"0";
            }
            
            NSString *questionDate = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"QuestionDate"]];
            
            if ([questionDate isEqualToString:@"<null>"]) {
                questionDate = [NSString stringWithFormat:@"%@", [NSDate date]];
            }

            NSString *dateAdded = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"DateAdded"]];
            NSDate *addedDate = [[NSDate alloc] init];
            
            if ([dateAdded isEqualToString:@"<null>"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateAdded = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
                
            }
            else {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
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
            
            NSString *imageName = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"ImageName"]];
            
            if ([imageName isEqualToString:@"<null>"]) {
                imageName = @"";
            }
            
            NSString *videoURL = [NSString stringWithFormat:@"%@", [aQuestion objectForKey:@"VideoURL"]];
            
            if ([videoURL isEqualToString:@"<null>"]) {
                videoURL = @"0";
            }
            
            [arrQuestions addObject:[DataQuestions questionWithID:questionId categoryID:dataCategoryId question:questionText questionPoints:[questionPoints intValue] questionDate:questionDate dateAdded:addedDate dateUpdated:updatedDate imageName:imageName videoURL:videoURL]];
        }
    }
    
    
	
   if (isGetToday == NO && isGetOneQuestion == NO) {
        [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
   }
   else if (isGetToday == NO && isGetOneQuestion == YES){
       
       [nc postNotificationName:@"didFinishLoadingQuestion" object:nil];
   }
    else if (isGetToday == YES && isGetOneQuestion == NO)
    {
        
        if ([arrQuestions count] > 0 || [arrQuestions count] == 0) {
            
            //delete data first
            NSString *deleteSQL = @"DELETE FROM pred_Questions";
            [self loadToLocal:deleteSQL];
            
            
            NSString *deleteAnswerSQL = @"DELETE FROM pred_Questions_Selections";
            [self loadToLocal:deleteAnswerSQL];
            
        }
        
        for (DataQuestions *questions in arrQuestions) {
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO pred_Questions (Questions_ID, Category_ID, Question, QuestionPoints, QuestionDate, DateAdded, DateUpdated, ImageName, VideoURL) VALUES (\"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", questions.questionID, questions.categoryID, questions.questionText, questions.questionPoints, questions.questionDate, questions.dateAdded, questions.dateUpdated, questions.imageName, questions.videoURL];
           
            //NSLog(@"insertSQL %@",insertSQL);
            
            [self loadToLocal:insertSQL];
            
            //GET ANSWERS
            //DataQuestionAnswersController *answers = [[DataQuestionAnswersController alloc] init];

            //answers.questionID = questions.questionID;
            //[answers getAnswers];
            
            
            
            [nc postNotificationName:@"didFinishLoadingQuestionsToday" object:nil];
        }
    }
    
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
		
        //NSLog(@"%s", sql);
        
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

- (void)getQuestionsFromLocal
{
    sqlite3 *db;
	
	if(sqlite3_open([[DataLoad getDBPath] UTF8String], &db) == SQLITE_OK)
	{
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM pred_Questions WHERE Category_ID=\"%@\"", categoryID];
        
        const char *sql = [querySQL UTF8String];        
        
		sqlite3_stmt *stmt;
		
        // NSLog(@"%s", sql);
        
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK)
		{
            [arrQuestions removeAllObjects];
            
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                
                //questionID
                char *questionIDChars = (char *)sqlite3_column_text(stmt, 0);
                if(questionIDChars == NULL)
                {
                    questionsData.questionID = 0;
                }
                else
                {
                    questionsData.questionID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                }
                
                //categoryID
                char *categoryIDChars = (char *)sqlite3_column_text(stmt, 1);
                if(categoryIDChars == NULL)
                {
                    questionsData.categoryID = 0;
                }
                else
                {
                    questionsData.categoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                }
                
                //questionText
                char *questionTextChars = (char *)sqlite3_column_text(stmt, 2);
                if(questionTextChars == NULL)
                {
                    questionsData.questionText = @"";
                }
                else
                {
                    questionsData.questionText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                }
                
                //questionPoints
                char *questionPointsChars = (char *)sqlite3_column_text(stmt, 3);
                if(questionPointsChars == NULL)
                {
                    questionsData.questionPoints = 0;
                }
                else
                {
                    questionsData.questionPoints = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] intValue];
                }
                
                //questionDate
                char *questionDateChars = (char *)sqlite3_column_text(stmt, 4);
                if(questionDateChars == NULL)
                {
                    questionsData.questionDate = 0;
                }
                else
                {
                    questionsData.questionDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                    
                }
                
                //dateAdded
                char *dateAddedChars = (char *)sqlite3_column_text(stmt, 5);
                if(dateAddedChars == NULL)
                {
                    questionsData.dateAdded = 0;
                }
                else
                {
                    questionsData.dateAdded = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                }
                
                //dateUpdated
                char *dateUpdatedChars = (char *)sqlite3_column_text(stmt, 6);
                if(dateUpdatedChars == NULL)
                {
                    questionsData.dateUpdated = 0;
                }
                else
                {
                    questionsData.dateUpdated = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                }
                
                //questionText
                char *imageTextChars = (char *)sqlite3_column_text(stmt, 7);
                if(imageTextChars == NULL)
                {
                    questionsData.imageName = @"";
                }
                else
                {
                    questionsData.imageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                }
                
                char *videoURLChars = (char *)sqlite3_column_text(stmt, 8);
                if(videoURLChars == NULL)
                {
                    questionsData.videoURL = @"";
                }
                else
                {
                    questionsData.videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
                }
                
                [arrQuestions addObject:[DataQuestions questionWithID:questionsData.questionID categoryID:questionsData.categoryID question:questionsData.questionText questionPoints:questionsData.questionPoints questionDate:questionsData.questionDate dateAdded:questionsData.dateAdded dateUpdated:questionsData.dateUpdated imageName:questionsData.imageName videoURL:questionsData.videoURL]];
            }
		}
        else
        {
            //NSLog(@"Error: '%s'", sqlite3_errmsg(db));
        }
		sqlite3_finalize(stmt);
	}
	sqlite3_close(db);
    
    [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
}

- (void)getQuestionsFromDB
{
    sqlite3 *db;
	
	if(sqlite3_open([[DataLoad getDBPath] UTF8String], &db) == SQLITE_OK)
	{
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM pred_Questions"];
        
        const char *sql = [querySQL UTF8String];
        
		sqlite3_stmt *stmt;
		
        //NSLog(@"%s", sql);
        
		if(sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK)
		{
            [arrQuestions removeAllObjects];
            
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                
                //questionID
                char *questionIDChars = (char *)sqlite3_column_text(stmt, 0);
                if(questionIDChars == NULL)
                {
                    questionsData.questionID = 0;
                }
                else
                {
                    questionsData.questionID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                }
                
                //categoryID
                char *categoryIDChars = (char *)sqlite3_column_text(stmt, 1);
                if(categoryIDChars == NULL)
                {
                    questionsData.categoryID = 0;
                }
                else
                {
                    questionsData.categoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                }
                
                //questionText
                char *questionTextChars = (char *)sqlite3_column_text(stmt, 2);
                if(questionTextChars == NULL)
                {
                    questionsData.questionText = @"";
                }
                else
                {
                    questionsData.questionText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                }
                
                //questionPoints
                char *questionPointsChars = (char *)sqlite3_column_text(stmt, 3);
                if(questionPointsChars == NULL)
                {
                    questionsData.questionPoints = 0;
                }
                else
                {
                    questionsData.questionPoints = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)] intValue];
                }
                
                //questionDate
                char *questionDateChars = (char *)sqlite3_column_text(stmt, 4);
                if(questionDateChars == NULL)
                {
                    questionsData.questionDate = 0;
                }
                else
                {
                    questionsData.questionDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                    
                    //NSLog(@" questionDate %@", questionsData.questionDate);
                }
                
                //dateAdded
                char *dateAddedChars = (char *)sqlite3_column_text(stmt, 5);
                if(dateAddedChars == NULL)
                {
                    questionsData.dateAdded = 0;
                }
                else
                {
                    questionsData.dateAdded = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                }
                
                //dateUpdated
                char *dateUpdatedChars = (char *)sqlite3_column_text(stmt, 6);
                if(dateUpdatedChars == NULL)
                {
                    questionsData.dateUpdated = 0;
                }
                else
                {
                    questionsData.dateUpdated = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                }
                
                //questionText
                char *imageTextChars = (char *)sqlite3_column_text(stmt, 7);
                if(imageTextChars == NULL)
                {
                    questionsData.imageName = @"";
                }
                else
                {
                    questionsData.imageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                }
                
                char *videoURLChars = (char *)sqlite3_column_text(stmt, 8);
                if(videoURLChars == NULL)
                {
                    questionsData.videoURL = @"";
                }
                else
                {
                    questionsData.videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
                }
                
                //NSLog(@"%@, %@",questionsData.questionID, questionsData.questionText);
                
                [arrQuestions addObject:[DataQuestions questionWithID:questionsData.questionID categoryID:questionsData.categoryID question:questionsData.questionText questionPoints:questionsData.questionPoints questionDate:questionsData.questionDate dateAdded:questionsData.dateAdded dateUpdated:questionsData.dateUpdated imageName:questionsData.imageName videoURL:questionsData.videoURL]];
            }
		}
        else
        {
            //NSLog(@"Error: '%s'", sqlite3_errmsg(db));
        }
		sqlite3_finalize(stmt);
	}
	sqlite3_close(db);
    
    [nc postNotificationName:@"didFinishLoadingQuestions" object:nil];
}

@end
