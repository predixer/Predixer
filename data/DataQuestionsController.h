//
//  DataQuestionsController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class DataQuestions;

@interface DataQuestionsController : NSObject {
    
    DataQuestions *questionsData;
    NSMutableArray *arrQuestions;
    NSMutableData *receivedData;
    NSString *categoryID;
    
    BOOL isGetToday;
    BOOL isGetOneQuestion;
    
    NSNotificationCenter *nc;

}

@property (nonatomic, strong)DataQuestions *questionsData;
@property (nonatomic, strong)NSString *categoryID;
@property (nonatomic, strong)NSMutableArray *arrQuestions;


- (void)getQuestions;
- (void)getQuestionsToday;
- (void)getQuestion:(NSString *)questionID;
- (unsigned)countOfList;
- (DataQuestions *)objectInListAtIndex:(unsigned)theIndex;
- (void)loadToLocal:(NSString*)sqlCommand;
- (void)getQuestionsFromLocal;
- (void)getQuestionsFromDB;

@end
