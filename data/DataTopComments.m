//
//  DataTopComments.m
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import "DataTopComments.h"

@implementation DataTopComments

@synthesize commentID;
@synthesize questionID;
@synthesize fbUserID;
@synthesize comment;
@synthesize commentDate;
@synthesize question;
@synthesize questionPoints;
@synthesize questionDate;
@synthesize totalLikes;

+ (DataTopComments *)commentWithID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID comment:(NSString *)aComment commentDate:(NSDate *)aCommentDate question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints questionDate:(NSDate *)aQuestionDate totalLikes:(int)aTotalLikes {
    
    return [[DataTopComments alloc] initWithCommentID:aCommentID questionID:aQuestionID fbUserID:aFbUserID comment:aComment commentDate:aCommentDate question:aQuestion questionPoints:aQuestionPoints questionDate:aQuestionDate totalLikes:aTotalLikes];
    
}

- (id)initWithCommentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID comment:(NSString *)aComment commentDate:(NSDate *)aCommentDate question:(NSString *)aQuestion questionPoints:(int)aQuestionPoints questionDate:(NSDate *)aQuestionDate totalLikes:(int)aTotalLikes {
    
    if ((self = [super init])) {
        
        fbUserID = [aFbUserID copy];
        questionID = aQuestionID;
        question = [aQuestion copy];
        questionPoints = aQuestionPoints;
        
        commentID = aCommentID;
        comment = [aComment copy];;
        commentDate = [aCommentDate copy];
        questionDate = [aQuestionDate copy];
        totalLikes = aTotalLikes;
        
	}
	return self;
    
}

@end
