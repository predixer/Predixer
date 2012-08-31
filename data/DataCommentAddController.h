//
//  DataCommentAddController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataComments;

@interface DataCommentAddController : NSObject
{
    NSMutableData *receivedData;
    NSString *questionID;
    NSString *commentText;
    
    BOOL dataReady;
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataComments *questionComments;
@property (nonatomic, strong)NSString *questionID;
@property (nonatomic, strong)NSString *commentText;

- (void)addUserComment;


@end
