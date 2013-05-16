//
//  DataDrawDateController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/28/12.
//
//

#import <Foundation/Foundation.h>

@class DataDrawDate;

@interface DataDrawDateController : NSObject {
    
    DataDrawDate *dataDraw;
    NSMutableArray *arrDraw;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong) DataDrawDate *dataDraw;


- (void)getDrawDate;
- (unsigned)countOfList;
- (DataDrawDate *)objectInListAtIndex:(unsigned)theIndex;

@end
