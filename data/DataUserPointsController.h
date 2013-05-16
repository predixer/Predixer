//
//  DataUserPointsController.h
//  predict
//
//  Created by Joel R Ballesteros on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@class DataUserPoints;

@interface DataUserPointsController : NSObject
{
    NSMutableArray *arrUserPoints;
    NSMutableData *receivedData;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataUserPoints *userPoints;


- (void)getPoints;
- (unsigned)countOfList;
- (DataUserPoints *)objectInListAtIndex:(unsigned)theIndex;

@end