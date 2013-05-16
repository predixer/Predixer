//
//  DataUserCommentLike.m
//  predict
//
//  Created by Joel R Ballesteros on 10/11/12.
//
//

#import "DataUserCommentLike.h"

@implementation DataUserCommentLike

@synthesize commentID;
@synthesize questionID;
@synthesize fbUserID;
@synthesize likeDate;
@synthesize commentLikeID;

+ (DataUserCommentLike *)commentLikeWithID:(int)aCommentLikeID commentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID likeDate:(NSDate *)aLikeDate {
    
    return [[DataUserCommentLike alloc] initWithCommentLikeID:aCommentLikeID commentID:aCommentID questionID:aQuestionID fbUserID:aFbUserID likeDate:aLikeDate];
    
}

- (id)initWithCommentLikeID:(int)aCommentLikeID commentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID likeDate:(NSDate *)aLikeDate {
    
    if ((self = [super init])) {
        
        fbUserID = [aFbUserID copy];
        questionID = aQuestionID;
        commentLikeID = aCommentLikeID;
        commentID = aCommentID;
        likeDate = [aLikeDate copy];        
	}
	return self;
    
}

@end
