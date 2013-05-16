//
//  DataTopCommentsController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@class DataTopComments;
 
@interface DataTopCommentsController : NSObject {
    
    DataTopComments *topComments;
    NSMutableArray *arrComments;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong) DataTopComments *topComments;


- (void)getTopComments;
- (unsigned)countOfList;
- (DataTopComments *)objectInListAtIndex:(unsigned)theIndex;

@end
