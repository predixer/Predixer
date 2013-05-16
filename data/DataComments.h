//
//  DataComments.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataComments : NSObject {    
    
    NSString *commentID;
    NSString *questionID;
	NSString *userID;
    NSString *fbUserID;
	NSString *fbName;
	NSString *fbUserEmail;
	NSString *comment;
	NSString *commentDate;
	NSString *totalLikes;
	NSString *totalComments;
}

@property (nonatomic, strong)NSString *commentID;
@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic, strong)NSString *fbUserID;
@property (nonatomic, strong)NSString *fbName;
@property (nonatomic, strong)NSString *fbUserEmail;
@property (nonatomic, strong)NSString *comment;
@property (nonatomic, strong)NSString *commentDate;
@property (nonatomic, strong)NSString *totalLikes;
@property (nonatomic, strong)NSString *totalComments;


+ (DataComments *)commentWithID:(NSString *)aCommentID questionID:(NSString *)aQuestionID userID:(NSString *)aUserID fbUserID:(NSString *)aFbUserID fbName:(NSString *)aFbName fbUserEmail:(NSString *)aFbUserEmail comment:(NSString *)aComment commentDate:(NSString *)aCommentDate totalLikes:(NSString *)aTotalLikes totalComments:(NSString *)aTotalComments;

- (id)initWithCommentID:(NSString *)aCommentID questionID:(NSString *)aQuestionID userID:(NSString *)aUserID fbUserID:(NSString *)aFbUserID fbName:(NSString *)aFbName fbUserEmail:(NSString *)aFbUserEmail comment:(NSString *)aComment commentDate:(NSString *)aCommentDate totalLikes:(NSString *)aTotalLikes totalComments:(NSString *)aTotalComments;

@end
