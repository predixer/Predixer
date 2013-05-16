//
//  DataHowToController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/24/12.
//
//

#import <Foundation/Foundation.h>

@class DataHowTo;

@interface DataHowToController : NSObject
{
    DataHowTo *howTo;
    
    NSMutableArray *arrData;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong) DataHowTo *howTo;

- (void)getHowToText;
- (void)getHowTo;
- (unsigned)countOfList;
//- (NSString *)objectInListAtIndex:(unsigned)theIndex;
- (DataHowTo *)objectInListAtIndex:(unsigned)theIndex;

@end
