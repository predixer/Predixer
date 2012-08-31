//
//  DataQuestionsController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataQuestions;

@interface DataQuestionsController : NSObject {
    
    DataQuestions *questionsData;
    NSMutableArray *arrQuestions;
    NSMutableData *receivedData;
    NSString *categoryID;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;

}

@property (nonatomic, strong)DataQuestions *questionsData;
@property (nonatomic, strong)NSString *categoryID;


- (void)getQuestions;
- (unsigned)countOfList;
- (DataQuestions *)objectInListAtIndex:(unsigned)theIndex;

@end
