//
//  DataUserQuestionAnswerController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataUserQuestionAnswer;

@interface DataUserQuestionAnswerController : NSObject {
    
    DataUserQuestionAnswer *questionAnswer;
     NSMutableArray *arrAnswer;
    NSMutableData *receivedData;
    NSString *questionID;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataUserQuestionAnswer *questionAnswer;
@property (nonatomic, strong)NSString *questionID;


- (void)getAnswer;
- (unsigned)countOfList;
- (DataUserQuestionAnswer *)objectInListAtIndex:(unsigned)theIndex;

@end
