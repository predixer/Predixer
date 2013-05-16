//
//  DataTopComments.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@interface DataTopComments : NSObject {
    
    int commentID;
    int questionID;
    NSString *fbUserID;
	NSString *comment;
	NSDate *commentDate;
	NSString *question;
	int questionPoints;
	NSDate *questionDate;
	int totalLikes;
}

@property(readwrite)int commentID;
@property(readwrite)int questionID;
@property (nonatomic, strong)NSString *fbUserID;
@property (nonatomic, strong)NSString *comment;
@property (nonatomic, strong)NSDate *commentDate;
@property (nonatomic, strong)NSString *question;
@property(readwrite)int questionPoints;
@property (nonatomic, strong)NSDate *questionDate;
@property(readwrite)int totalLikes;


+ (DataTopComments *)commentWithID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID comment:(NSString *)aComment commentDate:(NSDate *)aCommentDate question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints questionDate:(NSDate *)aQuestionDate totalLikes:(int)aTotalLikes;

- (id)initWithCommentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID comment:(NSString *)aComment commentDate:(NSDate *)aCommentDate question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints questionDate:(NSDate *)aQuestionDate totalLikes:(int)aTotalLikes;

@end
