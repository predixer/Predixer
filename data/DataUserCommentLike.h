//
//  DataUserCommentLike.h
//  predict
//
//  Created by Joel R Ballesteros on 10/11/12.
//
//

#import <Foundation/Foundation.h>

@interface DataUserCommentLike : NSObject {
    
    int commentLikeID;
    int commentID;
    int questionID;
    NSString *fbUserID;
	NSDate *likeDate;
}

@property(readwrite)int commentLikeID;
@property(readwrite)int commentID;
@property(readwrite)int questionID;
@property (nonatomic, strong)NSString *fbUserID;
@property (nonatomic, strong)NSDate *likeDate;


+ (DataUserCommentLike *)commentLikeWithID:(int)aCommentLikeID commentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID likeDate:(NSDate *)aLikeDate;

- (id)initWithCommentLikeID:(int)aCommentLikeID commentID:(int)aCommentID questionID:(int)aQuestionID fbUserID:(NSString *)aFbUserID likeDate:(NSDate *)aLikeDate;


@end
