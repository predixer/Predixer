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
@synthesize answersCount;
@synthesize answerPercent;
@synthesize imageName;
@synthesize description;
@synthesize link;
@synthesize imageID;

+ (DataQuestionAnswers *)answerWithID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect answersCount:(int)aAnswersCount answerPercent:(float)aAnswerPercent imageName:(NSString *)aImageName description:(NSString *)aDescription link:(NSString *)aLink imageID:(NSString *)aImageID {
    
    return [[DataQuestionAnswers alloc] initWithAnswerID:aAnswerID questionID:aQuestionID answerText:aAnswerText isCorrect:aIsCorrect answersCount:aAnswersCount answerPercent:aAnswerPercent imageName:aImageName description:aDescription link:aLink imageID:aImageID];
    
}

- (id)initWithAnswerID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect answersCount:(int)aAnswersCount answerPercent:(float)aAnswerPercent imageName:(NSString *)aImageName description:(NSString *)aDescription link:(NSString *)aLink imageID:(NSString *)aImageID {
    
    if ((self = [super init])) {		
        
        answerID = aAnswerID;
        questionID = [aQuestionID copy];
		answerText = [aAnswerText copy];	
		isCorrect = aIsCorrect;
        answersCount = aAnswersCount;
        answerPercent = aAnswerPercent;
        imageName = [aImageName copy];
        description = [aDescription copy];
        link = [aLink copy];
        imageID = [aImageID copy];
	}
	return self;
    
}


@end
