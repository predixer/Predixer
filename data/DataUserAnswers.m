//
//  DataUserAnswers.m
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import "DataUserAnswers.h"

@implementation DataUserAnswers

@synthesize fbUserID;
@synthesize categoryID;
@synthesize categoryName;
@synthesize questionID;
@synthesize question;
@synthesize questionPoints;
@synthesize answerID;
@synthesize answerSelectionID;
@synthesize answerOption;
@synthesize answerDate;
@synthesize isCorrect;
@synthesize isAnswerSet;

+ (DataUserAnswers *)answerWithID:(int)aAnswerID answerSelectionID:(int)aAnswerSelectionID answerOption:(NSString *)aAnswerOption isCorrect:(bool)aIsCorrect answerDate:(NSDate *)aAnswerDate fbUserID:(NSString *)aFbUserID categoryID:(int)aCategoryID categoryName:(NSString *)aCategoryName questionID:(int)aQuestionID question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints isAnswerSet:(bool)aIsAnswerSet{
    
    return [[DataUserAnswers alloc] initWithAnswerID:aAnswerID answerSelectionID:aAnswerSelectionID answerOption:aAnswerOption isCorrect:aIsCorrect answerDate:aAnswerDate fbUserID:aFbUserID categoryID:aCategoryID categoryName:aCategoryName questionID:aQuestionID question:aQuestion questionPoints:aQuestionPoints isAnswerSet:aIsAnswerSet];
    
}

- (id)initWithAnswerID:(int)aAnswerID answerSelectionID:(int)aAnswerSelectionID answerOption:(NSString *)aAnswerOption isCorrect:(bool)aIsCorrect answerDate:(NSDate *)aAnswerDate fbUserID:(NSString *)aFbUserID categoryID:(int)aCategoryID categoryName:(NSString *)aCategoryName questionID:(int)aQuestionID question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints isAnswerSet:(bool)aIsAnswerSet {
    
    if ((self = [super init])) {
        
        fbUserID = [aFbUserID copy];
        categoryID = aCategoryID;
        categoryName = [aCategoryName copy];
        questionID = aQuestionID;
        question = [aQuestion copy];
        questionPoints = aQuestionPoints;
        answerID = aAnswerID;
        answerSelectionID = aAnswerSelectionID;
        answerOption = [aAnswerOption copy];
        answerDate = [aAnswerDate copy];
		isCorrect = aIsCorrect;
        isAnswerSet = aIsAnswerSet;
        
	}
	return self;
    
}

@end
