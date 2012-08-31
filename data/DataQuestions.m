//
//  DataQuestions.m
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataQuestions.h"

@implementation DataQuestions

@synthesize questionID;
@synthesize categoryID;
@synthesize questionText;
@synthesize dateAdded;
@synthesize dateUpdated;
@synthesize questionPoints;

+ (DataQuestions *)questionWithID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated {
    
    return [[DataQuestions alloc] initWithQuestionID:aQuestionID categoryID:aCategoryID question:aQuestionText questionPoints:aQuestionPoints dateAdded:aDateAdded dateUpdated:aDateUpdated];
    
}

- (id)initWithQuestionID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated {
    
    if ((self = [super init])) {		
        questionID = [aQuestionID copy];
        categoryID = [aCategoryID copy];
		questionText = [aQuestionText copy];	
		questionPoints = aQuestionPoints;
		dateAdded = [aDateAdded copy];
		dateUpdated = [aDateUpdated copy];	
	}
	return self;
    
}

@end
