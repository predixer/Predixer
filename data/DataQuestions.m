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
@synthesize questionDate;
@synthesize imageName;
@synthesize videoURL;

+ (DataQuestions *)questionWithID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints questionDate:(NSString *)aQuestionDate dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated imageName:(NSString *)aImageName videoURL:(NSString *)aVideoURL {
    
    return [[DataQuestions alloc] initWithQuestionID:aQuestionID categoryID:aCategoryID question:aQuestionText questionPoints:aQuestionPoints questionDate:aQuestionDate dateAdded:aDateAdded dateUpdated:aDateUpdated imageName:aImageName videoURL:aVideoURL];
    
}

- (id)initWithQuestionID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints questionDate:(NSString *)aQuestionDate dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated imageName:(NSString *)aImageName videoURL:(NSString *)aVideoURL{
    
    if ((self = [super init])) {		
        questionID = [aQuestionID copy];
        categoryID = [aCategoryID copy];
		questionText = [aQuestionText copy];
		questionPoints = aQuestionPoints;
        questionDate = [aQuestionDate copy];
		dateAdded = [aDateAdded copy];
		dateUpdated = [aDateUpdated copy];
        imageName = [aImageName copy];
        videoURL = [aVideoURL copy];
	}
	return self;
    
}

@end
