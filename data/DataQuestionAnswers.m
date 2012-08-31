//
//  DataQuestionAnswers.m
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataQuestionAnswers.h"

@implementation DataQuestionAnswers

@synthesize answerID;
@synthesize questionID;
@synthesize answerText;
@synthesize isCorrect;

+ (DataQuestionAnswers *)answerWithID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect {
    
    return [[DataQuestionAnswers alloc] initWithAnswerID:aAnswerID questionID:aQuestionID answerText:aAnswerText isCorrect:aIsCorrect];
    
}

- (id)initWithAnswerID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect {
    
    if ((self = [super init])) {		
        
        answerID = aAnswerID;
        questionID = [aQuestionID copy];
		answerText = [aAnswerText copy];	
		isCorrect = aIsCorrect;
	}
	return self;
    
}


@end
