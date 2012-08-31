//
//  DataUserQuestionAnswer.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUserQuestionAnswer : NSObject {
    
    int answerID;
    NSString *userID;
    NSString *fbUserID;
    int questionID;
	int answerSelectionID;
    NSString *answerDate;
}


@property(readwrite)int answerID;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic, strong)NSString *fbUserID;
@property(readwrite)int questionID;
@property(readwrite)int answerSelectionID;
@property (nonatomic, strong)NSString *answerDate;


+ (DataUserQuestionAnswer *)answerWithID:(int)aAnswerID userID:(NSString *)aUserID fbUserID:(NSString *)aFBUserID questionID:(int)aQuestionID answerSelectionID:(int)aAnswerSelectionID answerDate:(NSString *)aAnswerDate;

- (id)initWithAnswerID:(int)aAnswerID userID:(NSString *)aUserID fbUserID:(NSString *)aFBUserID questionID:(int)aQuestionID answerSelectionID:(int)aAnswerSelectionID answerDate:(NSString *)aAnswerDate;

@end
