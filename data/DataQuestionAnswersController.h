//
//  DataQuestionAnswersController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class DataQuestionAnswers;

@interface DataQuestionAnswersController : NSObject {
    
    DataQuestionAnswers *questionAnswers;
    NSMutableArray *arrAnswers;
    NSMutableData *receivedData;
    NSString *questionID;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;
    BOOL isGetHistory;
    
}

@property (nonatomic, strong)DataQuestionAnswers *questionAnswers;
@property (nonatomic, strong)NSMutableArray *arrAnswers;
@property (nonatomic, strong)NSString *questionID;
@property (readwrite)BOOL isGetHistory;


- (void)getAnswers;
- (unsigned)countOfList;
- (DataQuestionAnswers *)objectInListAtIndex:(unsigned)theIndex;
- (void)loadToLocal:(NSString*)sqlCommand;
- (void)getAnswersFromLocal;

@end
