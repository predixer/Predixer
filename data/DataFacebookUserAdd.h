//
//  DataFacebookUserAdd.h
//  predict
//
//  Created by Joel R Ballesteros on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataFacebookUser;

@interface DataFacebookUserAdd : NSObject
{
    NSMutableData *receivedData;
        
    BOOL dataReady;
    NSNotificationCenter *nc;
    
}

@property (nonatomic, strong)DataFacebookUser *facebookUser;

- (void)addFBUser;
- (void)addUserFacebook;

@end
