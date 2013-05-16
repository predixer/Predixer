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
	NSString *questionDate;
	NSDate *dateAdded;
	NSDate *dateUpdated;
	NSString *imageName;
	NSString *videoURL;
}

@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *categoryID;
@property (nonatomic, strong)NSString *questionText;
@property (nonatomic, strong)NSString *questionDate;
@property (nonatomic, strong)NSDate *dateAdded;
@property (nonatomic, strong)NSDate *dateUpdated;
@property(readwrite)int questionPoints;
@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, strong)NSString *videoURL;


+ (DataQuestions *)questionWithID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints questionDate:(NSString *)aQuestionDate dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated imageName:(NSString *)aImageName videoURL:(NSString *)aVideoURL;

- (id)initWithQuestionID:(NSString *)aQuestionID categoryID:(NSString *)aCategoryID question:(NSString *)aQuestionText questionPoints:(int)aQuestionPoints questionDate:(NSString *)aQuestionDate dateAdded:(NSDate *)aDateAdded dateUpdated:(NSDate *)aDateUpdated imageName:(NSString *)aImageName videoURL:(NSString *)aVideoURL;

@end
