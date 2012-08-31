//
//  DataFacebookUserRecordLogin.h
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFacebookUserRecordLogin : NSObject
{
    NSMutableData *receivedData;
    NSString *fbUserID;
    
    BOOL dataReady;
    NSNotificationCenter *nc;
}


@property (nonatomic, strong)NSString *fbUserID;

- (void)updateFBUserLoginRecord;

@end
