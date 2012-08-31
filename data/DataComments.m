//
//  DataComments.m
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataComments.h"

@implementation DataComments

@synthesize commentID;
@synthesize questionID;
@synthesize userID;
@synthesize fbUserID;
@synthesize fbName;
@synthesize fbUserEmail;
@synthesize comment;
@synthesize commentDate;
@synthesize totalLikes;

+ (DataComments *)commentWithID:(NSString *)aCommentID questionID:(NSString *)aQuestionID userID:(NSString *)aUserID fbUserID:(NSString *)aFbUserID fbName:(NSString *)aFbName fbUserEmail:(NSString *)aFbUserEmail comment:(NSString *)aComment commentDate:(NSString *)aCommentDate totalLikes:(NSString *)aTotalLikes {
    
    return [[DataComments alloc] initWithCommentID:aCommentID questionID:aQuestionID userID:aUserID fbUserID:aFbUserID fbName:aFbName fbUserEmail:aFbUserEmail comment:aComment commentDate:aCommentDate totalLikes:aTotalLikes];
    
}

- (id)initWithCommentID:(NSString *)aCommentID questionID:(NSString *)aQuestionID userID:(NSString *)aUserID fbUserID:(NSString *)aFbUserID fbName:(NSString *)aFbName fbUserEmail:(NSString *)aFbUserEmail comment:(NSString *)aComment commentDate:(NSString *)aCommentDate totalLikes:(NSString *)aTotalLikes {
    
    if ((self = [super init])) {
        commentID = [aCommentID copy];
        questionID = [aQuestionID copy];
        userID = [aUserID copy];
		fbUserID = [aFbUserID copy];	
		fbName = [aFbName copy];
		fbUserEmail = [aFbUserEmail copy];
		comment = [aComment copy];
		commentDate = [aCommentDate copy];
        totalLikes = [aTotalLikes copy];
	}
	return self;
    
}

@end
