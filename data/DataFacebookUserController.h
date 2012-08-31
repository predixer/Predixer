//
//  DataFacebookUserController.h
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataFacebookUser;

@interface DataFacebookUserController : NSObject
{
    NSMutableArray *arrUser;
    NSMutableData *receivedData;
    NSString *fbUserID;
    
    BOOL dataReady;
    
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataFacebookUser *facebookUser;
@property (nonatomic, strong)NSString *fbUserID;


- (void)getFBUser;
- (unsigned)countOfList;
- (DataFacebookUser *)objectInListAtIndex:(unsigned)theIndex;


@end
