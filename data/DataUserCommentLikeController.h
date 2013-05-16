//
//  DataUserCommentLikeController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/11/12.
//
//

#import <Foundation/Foundation.h>

@class DataUserCommentLike;

@interface DataUserCommentLikeController : NSObject {
    
    DataUserCommentLike *dataUserCommentLike;
    NSMutableArray *arrComments;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong) DataUserCommentLike *dataUserCommentLike;
@property (nonatomic, strong) NSMutableArray *arrComments;

- (void)getUserCommentsLikes:(NSString *)questionID;
- (unsigned)countOfList;
- (DataUserCommentLike *)objectInListAtIndex:(unsigned)theIndex;


@end
