//
//  DataQuestions.h
//  predict
//
//  Created by Joel R Ballesteros on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataQuestions : NSObject {    
    
    NSString *questionID;
    NSString *categoryID;
	NSString *questionText;
    int questionPoints;
	NSDate *dateAdded;
	NSDate *dateUpdated;
}

@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *categoryID;
@property (nonatomic, strong)NSString *questionText;
@property (nonatomic, strong)NSDate *dateAdded;
@property (nonatomic, strong)NSDate *dateUpdated;
@property(readwrite)int questionPoints;


+ (DataQuestions *)questionWithID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated;

- (id)initWithQuestionID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated;

@end
