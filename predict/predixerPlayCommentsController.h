//
//  predixerPlayCommentsController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataComments;
@class DataCommentsController;
@class DataQuestions;

@interface predixerPlayCommentsController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
	
    //comments
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    
    NSString *questionID;
    int commentsCount;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (nonatomic, strong)NSString *questionID;
@property (readwrite) int commentsCount;

- (void)getComments;
- (void)didFinishLoadingTopComments;
@end
