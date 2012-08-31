//
//  DataQuestionAnswersController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataQuestionAnswers;

@interface DataQuestionAnswersController : NSObject {
    
    DataQuestionAnswers *questionAnswers;
    NSMutableArray *arrAnswers;
    NSMutableData *receivedData;
    NSString *questionID;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataQuestionAnswers *questionAnswers;
@property (nonatomic, strong)NSString *questionID;


- (void)getAnswers;
- (unsigned)countOfList;
- (DataQuestionAnswers *)objectInListAtIndex:(unsigned)theIndex;

@end
