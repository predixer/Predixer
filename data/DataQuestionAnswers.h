//
//  DataQuestionAnswers.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataQuestionAnswers : NSObject {
    
    int answerID;
    NSString *questionID;
	NSString *answerText;
    bool isCorrect;
}

@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *answerText;
@property(assign)bool isCorrect;
@property(readwrite)int answerID;


+ (DataQuestionAnswers *)answerWithID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect;

- (id)initWithAnswerID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect;

@end
