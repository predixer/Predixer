//
//  DataUserAnswers.h
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@interface DataUserAnswers : NSObject {
    
    NSString *fbUserID;
    int categoryID;
    NSString *categoryName;
    int questionID;
    NSString *question;
    int questionPoints;
    int answerID;
    int answerSelectionID;
    NSString *answerOption;
    NSDate *answerDate;
    bool isCorrect;
    bool isAnswerSet;
}

@property (nonatomic, strong)NSString *fbUserID;
@property(readwrite)int categoryID;
@property (nonatomic, strong)NSString *categoryName;
@property(readwrite)int questionID;
@property (nonatomic, strong)NSString *question;
@property(readwrite)int questionPoints;
@property(readwrite)int answerID;
@property(readwrite)int answerSelectionID;
@property (nonatomic, strong)NSString *answerOption;
@property (nonatomic, strong)NSDate *answerDate;
@property(assign)bool isCorrect;
@property(assign)bool isAnswerSet;


+ (DataUserAnswers *)answerWithID:(int)aAnswerID answerSelectionID:(int)aAnswerSelectionID answerOption:(NSString *)aAnswerOption isCorrect:(bool)aIsCorrect answerDate:(NSDate *)aAnswerDate fbUserID:(NSString *)aFbUserID categoryID:(int)aCategoryID categoryName:(NSString *)aCategoryName questionID:(int)aQuestionID question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints isAnswerSet:(bool)aIsAnswerSet;

- (id)initWithAnswerID:(int)aAnswerID answerSelectionID:(int)aAnswerSelectionID answerOption:(NSString *)aAnswerOption isCorrect:(bool)aIsCorrect answerDate:(NSDate *)aAnswerDate fbUserID:(NSString *)aFbUserID categoryID:(int)aCategoryID categoryName:(NSString *)aCategoryName questionID:(int)aQuestionID question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints isAnswerSet:(bool)aIsAnswerSet;

@end
