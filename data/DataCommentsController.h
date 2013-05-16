//
//  DataCommentsController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataComments;

@interface DataCommentsController : NSObject {
    
    DataComments *commentsData;
    NSMutableArray *arrComments;
    NSMutableData *receivedData;
    NSString *questionID;
    NSString *pageNumber;
    NSString *commentID;
    
    BOOL dataReady;
    BOOL isLike;
    BOOL isTopComments;
    BOOL isUserCommentLike;
    BOOL userDidLike;
    BOOL isAddNewComment;
    
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataComments *commentsData;
@property (nonatomic, strong)NSMutableArray *arrComments;
@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *pageNumber;
@property (nonatomic, strong)NSString *commentID;
@property (readwrite)BOOL userDidLike;
@property (readwrite)BOOL isAddNewComment;

- (void)likeComment;
- (void)getTopComments;
- (void)getComments;
- (void)getUserCommentLike;
- (unsigned)countOfList;
- (DataComments *)objectInListAtIndex:(unsigned)theIndex;


@end
