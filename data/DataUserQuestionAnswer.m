//
//  DataUserQuestionAnswer.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataUserQuestionAnswer.h"

@implementation DataUserQuestionAnswer

@synthesize answerID;
@synthesize userID;
@synthesize fbUserID;
@synthesize questionID;
@synthesize answerSelectionID;
@synthesize answerDate;

+ (DataUserQuestionAnswer *)answerWithID:(int)aAnswerID userID:(NSString *)aUserID fbUserID:(NSString *)aFBUserID questionID:(int)aQuestionID answerSelectionID:(int)aAnswerSelectionID answerDate:(NSString *)aAnswerDate {
    
    return [[DataUserQuestionAnswer alloc] initWithAnswerID:aAnswerID userID:aUserID fbUserID:aFBUserID questionID:aQuestionID answerSelectionID:aAnswerSelectionID answerDate:aAnswerDate];
    
}

- (id)initWithAnswerID:(int)aAnswerID userID:(NSString *)aUserID fbUserID:(NSString *)aFBUserID questionID:(int)aQuestionID answerSelectionID:(int)aAnswerSelectionID answerDate:(NSString *)aAnswerDate {
    
    if ((self = [super init])) {		
        
        answerID = aAnswerID;
        userID = [aUserID copy];
        fbUserID = [aFBUserID copy];
        questionID = aQuestionID;
		answerSelectionID = aAnswerSelectionID;
		answerDate = [aAnswerDate copy];
	}
	return self;
    
}

@end
