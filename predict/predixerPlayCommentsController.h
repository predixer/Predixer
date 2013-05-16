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
@class LoadingController;

@interface predixerPlayCommentsController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
	
    //comments
    DataComments *dataComments;
    DataCommentsController *commentsDataController;
    DataQuestions *dataQuestion;
    LoadingController *loadingController;
    
    NSString *questionID;
    int commentsCount;
    NSMutableArray *arrLineHeight;
    
    UIAlertView *baseAlert;
	UIActivityIndicatorView *aiv;
    
    NSNotificationCenter *nc;
    
     int pageNumber;
}

@property (nonatomic, strong)DataComments *dataComments;
@property (nonatomic, strong)DataCommentsController *commentsDataController;
@property (nonatomic, strong)DataQuestions *dataQuestion;
@property (strong, nonatomic) LoadingController *loadingController;
@property (nonatomic, strong)NSString *questionID;
@property (readwrite) int commentsCount;

- (void)getComments;
- (void)didFinishLoadingTopComments;
- (void)likeComment:(id)sender;
- (void)didFinishLikeComment;
- (void)performDismiss;
@end
