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
    int answersCount;
    float answerPercent;
	NSString *imageName;
    NSString *description;
    NSString *link;
    NSString *imageID;
}

@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *answerText;
@property(assign)bool isCorrect;
@property(readwrite)int answerID;
@property(readwrite)int answersCount;
@property(readwrite)float answerPercent;
@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSString *link;
@property (nonatomic, strong)NSString *imageID;


+ (DataQuestionAnswers *)answerWithID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect answersCount:(int)aAnswersCount answerPercent:(float)aAnswerPercent imageName:(NSString *)aImageName description:(NSString *)aDescription link:(NSString *)aLink imageID:(NSString *)aImageID;

- (id)initWithAnswerID:(int)aAnswerID questionID:(NSString *)aQuestionID answerText:(NSString *)aAnswerText isCorrect:(bool)aIsCorrect answersCount:(int)aAnswersCount answerPercent:(float)aAnswerPercent imageName:(NSString *)aImageName description:(NSString *)aDescription link:(NSString *)aLink imageID:(NSString *)aImageID;

@end
