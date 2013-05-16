//
//  DataGrandPrizeController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface DataGrandPrizeController : NSObject
{
    NSMutableArray *arrPrize;
    NSMutableData *receivedData;
        
    NSNotificationCenter *nc;
    
    NSString *strGrandPrize;
    
}

@property(nonatomic, strong)NSString *strGrandPrize;

- (void)getGrandPrize;
- (unsigned)countOfList;

@end
