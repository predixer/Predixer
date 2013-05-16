//
//  DataSystemUserController.h
//  predict
//
//  Created by Joel R Ballesteros on 10/1/12.
//
//

#import <Foundation/Foundation.h>

@class DataSystemUser;

@interface DataSystemUserController : NSObject {
    
    DataSystemUser *sysUser;
    NSMutableArray *arrSystemUser;
    NSMutableData *receivedData;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, strong)DataSystemUser *sysUser;

- (void)checkSystemUser:(NSString *)email pwd:(NSString *)pwd;
- (unsigned)countOfList;
- (DataSystemUser *)objectInListAtIndex:(unsigned)theIndex;

@end
