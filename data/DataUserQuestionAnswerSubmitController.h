//
//  DataUserQuestionAnswerSubmit.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUserQuestionAnswerSubmitController : NSObject
{
    NSMutableData *receivedData;
    NSString *questionId;
    NSString *answerId;
    
    BOOL dataReady;
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)NSString *questionId;
@property (nonatomic, strong)NSString *answerId;

- (void)submitQuestionAnswer;
- (void)submitUserAnswer;
@end
