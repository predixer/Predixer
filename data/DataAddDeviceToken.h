//
//  DataAddDeviceToken.h
//  predict
//
//  Created by Joel R Ballesteros on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface DataAddDeviceToken : NSObject
{
    NSMutableArray *arrToken;
    NSMutableData *receivedData;
        
    NSNotificationCenter *nc;
    
}

@property(nonatomic, strong)NSString *strGrandPrize;

- (void)addToken:(NSString *)token;
- (unsigned)countOfList;

@end
